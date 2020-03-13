//
//  UIView+Constraint.swift
//  Core
//
//  Created by TriDH on 9/10/18.
//  Copyright © 2018 TriDH. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    public func fillSuperView(_ edges: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        if let superview = self.superview {
            let topConstraint: NSLayoutConstraint = self.addTopConstraint(toView: superview, relation: .equal, constant: edges.top)
            let leftConstraint: NSLayoutConstraint = self.addLeftConstraint(toView: superview, relation: .equal, constant: edges.left)
            let bottomConstraint: NSLayoutConstraint = self.addBottomConstraint(toView: superview, relation: .equal, constant: -edges.bottom)
            let rightConstraint: NSLayoutConstraint = self.addRightConstraint(toView: superview, relation: .equal, constant: -edges.right)
            constraints = [topConstraint, leftConstraint, bottomConstraint, rightConstraint]
        }
        
        return constraints
    }
    
    public func addLeftConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .left, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = self.createConstraint(attribute: .left, toView: view, attribute: attribute, relation: relation, constant: constant)
        self.superview?.addConstraint(constraint)
        
        return constraint
    }
    
    public func addRightConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .right, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = self.createConstraint(attribute: .right, toView: view, attribute: attribute, relation: relation, constant: constant)
        self.superview?.addConstraint(constraint)
        
        return constraint
    }
    
    public func addTopConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .top, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = self.createConstraint(attribute: .top, toView: view, attribute: attribute, relation: relation, constant: constant)
        self.superview?.addConstraint(constraint)
        
        return constraint
    }
    
    public func addBottomConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .bottom, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = self.createConstraint(attribute: .bottom, toView: view, attribute: attribute, relation: relation, constant: constant)
        self.superview?.addConstraint(constraint)
        
        return constraint
    }
    
    public func addCenterXConstraint(toView view: UIView?, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = self.createConstraint(attribute: .centerX, toView: view, attribute: .centerX, relation: relation, constant: constant)
        self.superview?.addConstraint(constraint)
        
        return constraint
    }
    
    public func addCenterYConstraint(toView view: UIView?, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = self.createConstraint(attribute: .centerY, toView: view, attribute: .centerY, relation: relation, constant: constant)
        self.superview?.addConstraint(constraint)
        
        return constraint
    }
    
    public func addWidthConstraint(toView view: UIView?, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = self.createConstraint(attribute: .width, toView: view, attribute: .width, relation: relation, constant: constant)
        self.superview?.addConstraint(constraint)
        
        return constraint
    }
    
    public func addHeightConstraint(toView view: UIView?, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = self.createConstraint(attribute: .height, toView: view, attribute: .height, relation: relation, constant: constant)
        self.superview?.addConstraint(constraint)
        
        return constraint
    }
    
    public func removeConstraintsRelatedTo(_ view:UIView, recurseUp:Bool = true) {
        for constraint in constraints {
            if let item = constraint.firstItem as? UIView {
                if item == view {
                    removeConstraint(constraint)
                    continue
                }
            }
            if let item = constraint.secondItem as? UIView {
                if item == view {
                    removeConstraint(constraint)
                    continue
                }
            }
        }
        if recurseUp {
            if let superview = superview {
                superview.removeConstraintsRelatedTo(view)
            }
        }
    }
    
    public func removeAllConstraintsRelatedToSelf() {
        removeConstraintsRelatedTo(self, recurseUp: true)
    }
    
    fileprivate func createConstraint(attribute attr1: NSLayoutAttribute, toView: UIView?, attribute attr2: NSLayoutAttribute, relation: NSLayoutRelation, constant: CGFloat) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: attr1,
            relatedBy: relation,
            toItem: toView,
            attribute: attr2,
            multiplier: 1.0,
            constant: constant)
        
        return constraint
    }
}

// MARK: - UIViewController

extension UIView {
    
    public var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    public var topViewController: UIViewController? {
        var result:UIViewController? = nil
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                result = viewController
            }
        }
        return result
    }
    
    public func removeSubviews() {
        for child in self.subviews {
            child.removeFromSuperview()
        }
    }
    
    public func removeSubviews(withTag tag:Int) {
        for child in self.subviews.filter({ $0.tag == tag }) {
            child.removeFromSuperview()
        }
    }
    
    public func addDropShadow() {
        addDropShadow(bottomOnly: false)
    }
    
    public func addBottomDropShadow() {
        addDropShadow(bottomOnly: true)
    }
    
    private func addDropShadow(bottomOnly : Bool) {
        let layer = self.layer
        layer.shadowColor = UIColor.black.cgColor
        
        if bottomOnly {
            let path : CGRect = CGRect(x: self.bounds.minX - 1, y: self.bounds.maxY - 1, width: self.bounds.width + 1, height: 3.5)
            layer.shadowPath = UIBezierPath(rect: path).cgPath
            layer.shadowOpacity = 0.25
        }
        else {
            layer.shadowOffset = CGSize(width: 0, height: 1)
            layer.shadowOpacity = 0.1
        }
        layer.shadowRadius = 2
    }
}
