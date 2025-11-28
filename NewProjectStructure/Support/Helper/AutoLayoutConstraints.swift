//
//  AutoLayoutConstraints.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/11/25.
//

import Foundation
import UIKit



enum ConstraintType {
    case Leading, Trailing, Top, Bottom
    case FixHeight, FixWidth
    case CenterX, CenterY
    case BelowTo, AboveTo, LeftTo, RightTo
    case HeightLessThanOrEqual, WidthLessThanOrEqual
    case HeightGreaterThanOrEqual, WidthGreaterThanOrEqual
}


extension UIView {
    
    // MARK: - Multi Constraint Helper
    func addConstraints(constraintsDict: [ConstraintType: CGFloat],to view: UIView? = nil,
                        relativeTo relativeView: UIView? = nil,multiplyWithDevice: Bool = false) {
        
        guard let superview = self.superview ?? view else {
            print("ERROR: You must add \(self) to a superview before applying constraints.")
            return
        }
        
        for (type, value) in constraintsDict {
            let constant = multiplyWithDevice ? value * DeviceMultiplier : value
            
            switch type {
                
                // Standard anchors to superview
            case .Leading:
                self.leading(constant: constant)
            case .Trailing:
                self.trailing(constant: constant)
            case .Top:
                self.top(constant: constant)
            case .Bottom:
                self.bottom(constant: constant)
            case .FixHeight:
                self.setHeight(constant)
            case .FixWidth:
                self.setWidth(constant)
            case .CenterX:
                self.centerX(constant: constant)
            case .CenterY:
                self.centerY(constant: constant)
                
                // Relative to another view
            case .BelowTo:
                if let rel = relativeView {
                    self.belowTo(view: rel, constant: constant)
                }
            case .AboveTo:
                if let rel = relativeView {
                    self.aboveTo(view: rel, constant: constant)
                }
            case .LeftTo:
                if let rel = relativeView {
                    self.leftTo(view: rel, constant: constant)
                }
            case .RightTo:
                if let rel = relativeView {
                    self.rightTo(view: rel, constant: constant)
                }
                
                // Min/Max Height / Width
            case .HeightLessThanOrEqual:
                heightLessThanEqual(constant)
            case .WidthLessThanOrEqual:
                widthLessThanEqual(constant)
            case .HeightGreaterThanOrEqual:
                heightGreaterThanEqual(constant)
            case .WidthGreaterThanOrEqual:
                widthGreaterThanEqual(constant)
            }
        }
    }
    
    // MARK: - Standard Anchors
    func leading(constant: CGFloat){
        checkSuperview()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: self.superview!,
                                            attribute: .leading,
                                            multiplier: 1, constant: constant)
        self.superview!.addConstraint(constraint)
    }
    
    func trailing(constant: CGFloat){
        checkSuperview()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .trailing,
                                            relatedBy: .equal,
                                            toItem: self.superview!,
                                            attribute: .trailing,
                                            multiplier: 1, constant: -(constant))
        self.superview!.addConstraint(constraint)
    }
    
    func top(constant: CGFloat){
        checkSuperview()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: self.superview!,
                                            attribute: .top,
                                            multiplier: 1, constant: constant)
        self.superview!.addConstraint(constraint)
    }
    
    func bottom(constant: CGFloat){
        checkSuperview()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: self.superview!,
                                            attribute: .bottom,
                                            multiplier: 1, constant: -(constant))
        self.superview!.addConstraint(constraint)
    }
    
    
    
    func aboveTo(view:UIView,constant: CGFloat){
        checkSuperview()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .top,
                                            multiplier: 1, constant: -(constant))
        self.superview!.addConstraint(constraint)
    }
    
    func belowTo(view:UIView,constant: CGFloat){
        checkSuperview()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .bottom,
                                            multiplier: 1, constant: constant)
        
        self.superview!.addConstraint(constraint)
    }
    
    func rightTo(view:UIView,constant: CGFloat){
        checkSuperview()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .left,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .right,
                                            multiplier: 1, constant: constant)
        self.superview!.addConstraint(constraint)
    }
    
    func leftTo(view:UIView,constant: CGFloat){
        checkSuperview()
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .right,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .left,
                                            multiplier: 1, constant: -constant)
        self.superview!.addConstraint(constraint)
    }
    
    // MARK: - Centering
    func centerX(constant: CGFloat = 0) {
        checkSuperview()
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .centerX,
                                                         relatedBy: .equal,
                                                         toItem: self.superview!,
                                                         attribute: .centerX,
                                                         multiplier: 1.0, constant: constant))
    }
    
    func centerY(constant: CGFloat = 0) {
        checkSuperview()
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .centerY,
                                                         relatedBy: .equal,
                                                         toItem: self.superview!,
                                                         attribute: .centerY,
                                                         multiplier: 1.0, constant: constant))
    }
    
    func centerInSuperview() {
        centerX()
        centerY()
    }
    
    // MARK: - Size
    func setWidth(_ width: CGFloat) {
        let widthConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: width)
        self.superview!.addConstraint(widthConstraint)
    }
    
    func setHeight(_ height: CGFloat) {
        let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: height)
        self.superview!.addConstraint(heightConstraint)
    }
    
    func heightLessThanEqual(_ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(lessThanOrEqualToConstant: height).isActive = true
    }
    
    func widthLessThanEqual(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(lessThanOrEqualToConstant: width).isActive = true
    }
    
    func heightGreaterThanEqual(_ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
    }
    
    func widthGreaterThanEqual(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(greaterThanOrEqualToConstant: width).isActive = true
    }
    
    // MARK: - Equal To Another View
    func equalHeight(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func equalWidth(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    // MARK: - Fill Superview
    //    func fillSuperview(padding: CGFloat = 0, multiplyWithDevice: Bool = false) {
    //        let pad = multiplyWithDevice ? padding * DeviceMultiplier : padding
    //        addConstraints([.top: pad, .leading: pad, .trailing: pad, .bottom: pad])
    //    }
    
    // MARK: - Check Superview
    private func checkSuperview() {
        guard superview != nil else {
            print("ERROR: You need a superview before adding constraints for \(self)")
            return
        }
      self.translatesAutoresizingMaskIntoConstraints = false
    }
}


//extension UIView {
//
//
//    func addConstraints(_ constraintsDict: [ConstraintType: CGFloat],to view: UIView? = nil,
//                        relativeTo relativeView: UIView? = nil,multiplyWithDevice: Bool = false) {
//
//        guard let superview = self.superview ?? view else {
//            print("ERROR: You must add \(self) to a superview before applying constraints.")
//            return
//        }
//
//        for (type, value) in constraintsDict {
//            let constant = multiplyWithDevice ? value*DeviceMultiplier : value
//
//            switch type {
//            case .leading:
//                NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal,
//                                   toItem: superview, attribute: .leading,
//                                   multiplier: 1, constant: constant).isActive = true
//
//            case .trailing:
//                NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal,
//                                   toItem: superview, attribute: .trailing,
//                                   multiplier: 1, constant: CGFloat(-constant)).isActive = true
//
//            case .top:
//                NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal,
//                                   toItem: superview, attribute: .top,
//                                   multiplier: 1, constant: constant).isActive = true
//
//            case .bottom:
//                NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal,
//                                   toItem: superview, attribute: .bottom,
//                                   multiplier: 1, constant: CGFloat(-constant)).isActive = true
//
//            case .fixHeight:
//                NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal,
//                                   toItem: nil, attribute: .notAnAttribute,
//                                   multiplier: 1, constant: constant).isActive = true
//
//            case .fixWidth:
//                NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal,
//                                   toItem: nil, attribute: .notAnAttribute,
//                                   multiplier: 1, constant: constant).isActive = true
//
//            case .centerX:
//                NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal,
//                                   toItem: superview, attribute: .centerX,
//                                   multiplier: 1, constant: 0).isActive = true
//
//            case .centerY:
//                NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal,
//                                   toItem: superview, attribute: .centerY,
//                                   multiplier: 1, constant: 0).isActive = true
//
//            // MARK: - Relation Based (relative to another view)
//            case .belowTo:
//                guard let relView = relativeView else { break }
//                NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal,
//                                   toItem: relView, attribute: .bottom,
//                                   multiplier: 1, constant: constant).isActive = true
//
//            case .aboveTo:
//                guard let relView = relativeView else { break }
//                NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal,
//                                   toItem: relView, attribute: .top,
//                                   multiplier: 1, constant: CGFloat(-constant)).isActive = true
//
//            case .leftTo:
//                guard let relView = relativeView else { break }
//                NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal,
//                                   toItem: relView, attribute: .leading,
//                                   multiplier: 1, constant: CGFloat(-constant)).isActive = true
//
//            case .rightTo:
//                guard let relView = relativeView else { break }
//                NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal,
//                                   toItem: relView, attribute: .trailing,
//                                   multiplier: 1, constant: constant).isActive = true
//
//            // MARK: - Less / Greater Than Constraints
//            case .heightLessThanOrEqual:
//                NSLayoutConstraint(item: self, attribute: .height, relatedBy: .lessThanOrEqual,
//                                   toItem: nil, attribute: .notAnAttribute,
//                                   multiplier: 1, constant: constant).isActive = true
//
//            case .widthLessThanOrEqual:
//                NSLayoutConstraint(item: self, attribute: .width, relatedBy: .lessThanOrEqual,
//                                   toItem: nil, attribute: .notAnAttribute,
//                                   multiplier: 1, constant: constant).isActive = true
//
//            case .heightGreaterThanOrEqual:
//                NSLayoutConstraint(item: self, attribute: .height, relatedBy: .greaterThanOrEqual,
//                                   toItem: nil, attribute: .notAnAttribute,
//                                   multiplier: 1, constant: constant).isActive = true
//
//            case .widthGreaterThanOrEqual:
//                NSLayoutConstraint(item: self, attribute: .width, relatedBy: .greaterThanOrEqual,
//                                   toItem: nil, attribute: .notAnAttribute,
//                                   multiplier: 1, constant: constant).isActive = true
//            }
//        }
//    }
//}


//extension UIView {
//    
//    // MARK: - Multi Constraint Helper
//    func addConstraints(top: CGFloat? = nil,leading: CGFloat? = nil,trailing: CGFloat? = nil,bottom: CGFloat? = nil,
//        width: CGFloat? = nil,height: CGFloat? = nil,to view: UIView? = nil) {
//        guard ensureSuperview() else { return }
//        translatesAutoresizingMaskIntoConstraints = false
//
//        if let top = top, let anchorView = view?.topAnchor ?? superview?.topAnchor {
//            topAnchor.constraint(equalTo: anchorView, constant: top).isActive = true
//        }
//        if let leading = leading, let anchorView = view?.leadingAnchor ?? superview?.leadingAnchor {
//            leadingAnchor.constraint(equalTo: anchorView, constant: leading).isActive = true
//        }
//        if let trailing = trailing, let anchorView = view?.trailingAnchor ?? superview?.trailingAnchor {
//            trailingAnchor.constraint(equalTo: anchorView, constant: -trailing).isActive = true
//        }
//        if let bottom = bottom, let anchorView = view?.bottomAnchor ?? superview?.bottomAnchor {
//            bottomAnchor.constraint(equalTo: anchorView, constant: -bottom).isActive = true
//        }
//        if let width = width {
//            widthAnchor.constraint(equalToConstant: width).isActive = true
//        }
//        if let height = height {
//            heightAnchor.constraint(equalToConstant: height).isActive = true
//        }
//    }
//    
//
//    // MARK: - Relation Based Constraints
//    func belowTo(_ view: UIView, _ constant: CGFloat = 0) {
//        guard ensureSuperview() else { return }
//        translatesAutoresizingMaskIntoConstraints = false
//        topAnchor.constraint(equalTo: view.bottomAnchor, constant: constant).isActive = true
//    }
//
//    func aboveTo(_ view: UIView, _ constant: CGFloat = 0) {
//        guard ensureSuperview() else { return }
//        translatesAutoresizingMaskIntoConstraints = false
//        bottomAnchor.constraint(equalTo: view.topAnchor, constant: -constant).isActive = true
//    }
//
//    func leftTo(of view: UIView, _ constant: CGFloat = 0) {
//        guard ensureSuperview() else { return }
//        translatesAutoresizingMaskIntoConstraints = false
//        trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: -constant).isActive = true
//    }
//
//    func rightTo(of view: UIView, _ constant: CGFloat = 0) {
//        guard ensureSuperview() else { return }
//        translatesAutoresizingMaskIntoConstraints = false
//        leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant).isActive = true
//    }
//
//    // MARK: - Standard Anchors
//    func top(to anchor: NSLayoutYAxisAnchor, _ constant: CGFloat = 0) {
//        guard ensureSuperview() else { return }
//        translatesAutoresizingMaskIntoConstraints = false
//        topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
//    }
//
//    func bottom(to anchor: NSLayoutYAxisAnchor, _ constant: CGFloat = 0) {
//        guard ensureSuperview() else { return }
//        translatesAutoresizingMaskIntoConstraints = false
//        bottomAnchor.constraint(equalTo: anchor, constant: -constant).isActive = true
//    }
//
//    func leading(to anchor: NSLayoutXAxisAnchor, _ constant: CGFloat = 0) {
//        guard ensureSuperview() else { return }
//        translatesAutoresizingMaskIntoConstraints = false
//        leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
//    }
//
//    func trailing(to anchor: NSLayoutXAxisAnchor, _ constant: CGFloat = 0) {
//        guard ensureSuperview() else { return }
//        translatesAutoresizingMaskIntoConstraints = false
//        trailingAnchor.constraint(equalTo: anchor, constant: -constant).isActive = true
//    }
//
//    // MARK: - Centering
//    func centerX(to view: UIView? = nil) {
//        guard ensureSuperview() else { return }
//        translatesAutoresizingMaskIntoConstraints = false
//        centerXAnchor.constraint(equalTo: (view ?? superview!).centerXAnchor).isActive = true
//    }
//
//    func centerY(to view: UIView? = nil) {
//        guard ensureSuperview() else { return }
//        translatesAutoresizingMaskIntoConstraints = false
//        centerYAnchor.constraint(equalTo: (view ?? superview!).centerYAnchor).isActive = true
//    }
//
//    func centerInSuperview() {
//        guard ensureSuperview() else { return }
//        centerX()
//        centerY()
//    }
//
//    // MARK: - Size
//    func setWidth(_ width: CGFloat) {
//        translatesAutoresizingMaskIntoConstraints = false
//        widthAnchor.constraint(equalToConstant: width).isActive = true
//    }
//
//    func setHeight(_ height: CGFloat) {
//        translatesAutoresizingMaskIntoConstraints = false
//        heightAnchor.constraint(equalToConstant: height).isActive = true
//    }
//
//    // MARK: - Fill Superview
//    func fillSuperview(padding: CGFloat = 0) {
//        addConstraints(top: padding, leading: padding, trailing: padding, bottom: padding)
//    }
//
//    // MARK: - Check Superview Exists
//       private func ensureSuperview() -> Bool {
//           if superview == nil {
//               print("ERROR: You must add \(self) to a superview before applying constraints.")
//               return false
//           }
//           return true
//       }
//   
//}
