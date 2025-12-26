//
//  UIKit+Extension.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/11/25.
//

import Foundation
import UIKit

enum Corner {
    case topLeft, topRight, bottomLeft, bottomRight
}
extension UIView {
    
    // Round specific corners with readable options
    func roundCorners(_ corners: [Corner], radius: CGFloat) {
        var maskedCorners = CACornerMask()
        
        for corner in corners {
            switch corner {
            case .topLeft:
                maskedCorners.insert(.layerMinXMinYCorner)
            case .topRight:
                maskedCorners.insert(.layerMaxXMinYCorner)
            case .bottomLeft:
                maskedCorners.insert(.layerMinXMaxYCorner)
            case .bottomRight:
                maskedCorners.insert(.layerMaxXMaxYCorner)
            }
        }
        
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = maskedCorners
        self.clipsToBounds = true
    }
    
    func addTarget(_ target:Any?, action: Selector){
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tapGesture)
    }
    
    //    func rotateInArabic(){
    //        if !isEnglishLang{
    //            self.transform = CGAffineTransform(scaleX: -1, y: 1)
    //        }
    //    }
    
    func rotate(degrees: CGFloat) {
        rotate(radians: CGFloat.pi * degrees / 180.0)
    }
    func rotate(radians: CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
    
    // MARK: - Corner Radius
    func setCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    // MARK: - Border
    func setBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    // MARK: - Shadow
    func setShadow(color: UIColor = .black,opacity: Float = 0.2,offset: CGSize = CGSize(width: 0, height: 2),radius: CGFloat = 4) {
        
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
    
    // MARK: - Gradient Background
  func setGradientBackground(colors: [UIColor], locations: [NSNumber]) {
          // Remove old gradients to prevent stacking/color muddiness
    self.layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })

            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = colors.map { $0.cgColor }
            gradientLayer.locations = locations

            // --- THIS IS THE KEY CHANGE ---
            // Top-left to bottom-right diagonal creates that "glow" look
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)

            gradientLayer.frame = self.bounds
            self.layer.insertSublayer(gradientLayer, at: 0)
      }
    func fadeIn(duration: TimeInterval = 0.3) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration) {
            self.alpha = 1
        }
    }
    
    func fadeOut(duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }) { _ in
            self.isHidden = true
        }
    }
}

extension UIButton {
    
    func setRounded(radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.height/2
        self.layer.masksToBounds = true
    }
    
    func underlineText() {
        guard let text = self.title(for: .normal) else { return }
        let attributedString = NSAttributedString(
            string: text,
            attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
        )
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

extension UILabel {
    func setLineHeight(_ value: CGFloat) {
        guard let text = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = value
        let attributedString = NSAttributedString(
            string: text,
            attributes: [.paragraphStyle: paragraphStyle]
        )
        self.attributedText = attributedString
    }
    func underline(){
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}


extension UITextField {
    
    func setPadding(left: CGFloat = 8, right: CGFloat = 8) {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.height))
        self.leftView = leftView
        self.leftViewMode = .always
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.height))
        self.rightView = rightView
        self.rightViewMode = .always
    }
    
    func setPlaceholderColor(_ color: UIColor) {
        guard let placeholder = self.placeholder else { return }
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: color]
        )
    }
    func addRightView(icon:String,tintColor: UIColor = PrimaryTextColor,changeHeight: Bool = false,titleStr:String=""){
        let view = UIFactory.makeContinerView(backgroundColor: .clear,frame:  CGRect(x:0, y: 0, width: 20*DeviceMultiplier, height: 37.5*DeviceMultiplier))
        let button = UIButton(type: .custom)
        view.addSubview(button)
        button.setImage(UIImage(named: icon)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setTitle(titleStr, for: .normal)
        button.tintColor = tintColor
        button.frame = CGRect(x:  0, y:  14*DeviceMultiplier, width: 10*DeviceMultiplier, height: 10*DeviceMultiplier)
        button.contentMode = .scaleAspectFit
        
        button.addTarget(self, action: #selector(self.enableFirstResponder), for: .touchUpInside)
        self.rightView = view
        self.rightViewMode = .always
    }
    
    func addLeftView(icon:String,tintColor: UIColor = PrimaryTextColor){
        let view = UIFactory.makeContinerView(backgroundColor: .clear,frame:  CGRect(x:0, y: 0, width: 20*DeviceMultiplier, height: 37.5*DeviceMultiplier))
        let button = UIButton(type: .custom)
        view.addSubview(button)
        button.setImage(UIImage(named: icon)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = tintColor
        button.frame =  CGRect(x:0, y: 14*DeviceMultiplier, width: 10*DeviceMultiplier, height: 10*DeviceMultiplier)
        
        button.addTarget(self, action: #selector(self.enableFirstResponder), for: .touchUpInside)
        self.leftView = view
        self.leftViewMode = .always
    }
    
    @IBAction func enableFirstResponder(_ sender: Any) {
        self.becomeFirstResponder()
    }
    
    @objc func resignFirstRespond(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    
}
extension UIImageView{
    func setImage(urlStr:String, tintColor:UIColor = .clear, activityLoaderRequired:Bool = true){
        if !urlStr.isEmpty{
            if activityLoaderRequired{
                self.kf.indicatorType = .activity
            }
            self.kf.setImage(with: URL(string: urlStr), placeholder: UIImage(named: ""), options: [.transition(.fade(0.5))]){_ in
                if tintColor != .clear{
                    self.image?.withRenderingMode(.alwaysTemplate)
                    self.tintColor = tintColor
                }
            }
        }else{
            self.image = UIImage(named: "FailedImage")
        }
    }
}
extension UICollectionView{
    func addRefreshController(Target:Any?, refreshControll:UIRefreshControl, targetSelector:Selector){
        self.refreshControl = refreshControll
        refreshControll.addTarget(Target, action:
                                    targetSelector,
                                  for: UIControl.Event.valueChanged)
        refreshControll.tintColor = .black
    }
    
}
extension UITableView{
    func addRefreshController(Target:Any?, refreshControll:UIRefreshControl, targetSelector:Selector){
        self.refreshControl = refreshControll
        refreshControll.addTarget(Target, action:
                                    targetSelector,
                                  for: UIControl.Event.valueChanged)
        refreshControll.tintColor = .black
    }
    
}
extension UIColor {
    convenience init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") { hexString.removeFirst() }
        guard hexString.count == 6 else { return nil }

        let scanner = Scanner(string: hexString)
        var hexNumber: UInt64 = 0
        if scanner.scanHexInt64(&hexNumber) {
            let r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
            let g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
            let b = CGFloat(hexNumber & 0x0000FF) / 255
            self.init(red: r, green: g, blue: b, alpha: 1)
            return
        }
        return nil
    }
}
