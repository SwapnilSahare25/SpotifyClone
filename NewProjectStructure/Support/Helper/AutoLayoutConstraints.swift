//
//  AutoLayoutConstraints.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/11/25.
//

import Foundation
import UIKit



// MARK: - Constraint Types
public enum ConstraintType {
    // Anchors to the view's edges (ignoring safe area, stretching to the absolute bounds of the device)
    case Leading, Trailing, Top, Bottom

    // Anchors specifically to Safe Area Layout Guides. Use these for content (text, buttons) that must never be under the notch, Dynamic Island, or home indicator.
    case SafeTop, SafeBottom, SafeLeading, SafeTrailing

    // Fixed Dimensions
    case FixHeight, FixWidth

    // Centering
    case CenterX, CenterY

    // Relational positioning (Next to, below, etc.)
    case BelowTo, AboveTo, LeftTo, RightTo

    // Inequalities
    case HeightLessThanOrEqual, WidthLessThanOrEqual
    case HeightGreaterThanOrEqual, WidthGreaterThanOrEqual
}

// MARK: - Responsive Metrics & Adaptive Scaling
// A base width standard (iPhone 11/12/13/14 Pro/Max are typically around 390-430)
// You can adjust this globally depending on which device you are using in Figma/Storyboard right now!
// For example, if you are designing a specific screen using an iPhone 15 Pro Max layout, change this to 430.

public var globalDesignBaseWidth: CGFloat = 375.0 // Default: iPhone X/11/13 Mini standard

@MainActor
public var DeviceMultiplier: CGFloat {
    return UIScreen.main.bounds.width / globalDesignBaseWidth
}

@MainActor
public extension CGFloat {

  // Adaptive scaling based on actual screen width
  // Automatically calculates perfect proportions preventing cropping or clipping on any device format.


//    var adaptive: CGFloat {
//        let actualScreenWidth = UIScreen.main.bounds.width
//        return (self / globalDesignBaseWidth) * actualScreenWidth
//    }
  
  var adaptive: CGFloat {
        return self * DeviceMultiplier
    }

  // Smart spacing for margins (Apple-style scaling)
    static var DeviceMargin: CGFloat {
        let width = UIScreen.main.bounds.width
        switch width {
        case 0...375:  // iPhone SE, Mini
            return 16
        case 376...430: // iPhone Base & Pro Models
            return 20
        default:       // Plus, Max, and iPads
            return 24
        }
    }
}


// MARK: - Device Metrics (2026 Standards)
@MainActor
public struct DeviceMetrics {
    // Total height of the top area (Status Bar/Dynamic Island + Navigation Bar)
    public static var topBarHeight: CGFloat {
        let statusBarHeight = UIWindow.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navBarHeight: CGFloat = 44.0 // Standard UINavigationBar height
        return statusBarHeight + navBarHeight
    }

    // Standard margin based on Apple Human Interface Guidelines
    public static var margin: CGFloat {
        return CGFloat.DeviceMargin
    }
}


@MainActor
public extension UIWindow {
    // Modern approach to fetching the active key window considering multiple scenes
    static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}

// MARK: - Auto Layout Extension (MainActor Isolated for 2026 UI Safety)
@MainActor
public extension UIView {

    // Prepares a view for Auto Layout safety
    private func prepareForAutoLayout(in superview: UIView?) -> Bool {
        let targetSuperview = superview ?? self.superview
        guard targetSuperview != nil else {
            print("⚠️ AutoLayout Error: Cannot add constraints to \(self). It has no valid superview.")
            return false
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        return true
    }

    // Primary constraints API
    func addConstraints(constraintsDict: [ConstraintType: CGFloat], to targetView: UIView? = nil, relativeTo relativeView: UIView? = nil) {
        let parentView = targetView ?? self.superview
        guard prepareForAutoLayout(in: parentView), let validSuperview = parentView else { return }

        // Compile constraints into an array to activate them simultaneously (Performance Best Practice)
        var constraintsToActivate: [NSLayoutConstraint] = []

        for (type, rawConstant) in constraintsDict {
            let constant = rawConstant.adaptive

            switch type {
            // MARK: Absolute Superview Edges
            // Apple HIG: Backgrounds, imagery, and immersive content should extend to the hardware edges.
            case .Leading:
                constraintsToActivate.append(leadingAnchor.constraint(equalTo: validSuperview.leadingAnchor, constant: constant))
            case .Trailing:
                constraintsToActivate.append(trailingAnchor.constraint(equalTo: validSuperview.trailingAnchor, constant: -constant))
            case .Top:
                constraintsToActivate.append(topAnchor.constraint(equalTo: validSuperview.topAnchor, constant: constant))
            case .Bottom:
                constraintsToActivate.append(bottomAnchor.constraint(equalTo: validSuperview.bottomAnchor, constant: -constant))

            // MARK: Safe Area Edges
            // Apple HIG: Interactive controls and readable content must map to the safe area.
            case .SafeTop:
                constraintsToActivate.append(topAnchor.constraint(equalTo: validSuperview.safeAreaLayoutGuide.topAnchor, constant: constant))
            case .SafeBottom:
                constraintsToActivate.append(bottomAnchor.constraint(equalTo: validSuperview.safeAreaLayoutGuide.bottomAnchor, constant: -constant))
            case .SafeLeading:
                constraintsToActivate.append(leadingAnchor.constraint(equalTo: validSuperview.safeAreaLayoutGuide.leadingAnchor, constant: constant))
            case .SafeTrailing:
                constraintsToActivate.append(trailingAnchor.constraint(equalTo: validSuperview.safeAreaLayoutGuide.trailingAnchor, constant: -constant))

            // MARK: Fixed Sizes
            case .FixHeight:
                constraintsToActivate.append(heightAnchor.constraint(equalToConstant: constant))
            case .FixWidth:
                constraintsToActivate.append(widthAnchor.constraint(equalToConstant: constant))

            // MARK: Inequalities
            case .HeightLessThanOrEqual:
                constraintsToActivate.append(heightAnchor.constraint(lessThanOrEqualToConstant: constant))
            case .WidthLessThanOrEqual:
                constraintsToActivate.append(widthAnchor.constraint(lessThanOrEqualToConstant: constant))
            case .HeightGreaterThanOrEqual:
                constraintsToActivate.append(heightAnchor.constraint(greaterThanOrEqualToConstant: constant))
            case .WidthGreaterThanOrEqual:
                constraintsToActivate.append(widthAnchor.constraint(greaterThanOrEqualToConstant: constant))

            // MARK: Centering
            case .CenterX:
                constraintsToActivate.append(centerXAnchor.constraint(equalTo: validSuperview.centerXAnchor, constant: constant))
            case .CenterY:
                constraintsToActivate.append(centerYAnchor.constraint(equalTo: validSuperview.centerYAnchor, constant: constant))

            // MARK: Relative Positioning
            case .BelowTo:
                if let rel = relativeView {
                    constraintsToActivate.append(topAnchor.constraint(equalTo: rel.bottomAnchor, constant: constant))
                }
            case .AboveTo:
                if let rel = relativeView {
                    constraintsToActivate.append(bottomAnchor.constraint(equalTo: rel.topAnchor, constant: -constant))
                }
            case .LeftTo:
                if let rel = relativeView {
                    constraintsToActivate.append(trailingAnchor.constraint(equalTo: rel.leadingAnchor, constant: -constant))
                }
            case .RightTo:
                if let rel = relativeView {
                    constraintsToActivate.append(leadingAnchor.constraint(equalTo: rel.trailingAnchor, constant: constant))
                }
            }
        }

        // Batch activation is highly recommended by Apple for layout engine performance
        NSLayoutConstraint.activate(constraintsToActivate)
    }

    // MARK: - HIG Compliant Convenience Helpers

    // Centers the view inside its superview.
    func centerInSuperview(offsetX: CGFloat = 0, offsetY: CGFloat = 0) {
        guard prepareForAutoLayout(in: nil), let superview = self.superview else { return }
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offsetX),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offsetY)
        ])
    }

    // Match width and height of another view
    func matchSize(of view: UIView, widthOffset: CGFloat = 0, heightOffset: CGFloat = 0) {
        _ = prepareForAutoLayout(in: nil)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: view.widthAnchor, constant: widthOffset),
            heightAnchor.constraint(equalTo: view.heightAnchor, constant: heightOffset)
        ])
    }

    // Fills the superview COMPLETELY, edge-to-edge (ignores safe area).
    // Apple HIG (Immersive Content): Use this for full-bleed backgrounds and imagery.
    func fillSuperview(padding: CGFloat = 0) {
        guard prepareForAutoLayout(in: nil), let superview = self.superview else { return }
        let pad = padding.adaptive
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: pad),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: pad),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -pad),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -pad)
        ])
    }

    // Fills the superview strictly within the SAFE AREA constraints.
    // Apple HIG (Readable Content): Use this for standard layout containers, text, and interactive elements.
    func fillSafeArea(padding: CGFloat = 0) {
        guard prepareForAutoLayout(in: nil), let superview = self.superview else { return }
        let pad = padding.adaptive
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: pad),
            leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: pad),
            trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -pad),
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -pad)
        ])
    }
}


//enum ConstraintType {
//    case Leading, Trailing, Top, Bottom
//    case FixHeight, FixWidth
//    case CenterX, CenterY
//    case BelowTo, AboveTo, LeftTo, RightTo
//    case HeightLessThanOrEqual, WidthLessThanOrEqual
//    case HeightGreaterThanOrEqual, WidthGreaterThanOrEqual
//}
//
//extension UIView {
//
//    // MARK: - Main Constraint API
//    func addConstraints(constraintsDict: [ConstraintType: CGFloat],to view: UIView? = nil, relativeTo relativeView: UIView? = nil) {
//
//        guard let superview = self.superview ?? view else {
//            print("ERROR: Add view to superview before constraints.")
//            return
//        }
//
//        translatesAutoresizingMaskIntoConstraints = false
//
//        for (type, value) in constraintsDict {
//
//            let constant = value.adaptive
//
//            switch type {
//
//            // MARK: - Superview Anchors
//            case .Leading:
//                leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant).isActive = true
//
//            case .Trailing:
//                trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -constant).isActive = true
//
//            case .Top:
//                topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
//
//            case .Bottom:
//                bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -constant).isActive = true
//
//            // MARK: - Size
//            case .FixHeight:
//                heightAnchor.constraint(equalToConstant: constant).isActive = true
//
//            case .FixWidth:
//                widthAnchor.constraint(equalToConstant: constant).isActive = true
//
//            case .HeightLessThanOrEqual:
//                heightAnchor.constraint(lessThanOrEqualToConstant: constant).isActive = true
//
//            case .WidthLessThanOrEqual:
//                widthAnchor.constraint(lessThanOrEqualToConstant: constant).isActive = true
//
//            case .HeightGreaterThanOrEqual:
//                heightAnchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
//
//            case .WidthGreaterThanOrEqual:
//                widthAnchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
//
//            // MARK: - Center
//            case .CenterX:
//                centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: constant).isActive = true
//
//            case .CenterY:
//                centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: constant).isActive = true
//
//
//            // MARK: - Relative Anchors
//            case .BelowTo:
//                if let rel = relativeView {
//                    topAnchor.constraint(equalTo: rel.bottomAnchor, constant: constant).isActive = true
//                }
//
//            case .AboveTo:
//                if let rel = relativeView {
//                    bottomAnchor.constraint(equalTo: rel.topAnchor, constant: -constant).isActive = true
//                }
//
//            case .LeftTo:
//                if let rel = relativeView {
//                    trailingAnchor.constraint(equalTo: rel.leadingAnchor, constant: -constant).isActive = true
//                }
//
//            case .RightTo:
//                if let rel = relativeView {
//                    leadingAnchor.constraint(equalTo: rel.trailingAnchor, constant: constant).isActive = true
//                }
//            }
//        }
//    }
//
//    // MARK: - Center in Superview
//
//    func centerInSuperview() {
//        guard let superview = superview else { return }
//        translatesAutoresizingMaskIntoConstraints = false
//        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
//        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
//    }
//
//    // MARK: - Equal Size Helpers
//
//    func equalHeight(to view: UIView) {
//        translatesAutoresizingMaskIntoConstraints = false
//        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
//    }
//
//    func equalWidth(to view: UIView) {
//        translatesAutoresizingMaskIntoConstraints = false
//        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//    }
//
//    // MARK: - Fill Superview
//
//    func fillSuperview(padding: CGFloat = 0) {
//        guard let superview = superview else { return }
//        translatesAutoresizingMaskIntoConstraints = false
//
//        let pad = padding.adaptive
//
//        NSLayoutConstraint.activate([
//            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: pad),
//            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: pad),
//            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -pad),
//            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -pad)
//        ])
//    }
//}


//extension UIView {
//    
//    // MARK: - Multi Constraint Helper
//    func addConstraints(constraintsDict: [ConstraintType: CGFloat],to view: UIView? = nil,
//                        relativeTo relativeView: UIView? = nil) {
//
//        guard let superview = self.superview ?? view else {
//            print("ERROR: You must add \(self) to a superview before applying constraints.")
//            return
//        }
//        
//        for (type, value) in constraintsDict {
//            //let constant = multiplyWithDevice ? value * DeviceMultiplier : value
//
//            switch type {
//                
//                // Standard anchors to superview
//            case .Leading:
//                self.leading(constant: value)
//            case .Trailing:
//                self.trailing(constant: value)
//            case .Top:
//                self.top(constant: value)
//            case .Bottom:
//                self.bottom(constant: value)
//            case .FixHeight:
//                self.setHeight(value.scaled)
//            case .FixWidth:
//                self.setWidth(value.scaled)
//            case .CenterX:
//                self.centerX(constant: value)
//            case .CenterY:
//                self.centerY(constant: value)
//
//                // Relative to another view
//            case .BelowTo:
//                if let rel = relativeView {
//                    self.belowTo(view: rel, constant: value)
//                }
//            case .AboveTo:
//                if let rel = relativeView {
//                    self.aboveTo(view: rel, constant: value)
//                }
//            case .LeftTo:
//                if let rel = relativeView {
//                    self.leftTo(view: rel, constant: value)
//                }
//            case .RightTo:
//                if let rel = relativeView {
//                    self.rightTo(view: rel, constant: value)
//                }
//                
//                // Min/Max Height / Width
//            case .HeightLessThanOrEqual:
//                heightLessThanEqual(value.scaled)
//            case .WidthLessThanOrEqual:
//                widthLessThanEqual(value.scaled)
//            case .HeightGreaterThanOrEqual:
//                heightGreaterThanEqual(value.scaled)
//            case .WidthGreaterThanOrEqual:
//                widthGreaterThanEqual(value.scaled)
//            }
//        }
//    }
//    
//    // MARK: - Standard Anchors
//    func leading(constant: CGFloat){
//        checkSuperview()
//        let constraint = NSLayoutConstraint(item: self,
//                                            attribute: .leading,
//                                            relatedBy: .equal,
//                                            toItem: self.superview!,
//                                            attribute: .leading,
//                                            multiplier: 1, constant: constant)
//        self.superview!.addConstraint(constraint)
//    }
//    
//    func trailing(constant: CGFloat){
//        checkSuperview()
//        let constraint = NSLayoutConstraint(item: self,
//                                            attribute: .trailing,
//                                            relatedBy: .equal,
//                                            toItem: self.superview!,
//                                            attribute: .trailing,
//                                            multiplier: 1, constant: -(constant))
//        self.superview!.addConstraint(constraint)
//    }
//    
//    func top(constant: CGFloat){
//        checkSuperview()
//        let constraint = NSLayoutConstraint(item: self,
//                                            attribute: .top,
//                                            relatedBy: .equal,
//                                            toItem: self.superview!,
//                                            attribute: .top,
//                                            multiplier: 1, constant: constant)
//        self.superview!.addConstraint(constraint)
//    }
//    
//    func bottom(constant: CGFloat){
//        checkSuperview()
//        let constraint = NSLayoutConstraint(item: self,
//                                            attribute: .bottom,
//                                            relatedBy: .equal,
//                                            toItem: self.superview!,
//                                            attribute: .bottom,
//                                            multiplier: 1, constant: -(constant))
//        self.superview!.addConstraint(constraint)
//    }
//    
//    
//    
//    func aboveTo(view:UIView,constant: CGFloat){
//        checkSuperview()
//        let constraint = NSLayoutConstraint(item: self,
//                                            attribute: .bottom,
//                                            relatedBy: .equal,
//                                            toItem: view,
//                                            attribute: .top,
//                                            multiplier: 1, constant: -(constant))
//        self.superview!.addConstraint(constraint)
//    }
//    
//    func belowTo(view:UIView,constant: CGFloat){
//        checkSuperview()
//        let constraint = NSLayoutConstraint(item: self,
//                                            attribute: .top,
//                                            relatedBy: .equal,
//                                            toItem: view,
//                                            attribute: .bottom,
//                                            multiplier: 1, constant: constant)
//        
//        self.superview!.addConstraint(constraint)
//    }
//    
//    func rightTo(view:UIView,constant: CGFloat){
//        checkSuperview()
//        let constraint = NSLayoutConstraint(item: self,
//                                            attribute: .left,
//                                            relatedBy: .equal,
//                                            toItem: view,
//                                            attribute: .right,
//                                            multiplier: 1, constant: constant)
//        self.superview!.addConstraint(constraint)
//    }
//    
//    func leftTo(view:UIView,constant: CGFloat){
//        checkSuperview()
//        let constraint = NSLayoutConstraint(item: self,
//                                            attribute: .right,
//                                            relatedBy: .equal,
//                                            toItem: view,
//                                            attribute: .left,
//                                            multiplier: 1, constant: -constant)
//        self.superview!.addConstraint(constraint)
//    }
//    
//    // MARK: - Centering
//    func centerX(constant: CGFloat = 0) {
//        checkSuperview()
//        self.superview!.addConstraint(NSLayoutConstraint(item: self,
//                                                         attribute: .centerX,
//                                                         relatedBy: .equal,
//                                                         toItem: self.superview!,
//                                                         attribute: .centerX,
//                                                         multiplier: 1.0, constant: constant))
//    }
//    
//    func centerY(constant: CGFloat = 0) {
//        checkSuperview()
//        self.superview!.addConstraint(NSLayoutConstraint(item: self,
//                                                         attribute: .centerY,
//                                                         relatedBy: .equal,
//                                                         toItem: self.superview!,
//                                                         attribute: .centerY,
//                                                         multiplier: 1.0, constant: constant))
//    }
//    
//    func centerInSuperview() {
//        centerX()
//        centerY()
//    }
//    
//    // MARK: - Size
//  // MARK: - Size
//  func setWidth(_ width: CGFloat) {
//      translatesAutoresizingMaskIntoConstraints = false
//      widthAnchor.constraint(equalToConstant: width).isActive = true
//  }
//
//  func setHeight(_ height: CGFloat) {
//      translatesAutoresizingMaskIntoConstraints = false
//      heightAnchor.constraint(equalToConstant: height).isActive = true
//  }
//
//  func heightLessThanEqual(_ height: CGFloat) {
//      translatesAutoresizingMaskIntoConstraints = false
//      heightAnchor.constraint(lessThanOrEqualToConstant: height).isActive = true
//  }
//
//  func widthLessThanEqual(_ width: CGFloat) {
//      translatesAutoresizingMaskIntoConstraints = false
//      widthAnchor.constraint(lessThanOrEqualToConstant: width).isActive = true
//  }
//
//  func heightGreaterThanEqual(_ height: CGFloat) {
//      translatesAutoresizingMaskIntoConstraints = false
//      heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
//  }
//
//  func widthGreaterThanEqual(_ width: CGFloat) {
//      translatesAutoresizingMaskIntoConstraints = false
//      widthAnchor.constraint(greaterThanOrEqualToConstant: width).isActive = true
//  }
//
//  // MARK: - Equal To Another View (NO SCALING)
//  func equalHeight(to view: UIView) {
//      translatesAutoresizingMaskIntoConstraints = false
//      heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
//  }
//
//  func equalWidth(to view: UIView) {
//      translatesAutoresizingMaskIntoConstraints = false
//      widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//  }
//
//    
//    // MARK: - Fill Superview
//    //    func fillSuperview(padding: CGFloat = 0, multiplyWithDevice: Bool = false) {
//    //        let pad = multiplyWithDevice ? padding * DeviceMultiplier : padding
//    //        addConstraints([.top: pad, .leading: pad, .trailing: pad, .bottom: pad])
//    //    }
//    
//    // MARK: - Check Superview
//    private func checkSuperview() {
//        guard superview != nil else {
//            print("ERROR: You need a superview before adding constraints for \(self)")
//            return
//        }
//      self.translatesAutoresizingMaskIntoConstraints = false
//    }
//}


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
