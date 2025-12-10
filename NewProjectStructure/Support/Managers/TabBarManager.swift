//
//  TabbarManager.swift
//  NewProjectStructure
//
//  Created by Swapnil on 25/11/25.
//

import Foundation
import UIKit
import AHKNavigationController

class TabBarManager: UITabBarController, UITabBarControllerDelegate {
    
    static let shared = TabBarManager()
    
    private init() {
        super.init(nibName: nil, bundle: nil)
        self.delegate = self
        configureTabBarAppearance()
        
    }
    
    func setupTabs(vcs: [UIViewController], titles: [String], imageNames: [String]) {
        
        var controllers: [UIViewController] = []
        
        for (index, vc) in vcs.enumerated() {
            let imageName = imageNames[index]
            let image = UIImage(named: imageName) ?? UIImage(systemName: "square")
            
            let nav = UINavigationController(rootViewController: vc)
            nav.tabBarItem = UITabBarItem(title: titles[index], image: image, tag: index)
            controllers.append(nav)
        }
        
        self.viewControllers = controllers
        self.selectedIndex = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTabBarAppearance() {

      let appearance = UITabBarAppearance()
         appearance.configureWithOpaqueBackground()

         // Unselected (Regular)
         let normalAttributes: [NSAttributedString.Key: Any] = [
             .foregroundColor: UIColor.gray,
             .font: UIFont.systemFont(ofSize: 12, weight: .regular)
         ]
         appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes

         // Selected (Bold)
         let selectedAttributes: [NSAttributedString.Key: Any] = [
             .foregroundColor: WhiteBgColor,
             .font: UIFont.systemFont(ofSize: 12, weight: .bold)
         ]
         appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes

        tabBar.tintColor = WhiteBgColor
        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = Appcolor
        tabBar.isTranslucent = false

      tabBar.standardAppearance = appearance
//      if #available(iOS 15.0, *) {
//          tabBar.scrollEdgeAppearance = appearance
//      }


    }
    
    
    func tabBarController(_ tabBarController: UITabBarController,didSelect viewController: UIViewController) {
        print("Selected tab: \(viewController.title ?? "")")
    }
    
}
