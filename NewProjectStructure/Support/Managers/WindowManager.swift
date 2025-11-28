//
//  WindowManager.swift
//  NewProjectStructure
//
//  Created by Swapnil on 27/11/25.
//

import Foundation
import UIKit

class WindowManager {
    
    static let shared = WindowManager() // singleton
    private init() {}
    
    func setRootController(_ controller: UIViewController, animated: Bool = true) {
        guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows
                .first else { return }

        if animated {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = controller
            }, completion: nil)
        } else {
            window.rootViewController = controller
        }
    }
}
