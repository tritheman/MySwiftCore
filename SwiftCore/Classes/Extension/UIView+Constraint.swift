//
//  UIView+Utility.swift
//  DFW
//
//  Created by Patel, Dhaval M on 7/15/16.
//  Copyright © 2016 AT&T. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  // MARK: - Fill
  
  /**
   Creates and adds an array of NSLayoutConstraint objects that relates this view's top, left, bottom and right to its superview, given an optional set of insets for each side. Default parameter values relate this view's top, left, bottom and right to its superview with no insets.
   @note The constraints are also added to this view's superview for you
   :param: edges An amount insets to apply to the top, left, bottom and right constraint. Default value is UIEdgeInsetsZero
   
   :returns: An array of 4 x NSLayoutConstraint objects (top, left, bottom , right) if the superview exists otherwise an empty array
   */
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
  
  // MARK: - Left
  
  /**
   Creates and adds an NSLayoutConstraint that relates this view's left to some specified edge of another view, given a relation and offset. Default parameter values relate this view's left to be equal to the left of the other view.
   @note The new constraint is added to this view's superview for you
   
   :param: view      The other view to relate this view's layout to
   :param: attribute The other view's layout attribute to relate this view's left side to e.g. the other view's right. Default value is NSLayoutAttribute.Left
   :param: relation  The relation of the constraint. Default value is NSLayoutRelation.Equal
   :param: constant  An amount by which to offset this view's left from the other view's specified edge. Default value is 0
   
   :returns: The created NSLayoutConstraint for this left attribute relation
   */
  public func addLeftConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .left, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
    
    let constraint: NSLayoutConstraint = self.createConstraint(attribute: .left, toView: view, attribute: attribute, relation: relation, constant: constant)
    self.superview?.addConstraint(constraint)
    
    return constraint
  }
  
  
  // MARK: - Right
  
  /**
   Creates and adds an NSLayoutConstraint that relates this view's right to some specified edge of another view, given a relation and offset. Default parameter values relate this view's right to be equal to the right of the other view.
   
   @note The new constraint is added to this view's superview for you
   
   :param: view      The other view to relate this view's layout to
   :param: attribute The other view's layout attribute to relate this view's right to e.g. the other view's left. Default value is NSLayoutAttribute.Right
   :param: relation  The relation of the constraint. Default value is NSLayoutRelation.Equal
   :param: constant  An amount by which to offset this view's right from the other view's specified edge. Default value is 0.0
   
   :returns: The created NSLayoutConstraint for this right attribute relation
   */
  public func addRightConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .right, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
    
    let constraint: NSLayoutConstraint = self.createConstraint(attribute: .right, toView: view, attribute: attribute, relation: relation, constant: constant)
    self.superview?.addConstraint(constraint)
    
    return constraint
  }
  
  
  // MARK: - Top
  
  /**
   Creates and adds an NSLayoutConstraint that relates this view's top to some specified edge of another view, given a relation and offset. Default parameter values relate this view's right to be equal to the right of the other view.
   @note The new constraint is added to this view's superview for you
   
   :param: view      The other view to relate this view's layout to
   :param: attribute The other view's layout attribute to relate this view's top to e.g. the other view's bottom. Default value is NSLayoutAttribute.Bottom
   :param: relation  The relation of the constraint. Default value is NSLayoutRelation.Equal
   :param: constant  An amount by which to offset this view's top from the other view's specified edge. Default value is 0.0
   
   :returns: The created NSLayoutConstraint for this top edge layout relation
   */
  public func addTopConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .top, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
    
    let constraint: NSLayoutConstraint = self.createConstraint(attribute: .top, toView: view, attribute: attribute, relation: relation, constant: constant)
    self.superview?.addConstraint(constraint)
    
    return constraint
  }
  
  
  // MARK: - Bottom
  
  /**
   Creates and adds an NSLayoutConstraint that relates this view's bottom to some specified edge of another view, given a relation and offset. Default parameter values relate this view's right to be equal to the right of the other view.
   @note The new constraint is added to this view's superview for you
   
   :param: view      The other view to relate this view's layout to
   
   :param: attribute The other view's layout attribute to relate this view's bottom to e.g. the other view's top. Default value is NSLayoutAttribute.Botom
   :param: relation  The relation of the constraint. Default value is NSLayoutRelation.Equal
   :param: constant  An amount by which to offset this view's bottom from the other view's specified edge. Default value is 0.0
   
   :returns: The created NSLayoutConstraint for this bottom edge layout relation
   */
  public func addBottomConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .bottom, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
    
    let constraint: NSLayoutConstraint = self.createConstraint(attribute: .bottom, toView: view, attribute: attribute, relation: relation, constant: constant)
    self.superview?.addConstraint(constraint)
    
    return constraint
  }
  
  
  // MARK: - Center X
  
  /**
   Creates and adds an NSLayoutConstraint that relates this view's center X attribute to the center X attribute of another view, given a relation and offset. Default parameter values relate this view's center X to be equal to the center X of the other view.
   :param: view     The other view to relate this view's layout to
   :param: relation The relation of the constraint. Default value is NSLayoutRelation.Equal
   :param: constant An amount by which to offset this view's center X attribute from the other view's center X attribute. Default value is 0.0
   
   :returns: The created NSLayoutConstraint for this center X layout relation
   */
  public func addCenterXConstraint(toView view: UIView?, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
    
    let constraint: NSLayoutConstraint = self.createConstraint(attribute: .centerX, toView: view, attribute: .centerX, relation: relation, constant: constant)
    self.superview?.addConstraint(constraint)
    
    return constraint
  }
  
  
  // MARK: - Center Y
  
  /**
   Creates and adds an NSLayoutConstraint that relates this view's center Y attribute to the center Y attribute of another view, given a relation and offset. Default parameter values relate this view's center Y to be equal to the center Y of the other view.
   
   :param: view     The other view to relate this view's layout to
   :param: relation The relation of the constraint. Default value is NSLayoutRelation.Equal
   :param: constant An amount by which to offset this view's center Y attribute from the other view's center Y attribute. Default value is 0.0
   
   :returns: The created NSLayoutConstraint for this center Y layout relation
   */
  public func addCenterYConstraint(toView view: UIView?, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
    
    let constraint: NSLayoutConstraint = self.createConstraint(attribute: .centerY, toView: view, attribute: .centerY, relation: relation, constant: constant)
    self.superview?.addConstraint(constraint)
    
    return constraint
  }
  
  
  // MARK: - Width
  
  /**
   Creates and adds an NSLayoutConstraint that relates this view's width to the width of another view, given a relation and offset. Default parameter values relate this view's width to be equal to the width of the other view.
   
   :param: view     The other view to relate this view's layout to
   :param: relation The relation of the constraint. Default value is NSLayoutRelation.Equal
   :param: constant An amount by which to offset this view's width from the other view's width amount. Default value is 0.0
   
   :returns: The created NSLayoutConstraint for this width layout relation
   */
  public func addWidthConstraint(toView view: UIView?, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
    
    let constraint: NSLayoutConstraint = self.createConstraint(attribute: .width, toView: view, attribute: .width, relation: relation, constant: constant)
    self.superview?.addConstraint(constraint)
    
    return constraint
  }
  
  
  // MARK: - Height
  
  /**
   Creates and adds an NSLayoutConstraint that relates this view's height to the height of another view, given a relation and offset. Default parameter values relate this view's height to be equal to the height of the other view.
   
   :param: view     The other view to relate this view's layout to
   :param: relation The relation of the constraint. Default value is NSLayoutRelation.Equal
   :param: constant An amount by which to offset this view's height from the other view's height amount. Default value is 0.0
   
   :returns: The created NSLayoutConstraint for this height layout relation
   */
  public func addHeightConstraint(toView view: UIView?, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
    
    let constraint: NSLayoutConstraint = self.createConstraint(attribute: .height, toView: view, attribute: .height, relation: relation, constant: constant)
    self.superview?.addConstraint(constraint)
    
    return constraint
  }
  
  // MARK: - Removing Constraints
  
  /**
   removeConstraintsRelatedTo() removes all local constraints related to **view** parameter.  If **recurseUp** is set to true, will call this method on its superview, if any.
   
   :param: view      Constraints with this view will be removed
   :param: recurseUp Call this method on self.superview, if there is one
   
   :returns: The created NSLayoutConstraint for this height layout relation
   */
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
  
  /// removeAllConstraintsRelatedToSelf() will remove all constraints related to self along its view hierarchy up.
  public func removeAllConstraintsRelatedToSelf() {
    removeConstraintsRelatedTo(self, recurseUp: true)
  }
  
  // MARK: - Private
  
  /// Creates an NSLayoutConstraint using its factory method given both views, attributes a relation and offset
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
