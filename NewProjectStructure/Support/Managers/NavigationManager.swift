//
//  NavigationManager.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/11/25.
//

import Foundation
import UIKit
import AHKNavigationController


class NavigationManager {
    
    // Singleton
      static let shared = NavigationManager()
      private init() {}

      // MARK: - Push VC
      func push(_ viewController: UIViewController, on navigationController: UINavigationController?, animated: Bool = true) {
          guard let nav = navigationController else {
              print("NavigationController not found!")
              return
          }
          nav.pushViewController(viewController, animated: animated)
      }
    
    // MARK: - Pop VC
    func pop(_ navigationController: UINavigationController?, animated: Bool = true) {
            guard let nav = navigationController else {
                print("NavigationController not found!")
                return
            }
            nav.popViewController(animated: animated)
        }
    
    // MARK: - Pop to Root
    func popToViewController<T: UIViewController>(nav: UINavigationController, ofType type: T.Type, animated: Bool = true) {
          for controller in nav.viewControllers {
              if controller.isKind(of: type) {
                  nav.popToViewController(controller, animated: animated)
                  return
              }
          }
          print("ViewController of type \(T.self) not found in stack")
      }
//    NavigationManager.shared.popToViewController(ofType: HomeVC.self)

    
    // MARK: - Present VC
      func present(_ viewController: UIViewController, from parentVC: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
          parentVC.present(viewController, animated: animated, completion: completion)
      }

      // MARK: - Dismiss VC
      func dismiss(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
          viewController.dismiss(animated: animated, completion: completion)
      }
    
    func createNavigationController(rootViewController: UIViewController,prefersLargeTitles: Bool = false,backgroundColor: UIColor = .white,tintColor: UIColor = .white,
                                       titleColor: UIColor = .label,titleFont: UIFont = .boldSystemFont(ofSize: 18)) -> AHKNavigationController {

           let nav = AHKNavigationController(rootViewController: rootViewController)
           nav.navigationBar.prefersLargeTitles = prefersLargeTitles
           nav.navigationBar.barTintColor = backgroundColor
           nav.navigationBar.tintColor = tintColor
           nav.navigationBar.isTranslucent = false

           nav.navigationBar.titleTextAttributes = [.foregroundColor: titleColor,.font: titleFont]

           nav.navigationBar.largeTitleTextAttributes = [.foregroundColor: titleColor,.font: titleFont]

           // Remove shadow if needed
           nav.navigationBar.shadowImage = UIImage()

           return nav
       }
}
