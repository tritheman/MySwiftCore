//
//  ViewController.swift
//  SwiftCore
//
//  Created by tritheman on 03/10/2020.
//  Copyright (c) 2020 tritheman. All rights reserved.
//

import UIKit
//import SwiftCore

class ViewController: UIViewController {

    var lastoffset: CGPoint = CGPoint.zero
    var imageTest: UIImageView!
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    let dataLoader = DataLoader()
    var downloadItems: [String] = ["https://www.dropbox.com/s/6xlpner3s6q336f/file1.mp4?dl=1",
                                   "https://www.dropbox.com/s/73ymbx6icoiqus9/file2.mp4?dl=1",
                                   "https://www.dropbox.com/s/4pw4jwiju0eon6r/file3.mp4?dl=1",
                                   "https://www.dropbox.com/s/2bmbk8id7nseirq/file4.mp4?dl=1",
                                   "https://www.dropbox.com/s/cw7wfyaic9rtzwd/GCDExample-master.zip?dl=1",
                                   "https://www.dropbox.com/s/y9kgs6caztxxjdh/AlecrimCoreData-master.zip?dl=1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func downloadPressed(_ sender: Any) {
        guard let titleString = downloadButton.title(for: .normal), let url = URL(string: titleString) else { return }
        let urlRequest = URLRequest(url: url)
        let curTask = dataLoader.loadData(request: urlRequest, didReceiveData: { [weak self] (curData, urlReponse) in
            guard let strongSelf = self else { return }
//            print("tridh 2 curDownloadData \(curData.count)")
        }) { [weak self] (error) in
            guard let strongSelf = self else { return }
//            print("tridh 2 downloadPressed \(error)")
        }
        
    }
    
    func testCache() {
        let testDataCached = try! DataCache(name: "Tridh2")
        for i in 0...1000 {
            if let youtubeImage = UIImage(named: "Youtube"), let imageData = youtubeImage.pngRepresentationData {
                testDataCached.storeData(imageData, for: "Youtube\(i)")
            }
            let item = testDataCached.getCache(key: "Youtube\(i)")
            print(item)
        }
        testDataCached.removeAll()
    }


    private func setupParallaxHeader() {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "TextSS")
//        imageView.contentMode = .scaleAspectFill
        
//        imageTest = imageView
//        contentScrollView.parallaxHeader.view = imageTest
//        contentScrollView.parallaxHeader.height = 200
//        contentScrollView.parallaxHeader.minimumHeight = 20
//        contentScrollView.parallaxHeader.mode = .topFill
//        contentScrollView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in
//            print(parallaxHeader.progress)
//        }
    }
    
    @IBAction func buttonThisPressed(_ sender: Any) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}


extension ViewController {
    
}

//public class testImageView: UIImageView, Parallaxable { }

