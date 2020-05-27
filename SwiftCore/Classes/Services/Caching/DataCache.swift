//
//  DataCache.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 5/7/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

extension NSLock {
    func sync<T>(_ closure: () -> T) -> T {
        lock()
        defer { unlock() }
        return closure()
    }
}

// MARK: - DataCaching
public protocol DataCaching {
    func getCache(key: String) -> Data?
    func storeData(_ data: Data, for key: String)
}

public protocol LocachingConfiguration {
    var countLimit: Int { get set }
    var sizeLimit: Int { get set }
    var trimRatio: Double { get set }
}

// MARK: - DataCache

public final class DataCache: DataCaching, LocachingConfiguration {

    public var countLimit: Int = 1000

    public var sizeLimit: Int = 1024 * 1024 * 100

    public var trimRatio = 0.7

    public let path: URL

    public var sweepInterval: TimeInterval = 30

    private var initialSweepDelay: TimeInterval = 10

    // Staging
    private let lock = NSLock()
    private var staging = Staging()
    private var isFlushNeeded = false
    private var isFlushScheduled = false
    var flushInterval: DispatchTimeInterval = .seconds(2)

    public let fileQueue = DispatchQueue(label: "swift.core.tri.DataCache.WriteQueue", target: .global(qos: .utility))

 
    public typealias FilenameGenerator = (_ key: String) -> String?

    private let filenameGenerator: FilenameGenerator

    public convenience init(name: String, filenameGenerator: @escaping (String) -> String? = HashType.sha1.generator) throws {
        guard let root = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            throw NSError(domain: NSCocoaErrorDomain, code: NSFileNoSuchFileError, userInfo: nil)
        }
        
        try self.init(path: root.appendingPathComponent(name, isDirectory: true), filenameGenerator: filenameGenerator)
    }

    public init(path: URL, filenameGenerator: @escaping (String) -> String? = HashType.sha1.generator) throws {
        self.path = path
        self.filenameGenerator = filenameGenerator
        try self.createCacheFolder()
    }

    private func createCacheFolder() throws {
        try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
        initSweepSchedule()
    }
    
    private func initSweepSchedule() {
        fileQueue.asyncAfter(deadline: .now() + initialSweepDelay) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.performAndScheduleSweep()
        }
    }

    public func getCache(key: String) -> Data? {
        lock.lock()
        if let change = staging.change(for: key) {
            lock.unlock()
            switch change { // Change wasn't flushed to disk yet
            case let .add(data):
                return data
            case .remove:
                return nil
            }
        }
        lock.unlock()

        guard let url = url(for: key) else {
            return nil
        }
        return try? Data(contentsOf: url)
    }

    /// Stores data for the given key. The method returns instantly and the data
    /// is written asynchronously.
    public func storeData(_ data: Data, for key: String) {
        stage { staging.add(data: data, for: key) }
    }

    /// Removes data for the given key. The method returns instantly, the data
    /// is removed asynchronously.
    public func removeData(for key: String) {
        stage { staging.removeData(for: key) }
    }

    /// Removes all items. The method returns instantly, the data is removed
    /// asynchronously.
    public func removeAll() {
        stage { staging.removeAll() }
    }

    private func stage(_ change: () -> Void) {
        lock.lock()
        change()
        setNeedsFlushChanges()
        lock.unlock()
    }

    public subscript(key: String) -> Data? {
        get {
            getCache(key: key)
        }
        set {
            if let data = newValue {
                storeData(data, for: key)
            } else {
                removeData(for: key)
            }
        }
    }

    public func filename(for key: String) -> String? {
        filenameGenerator(key)
    }

    public func url(for key: String) -> URL? {
        guard let filename = self.filename(for: key) else {
            return nil
        }
        return self.path.appendingPathComponent(filename, isDirectory: false)
    }

    // MARK: Flush Changes

    /// Synchronously waits on the caller's thread until all outstanding disk I/O
    /// operations are finished.
    public func flush() {
        fileQueue.sync(execute: flushChangesIfNeeded)
    }

    /// Synchronously waits on the caller's thread until all outstanding disk I/O
    /// operations for the given key are finished.
    public func flush(for key: String) {
        fileQueue.sync {
            guard let change = lock.sync({ staging.changes[key] }) else { return }
            perform(change)
            lock.sync { staging.flushed(change) }
        }
    }

    private func setNeedsFlushChanges() {
        guard !isFlushNeeded else { return }
        isFlushNeeded = true
        scheduleNextFlush()
    }

    private func scheduleNextFlush() {
        guard !isFlushScheduled else { return }
        isFlushScheduled = true
        fileQueue.asyncAfter(deadline: .now() + flushInterval, execute: flushChangesIfNeeded)
    }

    private func flushChangesIfNeeded() {
        // Create a snapshot of the recently made changes
        let staging: Staging
        lock.lock()
        guard isFlushNeeded else {
            return lock.unlock()
        }
        staging = self.staging
        isFlushNeeded = false
        lock.unlock()

        // Apply the snapshot to disk
        performChanges(for: staging)

        // Update the staging area and schedule the next flush if needed
        lock.lock()
        self.staging.flushed(staging)
        isFlushScheduled = false
        if isFlushNeeded {
            scheduleNextFlush()
        }
        lock.unlock()
    }

    // MARK: - I/O

    private func performChanges(for staging: Staging) {
        autoreleasepool {
            if let change = staging.changeRemoveAll {
                perform(change)
            }
            for change in staging.changes.values {
                perform(change)
            }
        }
    }

    private func perform(_ change: Staging.ChangeRemoveAll) {
        try? FileManager.default.removeItem(at: self.path)
        try? FileManager.default.createDirectory(at: self.path, withIntermediateDirectories: true, attributes: nil)
    }

    private func perform(_ change: Staging.Change) {
        guard let url = url(for: change.key) else {
            return
        }
        switch change.type {
        case let .add(data):
            do {
                try data.write(to: url)
            } catch let error as NSError {
                guard error.code == CocoaError.fileNoSuchFile.rawValue && error.domain == CocoaError.errorDomain else { return }
                try? FileManager.default.createDirectory(at: self.path, withIntermediateDirectories: true, attributes: nil)
                try? data.write(to: url) // re-create a directory and try again
            }
        case .remove:
            try? FileManager.default.removeItem(at: url)
        }
    }

    // MARK: Sweep

    private func performAndScheduleSweep() {
        performSweep()
        fileQueue.asyncAfter(deadline: .now() + sweepInterval) { [weak self] in
            self?.performAndScheduleSweep()
        }
    }

    /// Synchronously performs a cache sweep and removes the least recently items
    /// which no longer fit in cache.
    public func sweep() {
        fileQueue.sync(execute: performSweep)
    }

    /// Discards the least recently used items first.
    private func performSweep() {
        var items = contents(keys: [.contentAccessDateKey, .totalFileAllocatedSizeKey])
        guard !items.isEmpty else {
            return
        }
        var size = items.reduce(0) { $0 + ($1.meta.totalFileAllocatedSize ?? 0) }
        var count = items.count
        let curZizeLimit = self.sizeLimit / Int(1 / trimRatio)
        let curCountLimit = self.countLimit / Int(1 / trimRatio)

        guard size > curZizeLimit || count > curCountLimit else {
            return // All good, no need to perform any work.
        }

        // Most recently accessed items first
        let past = Date.distantPast
        items.sort { // Sort in place
            ($0.meta.contentAccessDate ?? past) > ($1.meta.contentAccessDate ?? past)
        }

        // Remove the items until it satisfies both size and count limits.
        while (size > curZizeLimit || count > curCountLimit), let item = items.popLast() {
            size -= (item.meta.totalFileAllocatedSize ?? 0)
            count -= 1
            try? FileManager.default.removeItem(at: item.url)
        }
    }

    // MARK: Contents

    struct Entry {
        let url: URL
        let meta: URLResourceValues
    }

    func contents(keys: [URLResourceKey] = []) -> [Entry] {
        guard let urls = try? FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: keys, options: .skipsHiddenFiles) else {
            return []
        }
        let keys = Set(keys)
        return urls.compactMap { (curURL) -> Entry? in
            guard let meta = try? curURL.resourceValues(forKeys: keys) else { return nil }
            return Entry(url: curURL, meta: meta)
        }
    }

    // MARK: Inspection

    /// The total number of items in the cache.
    /// - warning: Requires disk IO, avoid using from the main thread.
    public var totalCount: Int {
        contents().count
    }

    /// The total file size of items written on disk.
    ///
    /// Uses `URLResourceKey.fileSizeKey` to calculate the size of each entry.
    /// The total allocated size (see `totalAllocatedSize`. on disk might
    /// actually be bigger.
    ///
    /// - warning: Requires disk IO, avoid using from the main thread.
    public var totalSize: Int {
        contents(keys: [.fileSizeKey]).reduce(0) {
            $0 + ($1.meta.fileSize ?? 0)
        }
    }

    /// The total file allocated size of all the items written on disk.
    ///
    /// Uses `URLResourceKey.totalFileAllocatedSizeKey`.
    ///
    /// - warning: Requires disk IO, avoid using from the main thread.
    public var totalAllocatedSize: Int {
        contents(keys: [.totalFileAllocatedSizeKey]).reduce(0) {
            $0 + ($1.meta.totalFileAllocatedSize ?? 0)
        }
    }
}

// MARK: - Staging

/// DataCache allows for parallel reads and writes. This is made possible by
/// DataCacheStaging.
///
/// For example, when the data is added in cache, it is first added to staging
/// and is removed from staging only after data is written to disk. Removal works
/// the same way.
private struct Staging {
    private(set) var changes = [String: Change]()
    private(set) var changeRemoveAll: ChangeRemoveAll?

    struct ChangeRemoveAll {
        let id: Int
    }

    struct Change {
        let key: String
        let id: Int
        let type: ChangeType
    }

    enum ChangeType {
        case add(Data)
        case remove
    }

    private var nextChangeId = 0

    // MARK: Changes

    func change(for key: String) -> ChangeType? {
        if let change = changes[key] {
            return change.type
        }
        if changeRemoveAll != nil {
            return .remove
        }
        return nil
    }

    // MARK: Register Changes

    mutating func add(data: Data, for key: String) {
        nextChangeId += 1
        changes[key] = Change(key: key, id: nextChangeId, type: .add(data))
    }

    mutating func removeData(for key: String) {
        nextChangeId += 1
        changes[key] = Change(key: key, id: nextChangeId, type: .remove)
    }

    mutating func removeAll() {
        nextChangeId += 1
        changeRemoveAll = ChangeRemoveAll(id: nextChangeId)
        changes.removeAll()
    }

    // MARK: Flush Changes

    mutating func flushed(_ staging: Staging) {
        for change in staging.changes.values {
            flushed(change)
        }
        if let change = staging.changeRemoveAll {
            flushed(change)
        }
    }

    mutating func flushed(_ change: Change) {
        if let index = changes.index(forKey: change.key),
            changes[index].value.id == change.id {
            changes.remove(at: index)
        }
    }

    mutating func flushed(_ change: ChangeRemoveAll) {
        if changeRemoveAll?.id == change.id {
            changeRemoveAll = nil
        }
    }
}
