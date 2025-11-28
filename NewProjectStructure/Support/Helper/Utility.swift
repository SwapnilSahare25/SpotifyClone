//
//  Utility.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/11/25.
//

import Foundation
import UIKit

final class Utility {
    
    
    private static var loaderView: UIView?
    
    static func showLoader(on view: UIView? = nil, message: String? = nil) {
        DispatchQueue.main.async {
            guard loaderView == nil else { return }
            
            let parentView: UIView
            if let view = view {
                parentView = view
            } else if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                parentView = window
            } else {
                return
            }
            
            let loader = UIView(frame: parentView.bounds)
            loader.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            loader.tag = 9999
            
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .white
            activityIndicator.startAnimating()
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            
            loader.addSubview(activityIndicator)
            activityIndicator.centerXAnchor.constraint(equalTo: loader.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: loader.centerYAnchor).isActive = true
            
            if let message = message {
                let label = UILabel()
                label.text = message
                label.textColor = .white
                label.font = .systemFont(ofSize: 16, weight: .medium)
                label.textAlignment = .center
                label.numberOfLines = 0
                label.translatesAutoresizingMaskIntoConstraints = false
                loader.addSubview(label)
                label.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16).isActive = true
                label.centerXAnchor.constraint(equalTo: loader.centerXAnchor).isActive = true
                label.leadingAnchor.constraint(greaterThanOrEqualTo: loader.leadingAnchor, constant: 16).isActive = true
                label.trailingAnchor.constraint(lessThanOrEqualTo: loader.trailingAnchor, constant: -16).isActive = true
            }
            
            parentView.addSubview(loader)
            loaderView = loader
        }
    }
    
    static func hideLoader() {
        DispatchQueue.main.async {
            loaderView?.removeFromSuperview()
            loaderView = nil
        }
    }
    
    // MARK: - Alert
    static func showAlert(title: String, message: String, on viewController: UIViewController? = nil, okTitle: String = "OK", completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let vc = viewController ?? UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController
            guard let parentVC = vc else { return }
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: okTitle, style: .default) { _ in
                completion?()
            })
            parentVC.present(alert, animated: true)
        }
    }
    
    // MARK: - Debug / Log
    static func printDebug(_ items: Any..., function: String = #function) {
#if DEBUG
        let output = items.map { "\($0)" }.joined(separator: " ")
        print("[DEBUG] \(function): \(output)")
#endif
    }
}

