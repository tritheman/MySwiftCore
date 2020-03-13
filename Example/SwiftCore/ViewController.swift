//
//  ViewController.swift
//  SwiftCore
//
//  Created by tritheman on 03/10/2020.
//  Copyright (c) 2020 tritheman. All rights reserved.
//

import UIKit
import SwiftCore

class ViewController: UIViewController {

    var lastoffset: CGPoint = CGPoint.zero
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var imageTestConstraintGHeight: NSLayoutConstraint!
    var imageTest: UIImageView!
//    @IBOutlet weak var paralaxView: testView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupParallaxHeader()
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
//        imageTest.motionParallax()
//        imageTest.motionMove(CGPoint(x: 0, y: 0), endOffset: CGPoint(x: 0, y: 40), duration: 0, delay: 0)
//        imageTest.motionMove(CGPoint(x: 0, y: 0), endOffset: CGPoint(x: 0, y: 40), duration: 0.1, delay: 0) {
//            self.imageTest.frame.origin = CGPoint(x: 0, y: 0)
//        }
//        imageTest.motionParallax(scale: 0/.5)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y < 0.0 {
//            // Scrolling down: Scale
//            imageTestConstraintGHeight.constant =
//               100 - scrollView.contentOffset.y
//        } else {
//            // Scrolling up: Parallax
//            let parallaxFactor: CGFloat = 0.25
//            let offsetY = scrollView.contentOffset.y * parallaxFactor
//            let minOffsetY: CGFloat = 8.0
//            let availableOffset = min(offsetY, minOffsetY)
//            let contentRectOffsetY = availableOffset / 100
//            imageTestConstraintGHeight.constant = view.frame.origin.y
//            imageTestConstraintGHeight.constant =
//                100 - scrollView.contentOffset.y
//            imageTest.layer.contentsRect =
//                CGRect(x: 0, y: -contentRectOffsetY, width: 1, height: 1)
//        }
    }
}

public class testView: UIView, Parallaxable {
    public func motionParallax(scale : CGFloat = 0.05) {
//
//        let screenFrame = UIScreen.main.bounds
//        let frame = self.convert(self.bounds, to:nil)
//        let center = self.convert(self.center, to: nil)
//
//        let xOffset = (screenFrame.origin.x - center.x / screenFrame.size.width) * (scale * frame.size.width)
//        let yOffset = (screenFrame.origin.y - center.y / screenFrame.size.height) * (scale * frame.size.height)
//
//        let point = CGPoint(x: xOffset, y: yOffset)
        
        self.motionMove(CGPoint(x: 0, y: 0), endOffset: CGPoint(x: 0, y: 40), duration: 0.2, delay: 0)
    }
}

//public class testImageView: UIImageView, Parallaxable { }

