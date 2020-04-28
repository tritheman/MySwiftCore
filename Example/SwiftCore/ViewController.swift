//
//  ViewController.swift
//  SwiftCore
//
//  Created by tritheman on 03/10/2020.
//  Copyright (c) 2020 tritheman. All rights reserved.
//

import UIKit
import SwiftCore


class testAA: Codable, CacheCodable {
    var testString: String = "testString"
    var testFloat: Float = 33
    var testInt: Int = 25
}

struct testBB: Codable, CacheCodable {
    var testString: String = "testString testBB"
    var testFloat: Float = 33
    var testInt: Int = 25
}

class ViewController: UIViewController {

    var lastoffset: CGPoint = CGPoint.zero
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var imageTestConstraintGHeight: NSLayoutConstraint!
    var imageTest: UIImageView!
    let userCache = UserDefaultCache()
//    @IBOutlet weak var paralaxView: testView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupParallaxHeader()
//        userCache.setObject(testAA(), forKey: "testAAtestAA")
//        userCache.setObject(testBB(), forKey: "testBBtestBB")
//        userCache.setObject(true, forKey: "testBoolean")
//        userCache.setObject(25, forKey: "testInt")
//        userCache.saveToDisk()
        
        let test1 = userCache.getObject("testAAtestAA")
        let test2 = userCache.getObject("testBBtestBB")
        let test3 = userCache.getObject("testBoolean")
        let test4 = userCache.getObject("testInt")
//        imageTest.image = UIImage(data: decodeObject.dateTemp!)
        // Do any additional setup after loading the view, typically from a nib.
    }


    private func setupParallaxHeader() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TextSS")
        imageView.contentMode = .scaleAspectFill
        
        imageTest = imageView
        contentScrollView.parallaxHeader.view = imageTest
        contentScrollView.parallaxHeader.height = 200
        contentScrollView.parallaxHeader.minimumHeight = 20
        contentScrollView.parallaxHeader.mode = .topFill
        contentScrollView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in
            print(parallaxHeader.progress)
        }
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

public class testView: UIView, Parallaxable {
    public func motionParallax(scale : CGFloat = 0.05) {
        self.motionMove(CGPoint(x: 0, y: 0), endOffset: CGPoint(x: 0, y: 40), duration: 0.2, delay: 0)
    }
}

//public class testImageView: UIImageView, Parallaxable { }

