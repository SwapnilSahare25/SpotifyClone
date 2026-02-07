//
//  UIViewController+Extension.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/12/25.
//

import UIKit


extension UIViewController {

  func setupBackButton(image: String="back",action: Selector? = nil) {

    let button = UIFactory.makeButton()
      button.setImage(UIImage(named: image), for: .normal)
      button.frame = CGRect(x: 0, y: 0, width: 30*DeviceMultiplier, height: 30*DeviceMultiplier)
      button.layer.cornerRadius = 5*DeviceMultiplier
    button.backgroundColor = .clear

      if let action = action {
          button.addTarget(self, action: action, for: .touchUpInside)
      } else {
          button.addTarget(self, action: #selector(defaultBackAction), for: .touchUpInside)
      }

      let barButton = UIBarButtonItem(customView: button)
      navigationItem.leftBarButtonItem = barButton
  }

  @objc private func defaultBackAction() {
      navigationController?.popViewController(animated: true)
  }
//
//  func setNavBarColor(_ color: UIColor) {
//         guard let navBar = navigationController?.navigationBar else { return }
//
//         let appearance = UINavigationBarAppearance()
//         appearance.configureWithOpaqueBackground()
//         appearance.backgroundColor = color
//         appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//
//         navBar.standardAppearance = appearance
//         navBar.scrollEdgeAppearance = appearance
//         navBar.compactAppearance = appearance
//
//         //navBar.tintColor = .white // back button color
//     }

   func setNavBarColor(_ color: UIColor?) {

      let appearance = UINavigationBarAppearance()
      appearance.configureWithTransparentBackground()
      appearance.backgroundColor = color

      appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

      navigationController?.navigationBar.standardAppearance = appearance
      navigationController?.navigationBar.scrollEdgeAppearance = appearance
  }


  func setNavBarGradient(colors: [UIColor]) {
      guard let navBar = navigationController?.navigationBar else { return }

      let gradient = CAGradientLayer()
      gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120)
      gradient.colors = colors.map { $0.cgColor }
      gradient.startPoint = CGPoint(x: 0.5, y: 0)
      gradient.endPoint = CGPoint(x: 0.5, y: 1)

      let renderer = UIGraphicsImageRenderer(size: gradient.frame.size)
      let image = renderer.image { ctx in
          gradient.render(in: ctx.cgContext)
      }

      let appearance = UINavigationBarAppearance()
      appearance.configureWithOpaqueBackground()
      appearance.backgroundImage = image

      navBar.standardAppearance = appearance
      navBar.scrollEdgeAppearance = appearance
      navBar.compactAppearance = appearance
      navBar.tintColor = .white
  }

  // MARK: - Screen Gradient
  func setGradientBackground(colors: [UIColor]) {

      // Remove old gradient
      view.layer.sublayers?.filter { $0.name == "CommonGradient" }
          .forEach { $0.removeFromSuperlayer() }

      let gradient = CAGradientLayer()
      gradient.name = "CommonGradient"
      gradient.frame = view.bounds
      gradient.colors = colors.map { $0.cgColor }

      gradient.startPoint = CGPoint(x: 0.5, y: 0)
      gradient.endPoint   = CGPoint(x: 0.5, y: 1)

      view.layer.insertSublayer(gradient, at: 0)
  }

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
