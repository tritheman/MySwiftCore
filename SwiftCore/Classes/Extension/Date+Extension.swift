//
//  Date+Extension.swift
//  ShopBack
//
//  Created by Dang Huu Tri on 10/27/19.
//  Copyright © 2019 ShopBack. All rights reserved.
//

import Foundation
import UIKit

public extension Date {
    func toDateString() -> String {
        return DateFormatter.dateFormaterStyleYYYYMMDD().string(from: self)
    }
    
    static func initFromString(_ stringDate: String, withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from: stringDate)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        return calendar.date(from:components)
    }
    
    static func initFromString(_ stringDate: String) -> Date? {
        return Date.initFromString(stringDate, withFormat: "yyyy-MM-dd")
    }
}


public extension Date {
    
    /// Returns an NSDate containing the first day and month of the current year
    static var startOfThisYear: Date?{
        return Date.dateWith(year: Date.now.year, month: 1, day: 1)
    }
    
    /// Returns an NSDate containing the last day and month of the current year
    static var endOfThisYear: Date?{
        return Date.dateWith(year: Date.now.year, month: 12, day: 31)
    }
    
    /// Returns the number of expected days in the current year
    static var daysInThisYear: Int{
        return Date.daysIn(year: Date.now.year)
    }
    
    static var now: Date {
        return Date()
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var businessHourString: String {
        var result, period: String
        let hourVal = self.hour
        period = (hourVal < 12) ? "AM" : "PM"
        result = (hourVal > 12) ? "\(hourVal - 12):00 " + period : "\(hourVal):00 " + period
        return result
    }
    
    var businessHourStringInSmallAandP: String {
        var result, period: String
        let hourVal = self.hour
        period = (hourVal < 12) ? "a" : "p"
        result = (hourVal > 12) ? "\(hourVal - 12):00" + period : "\(hourVal):00" + period
        return result
    }
    
    var businessHour: String {
        return (self.hour > 12) ? "\(self.hour - 12):00 " : "\(self.hour):00 "
    }
    
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    var second: Int {
        return Calendar.current.component(.second, from: self)
    }
    
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: self)
    }
    
    var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }
    
    var quarter: Int {
        return Calendar.current.component(.quarter, from: self)
    }
    
    var isPast:Bool {
        return self.isLessThanDate(dateToCompare: Date().truncatedToMidnight())
    }
    
    var daysInMonth: Int {
        var result: Int = 0
        var month1Components, month2components, computedComponents: DateComponents
        
        let calendar = Calendar.current
        
        //Create components for the current month
        month1Components = DateComponents()
        month1Components.year = self.year
        month1Components.month = self.month
        month1Components.day = 1
        
        //Create components for the next sequential month
        month2components = DateComponents()
        month2components.year = (self.month == 12) ? self.year+1 : self.year
        month2components.month = (self.month == 12) ? 1 : self.month+1
        month2components.day = 1
        
        //Compute difference in days
        if let month1Date = calendar.date(from: month1Components), let month2Date = calendar.date(from: month2components){
            computedComponents = (calendar as NSCalendar).components(.day, from: month1Date, to: month2Date, options: .wrapComponents)
            result = computedComponents.day!
        }
        
        return result
    }
    
    var startOfDay: Date? {
        let calendarUnits = NSCalendar.Unit.day.union(.month).union(.year)
        var dateComponents = (Calendar.current as NSCalendar).components(calendarUnits, from: self)
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        return (dateComponents as NSDateComponents).date
    }
    
    var endOfDay: Date? {
        let calendarUnits = NSCalendar.Unit.day.union(.month).union(.year)
        var dateComponents = (Calendar.current as NSCalendar).components(calendarUnits, from: self)
        dateComponents.hour = 23
        dateComponents.minute = 59
        dateComponents.second = 59
        return (dateComponents as NSDateComponents).date
    }
    
    var dateOnlyString: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yyyy"
        return dateformatter.string(from: self)
    }
    
    var timeOnlyString: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
        return dateformatter.string(from: self)
    }
    
    var shortDateString: String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .short
        return dateformatter.string(from: self)
    }
    
    var longDateString: String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .long
        dateformatter.timeStyle = .long
        return dateformatter.string(from: self)
    }
    
    var shortMonthString: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMMMM"
        return dateformatter.string(from: self)
    }
    
    var longMonthString: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMMM"
        return dateformatter.string(from: self)
    }
    
    var monthString: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM"
        return dateformatter.string(from: self)
    }
    
    var ymdString: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMdd"
        return dateformatter.string(from: self)
    }
    
    var weekdayMonthYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM dd"
        return dateFormatter.string(from: self)
    }
    
    var monthYearString: String {
        return String(format: "%@ %li", self.longMonthString, self.year)
    }
    
    var mdyString: String{
        return self.dateOnlyString.replacingOccurrences(of: "/", with: String())
    }
    
    var ymdInteger: Int{
        let interim = self.ymdString as NSString
        return interim.integerValue
    }
    
    var mdyInteger: Int{
        let interim = self.mdyString as NSString
        return interim.integerValue
    }
    
    var utcString: String{
        let dateformatter = DateFormatter()
        dateformatter.timeZone = TimeZone.autoupdatingCurrent
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateformatter.timeZone = TimeZone.autoupdatingCurrent
        dateformatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateformatter.string(from: self)
    }
    
    var datetimeNewRelicString: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy h:mm:ss a"
        dateformatter.timeZone = TimeZone.autoupdatingCurrent
        dateformatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateformatter.string(from: self)
    }
    
    var datetimeString: NSString{
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .medium
        return dateformatter.string(from: self) as NSString
    }
    
    var epochTimeInMilliseconds:Double{
        return floor(self.timeIntervalSince1970 * 1000.0)
    }
    
    var logStyleWithMillisString: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "y-MM-dd HH:mm:ss.SSSZ"
        return dateformatter.string(from: self)
    }
    
    var shortLocalDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
    
    // MARK: Internal Methods
    private static func passesMeridiem(startTime: Date, endTime: Date) -> Bool{
        return ((startTime.hour < 12) && (endTime.hour >= 12)) || ((startTime.hour >= 12) && (endTime.hour < 12))
    }
    
    // MARK: Type Methods
    static func timespanString(startTime: Date, endTime: Date)-> String{
        var result = ""
        if (Date.passesMeridiem(startTime: startTime, endTime: endTime)){
            result = "\(startTime.timeString(withIndicator: true)) - \(endTime.timeString(withIndicator: true))"
        } else {
            result = "\(startTime.timeString(withIndicator: false)) - \(endTime.timeString(withIndicator: true))"
        }
        return result
    }
    
    static func dateWith(year: Int, month: Int, day: Int) -> Date?{
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return Calendar.current.date(from: dateComponents)
    }
    
    static func dateFromYMDString(_ ymdString: NSString) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.date(from: ymdString as String)
    }
    
    static func dateFromCompressedUTCString(_ utcString: NSString) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        return dateFormatter.date(from: utcString as String)
    }
    
    static func daysIn(year: Int) -> Int{
        var result : Int = 0
        var year1Components, year2Components, computedComponents: DateComponents
        let calendar = Calendar.current
        
        //Create components for the current year
        year1Components = DateComponents()
        year1Components.year = year
        year1Components.month = 1
        year1Components.day = 1
        
        //Create components for the next sequential year
        year2Components = DateComponents()
        year2Components.year = year
        year2Components.month = 12
        year2Components.day = 31
        
        //Compute difference in days
        if let year1Date = calendar.date(from: year1Components), let year2Date = calendar.date(from: year2Components){
            computedComponents = (Calendar.current as NSCalendar).components(.day, from: year1Date, to: year2Date, options: .wrapComponents)
            result = computedComponents.day!
        }
        
        return result
    }
    
    static func daysInMonth(_ month: Int, ofYear: Int) -> Int{
        var result = 0
        
        let calendar = Calendar.current
        
        var dateComponents = DateComponents()
        dateComponents.day = 1
        dateComponents.month = month
        dateComponents.year = ofYear
        
        if let dateFromComponents = calendar.date(from: dateComponents){
            result = dateFromComponents.daysInMonth
        }
        
        return result
    }
    
    
    // MARK: Instance Methods
    func timeString(withIndicator:Bool) -> String{
        let dateformatter = DateFormatter()
        if withIndicator{
            dateformatter.dateFormat = "h:mma"
            dateformatter.amSymbol = "a"
            dateformatter.pmSymbol = "p"
        } else {
            dateformatter.dateFormat = "h:mm"
        }
        return dateformatter.string(from: self)
    }
    
    func yearsSince(_ comparisonDate: Date) -> Int{
        let gregorian = Calendar(identifier: .gregorian)
        guard let result = gregorian.dateComponents([.year], from: comparisonDate, to: self).year else {
            return 0
        }
        return result
    }
    
    func monthsSince(_ comparisonDate: Date) -> Int{
        let gregorian = Calendar(identifier: .gregorian)
        guard let result = gregorian.dateComponents([.month], from: comparisonDate, to: self).year else {
            return 0
        }
        return result
    }
    
    func daysSince(_ comparisonDate: Date) -> Int{
        let gregorian = Calendar(identifier: .gregorian)
        guard let result = gregorian.dateComponents([.day], from: comparisonDate, to: self).day else {
            return 0
        }
        return result
    }
    
    func hoursSince(_ comparisonDate: Date) -> Int{
        let gregorian = Calendar(identifier: .gregorian)
        guard let result = gregorian.dateComponents([.hour], from: comparisonDate, to: self).hour else {
            return 0
        }
        return result
    }
    
    func minutesSince(_ comparisonDate: Date) -> Int{
        let gregorian = Calendar(identifier: .gregorian)
        guard let result = gregorian.dateComponents([.minute], from: comparisonDate, to: self).minute else {
            return 0
        }
        return result
    }
    
    func secondsSince(_ comparisonDate: Date) -> Int{
        let gregorian = Calendar(identifier: .gregorian)
        guard let result = gregorian.dateComponents([.second], from: comparisonDate, to: self).second else {
            return 0
        }
        return result
    }
    
    func weeksSince(_ comparisonDate: Date) -> Int{
        let gregorian = Calendar(identifier: .gregorian)
        guard let result = gregorian.dateComponents([.weekOfYear], from: comparisonDate, to: self).weekOfYear else {
            return 0
        }
        return result
    }
    
    func quartersSince(_ comparisonDate: Date) -> Int{
        let gregorian = Calendar(identifier: .gregorian)
        guard let result = gregorian.dateComponents([.quarter], from: comparisonDate, to: self).quarter else {
            return 0
        }
        return result
    }
    
    func add(hours: Int, minutes: Int, seconds: Int) -> Date?{
        var dateComponents = DateComponents()
        dateComponents.hour = hours
        dateComponents.minute = minutes
        dateComponents.second = seconds
        return (Calendar.current as NSCalendar).date(byAdding: dateComponents, to: self, options: .wrapComponents)
    }
    
    func add(years:Int, months: Int, days:Int) -> Date?{
        var dateComponents = DateComponents()
        dateComponents.year = years
        dateComponents.month = months
        dateComponents.day = days
        return (Calendar.current as NSCalendar).date(byAdding: dateComponents, to: self, options: .wrapComponents)
    }
    
    func isBetween(startDate:Date, endDate:Date) -> Bool{
        return ((self.daysSince(startDate)>=0)&&(daysSince(endDate)<=0))
    }
    
    // TODO: Several of these are duplicates of functions above.  They can be removed and uses of them replaced with the corresponding functions above.
    func dateByAddingDays(days: Int) -> Date {
        return self.addingDays(days)
    }
    
    func dateBySubstractingDays(days: Int) -> Date {
        return self.addingDays(-days)
    }
    
    func addingDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func dateByAddingHours(hours: Int) -> Date {
        return self.addingHours(hours)
    }
    
    func dateBySubstractingHours(hours: Int) -> Date {
        return self.addingHours(-hours)
    }
    
    func addingHours(_ hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self)!
    }
    
    func addingMinutes(_ minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func addingSeconds(_ seconds: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: seconds, to: self)!
    }
    
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    func dateAtStartOfDay() -> Date {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components)!
    }
    
    //WARNING: This function is expensive. Using repeatedly can lead to performance issues
    func dateAtStartOfHour() -> Date {
        
        let timeZone = TimeZone.autoupdatingCurrent
        var dateComponents = Calendar.current.dateComponents(in: timeZone, from: self)
        dateComponents.minute = 0
        dateComponents.second = 0
        return Calendar.current.date(from: dateComponents)!
    }
    
    //WARNING: This function is expensive. Using repeatedly can lead to performance issues
    func dateAtStartOfHalfHour() -> Date {
        
        let timeZone = TimeZone.autoupdatingCurrent
        var dateComponents = Calendar.current.dateComponents(in: timeZone, from: self)
        
        if dateComponents.minute! < 30 {
            dateComponents.minute = 0
        } else {
            dateComponents.minute = 30
        }
        
        dateComponents.second = 0
        return Calendar.current.date(from: dateComponents)!
    }
    
    func isGreaterThanDate(dateToCompare : Date) -> Bool {
        return self.compare(dateToCompare) == ComparisonResult.orderedDescending
    }
    
    func isLessThanDate(dateToCompare : Date) -> Bool {
        return self.compare(dateToCompare) == ComparisonResult.orderedAscending
    }
    
    func isEqualToDate(dateToCompare : Date) -> Bool {
        return self.compare(dateToCompare) == ComparisonResult.orderedSame
    }
    
    public var epochTimeInSeconds : Double {
        return epochTimeInMilliseconds / 1000.0
    }
    
    public var epochTimeInMinutes : Double {
        return epochTimeInMilliseconds / 60000.0
    }
    
    public var epochTimeInHours : Double {
        return epochTimeInMilliseconds / 3600000.0
    }
    
    func added(days:Int = 0, hours:Int = 0, minutes:Int = 0, seconds:Int = 0) -> Date {
        var date = self
        if days != 0 {
            date = Calendar.current.date(byAdding: .day, value: days, to: date) ?? date
        }
        if hours != 0 {
            date = Calendar.current.date(byAdding: .hour, value: hours, to: date) ?? date
        }
        if minutes != 0 {
            date = Calendar.current.date(byAdding: .minute, value: minutes, to: date) ?? date
        }
        if seconds != 0 {
            date = Calendar.current.date(byAdding: .second, value: seconds, to: date) ?? date
        }
        return date
    }
    
    func truncatedToMidnight() -> Date {
        return self.dateAtStartOfDay()
    }
    
    func truncatedToHour() -> Date {
        return self.dateAtStartOfHour()
    }
    
    func truncatedToHalfHour() -> Date {
        return self.dateAtStartOfHalfHour()
    }
    
    
    func difference(inDaysFrom date:Date) -> Int {
        return Calendar.current.component(.day, from: self) - Calendar.current.component(.day, from: date)
    }
    
    func difference(inHoursFrom date:Date) -> Int {
        return Calendar.current.component(.hour, from: self) - Calendar.current.component(.hour, from: date)
    }
    
    func difference(inMinutesFrom date:Date) -> Int {
        return Calendar.current.component(.minute, from: self) - Calendar.current.component(.minute, from: date)
    }
    
    func isBetween (date1:Date , date2:Date) -> Bool {
        
        return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
    }
    
    public static func getHoursBetween()->(Date,Date) {
        let date = Date.now
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        
        // 1 hour time range
        let date1 = calendar.date(from: components)
        let date2 = date1?.addingTimeInterval(60*60)
        return (date1!, date2!)
    }
}

extension Date {
    
    func difference(inDaysTo date:Date) -> Int {
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: calendar.startOfDay(for: self), to: calendar.startOfDay(for: date)).day ?? 0
    }
}


extension Date {
    static let dateFormatterForYYYYMMDDHHMMSS:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMddHHmmss"
        return formatter
    }()
    
    static let dateFormatterForYYYYMMDDHHMM:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMddHHmm"
        return formatter
    }()
    
    static let dateFormatterForYYYYMMDDHH:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMddHH"
        return formatter
    }()
    
    static let dateFormatterForMMDDHHMM:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddHHmm"
        return formatter
    }()
    
    static let dateFormatterForMMDDhmm:DateFormatter = {
        let formatter = DateFormatter()
        formatter.amSymbol = "a"
        formatter.pmSymbol = "p"
        formatter.dateFormat = "M/d, h:mma"
        return formatter
    }()
    
    public var YYYYMMDDHHMMSS:String {
        return Date.dateFormatterForYYYYMMDDHHMMSS.string(from: self)
    }
    
    public var YYYYMMDDHHMM:String {
        return Date.dateFormatterForYYYYMMDDHHMM.string(from: self)
    }
    
    public var YYYYMMDDHH:String {
        return Date.dateFormatterForYYYYMMDDHH.string(from: self)
    }
    
    public var MMDDHHMM:String {
        return Date.dateFormatterForMMDDHHMM.string(from: self)
    }
}
extension Date {
    
    public static let  dateFormatterTimeAndTimeSymbol: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "a"
        dateFormatter.pmSymbol = "p"
        dateFormatter.dateFormat = "h:mma"
        return dateFormatter
    }()
    
    public static let weekDayTimeFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
        dateFormatter.amSymbol = "a"
        dateFormatter.pmSymbol = "p"
        dateFormatter.dateFormat = "EEEE, h:mma"
        return dateFormatter
    }()
    
    public static let monthDateYearFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter
    }()
    
    /// Method to show formatted date for Airing On badge
    ///
    /// - Parameters:
    //
    /// - Returns: Date as String (ex: Next Thursday, 7:00p OR Thursday, 7:00p OR Today , 7:00p OR Tomorrow, 7:00p)
    func weekDayTimeString() -> String {
        let kNoOfDaysTillDateToShowLiveMetadata = 14
        if !self.isBetween(date1: Date.now, date2: Date().addingDays(kNoOfDaysTillDateToShowLiveMetadata)){
            return ""
        }
        let dayAfterTomorrowStartOfDay = Date().truncatedToMidnight().addingDays(2)
        let calendar = Calendar.autoupdatingCurrent
        if calendar.isDateInToday(self){
            return "Today, " + Date.dateFormatterTimeAndTimeSymbol.string(from: self)
        }else if calendar.isDateInTomorrow(self){
            return "Tomorrow, " + Date.dateFormatterTimeAndTimeSymbol.string(from: self)
        }else if self.isBetween(date1: dayAfterTomorrowStartOfDay, date2: dayAfterTomorrowStartOfDay.addingDays(5)){
            return Date.weekDayTimeFormatter.string(from: self)
        }else {
            let dayString = Date.dateFormatterForMMDDhmm.string(from: self)
            return dayString
        }
    }
    
    /// Method to show formatted time with hours, minutes and a/p
    ///
    /// - Returns: Date time as String (ex: '10:00a', '1:00p')
    func timeString() -> String {
        return Date.dateFormatterTimeAndTimeSymbol.string(from: self)
    }
    
    /// Method to show time on now badge
    ///
    /// - Parameters:
    ///     - startTime: startTime of the resource
    ///     - endTime: endTime of the resource
    /// - Returns: Date as String (ex: 7:00-8:00pm)
    func getFormattedDate(_ startTime: Date, _ endTime: Date) -> String {
        var timeLeft = ""
        let remainingTime = endTime.timeIntervalSinceNow
        let hours = Int(remainingTime / 3600)
        let minutes = Int((remainingTime - Double(hours) * 3600) / 60)
        if hours > 0 {
            timeLeft += "\(hours)h "
        }
        if minutes > 0 {
            timeLeft += "\(minutes)m left"
        }
        return timeLeft
    }
    
}
