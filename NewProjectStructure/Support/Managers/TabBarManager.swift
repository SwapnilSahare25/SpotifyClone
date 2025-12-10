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
            //let image = UIImage(named: imageName) ?? UIImage(systemName: "square")
            
            let nav = UINavigationController(rootViewController: vc)
            nav.tabBarItem = UITabBarItem(title: titles[index], image: UIImage(systemName: imageName), tag: index)
            controllers.append(nav)
        }
        
        self.viewControllers = controllers
        self.selectedIndex = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTabBarAppearance() {
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = Appcolor
        tabBar.isTranslucent = false


    }
    
    
    func tabBarController(_ tabBarController: UITabBarController,didSelect viewController: UIViewController) {
        print("Selected tab: \(viewController.title ?? "")")
    }
    
}
