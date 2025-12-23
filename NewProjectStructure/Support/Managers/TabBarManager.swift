//
//  TabbarManager.swift
//  NewProjectStructure
//
//  Created by Swapnil on 25/11/25.
//

import Foundation
import UIKit
import AHKNavigationController

struct TabItem {
  let viewController: UIViewController
  let title: String
  let selectedImageName: String
  let unSelectedImageName: String
}


class TabBarManager: UITabBarController, UITabBarControllerDelegate {



  init(tabs:[TabItem]){
    super.init(nibName: nil, bundle: nil)
    self.delegate = self
    setupTabs(with: tabs)
    configureTabBarAppearance()
    self.selectedIndex = 0
  }


  private func setupTabs(with items: [TabItem]) {

      var controllers: [UIViewController] = []

      for (index, item) in items.enumerated() {

          let selectedImage = UIImage(named: item.selectedImageName)?
              .withRenderingMode(.alwaysOriginal)

        let unSelectedImage = UIImage(named: item.unSelectedImageName)?
            .withTintColor(.gray, renderingMode: .alwaysOriginal)

          let nav = AHKNavigationController(rootViewController: item.viewController)

          nav.tabBarItem = UITabBarItem(title: item.title,image: unSelectedImage,selectedImage: selectedImage)

          nav.tabBarItem.tag = index
          controllers.append(nav)
      }

      self.viewControllers = controllers
  }


  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  private func configureTabBarAppearance() {
          let appearance = UITabBarAppearance()
          appearance.configureWithOpaqueBackground()
          appearance.backgroundColor = Appcolor // Global App Color

          let normalAttributes: [NSAttributedString.Key: Any] = [
              .foregroundColor: UIColor.gray,
              .font: UIFont.systemFont(ofSize: 12, weight: .regular)
          ]

          let selectedAttributes: [NSAttributedString.Key: Any] = [
              .foregroundColor: WhiteBgColor, // Global White Color
              .font: UIFont.systemFont(ofSize: 12, weight: .bold)
          ]

          appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
          appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes

          tabBar.standardAppearance = appearance
          if #available(iOS 15.0, *) {
              tabBar.scrollEdgeAppearance = appearance
          }

            tabBar.clipsToBounds = true
          tabBar.tintColor = WhiteBgColor
          tabBar.unselectedItemTintColor = .gray
      }

  func tabBarController(_ tabBarController: UITabBarController,didSelect viewController: UIViewController) {
    print("Selected tab: \(viewController.title ?? "")")
  }

}
