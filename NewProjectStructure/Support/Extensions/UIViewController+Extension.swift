//
//  UIViewController+Extension.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/12/25.
//

import UIKit
import MaterialComponents
import SHSearchBar

extension UIViewController {

  
//    func setupMaterialSearchAppBar(
//        largeTitle: Bool,
//        isSearchTypable: Bool,
//        onSearchTap: Selector? = nil
//    ) -> (appBar: MDCAppBar, searchBar: SHSearchBar) {
//
//        // 1️⃣ Create AppBar
//        let appBar = MDCAppBar()
//        addChild(appBar.headerViewController)
//        appBar.headerViewController.view.frame = view.bounds
//        view.addSubview(appBar.headerViewController.view)
//        appBar.headerViewController.didMove(toParent: self)
//
//        // 2️⃣ Flexible header height (simulates large title)
//        appBar.headerViewController.headerView.minimumHeight = 56
//        appBar.headerViewController.headerView.maximumHeight = largeTitle ? 120 : 56
//
//        // 3️⃣ Remove shadow
//        appBar.headerViewController.headerView.shadowLayer?.shadowOpacity = 0
//        appBar.headerViewController.headerView.backgroundColor = Appcolor
//
//        // 4️⃣ Setup SHSearchBar
//        var config = SHSearchBarConfig()
//        config.clearButtonMode = .whileEditing
//        config.leftViewMode = .always
//
//        let searchBar = SHSearchBar(config: config)
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        searchBar.textField.backgroundColor = .white
//        searchBar.textField.textColor = .black
//        searchBar.textField.font = .systemFont(ofSize: 16, weight: .semibold)
//        searchBar.textField.layer.cornerRadius = 6
//        searchBar.textField.clipsToBounds = true
//        searchBar.textField.isUserInteractionEnabled = isSearchTypable
//
//        // Placeholder
//        searchBar.textField.placeholder = "Artists, songs, or podcasts"
//
//        // Tap action for non-typable search
//        if !isSearchTypable, let selector = onSearchTap {
//            let tap = UITapGestureRecognizer(target: self, action: selector)
//            searchBar.addGestureRecognizer(tap)
//        }
//
//        // Add search bar to AppBar header
//        appBar.headerViewController.headerView.addSubview(searchBar)
//        NSLayoutConstraint.activate([
//            searchBar.leadingAnchor.constraint(equalTo: appBar.headerViewController.headerView.leadingAnchor, constant: 16),
//            searchBar.trailingAnchor.constraint(equalTo: appBar.headerViewController.headerView.trailingAnchor, constant: -16),
//            searchBar.bottomAnchor.constraint(equalTo: appBar.headerViewController.headerView.bottomAnchor, constant: -12),
//            searchBar.heightAnchor.constraint(equalToConstant: 44)
//        ])
//
//        // Automatically open keyboard if typable
//        if isSearchTypable {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                searchBar.textField.becomeFirstResponder()
//            }
//        }
//
//        return (appBar, searchBar)
//    }
}
