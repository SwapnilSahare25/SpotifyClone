//
//  ViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 25/11/25.
//

import UIKit

class HomeViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Appcolor
        self.title = "Home"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.setNavbarRightBtn()


        
    }
  func setNavbarRightBtn() {
    let profileImage = UIImage(named: "Setting")?.withRenderingMode(.alwaysTemplate)
    let profile = UIBarButtonItem(image:profileImage, style: .plain, target: self, action: #selector(buttonTapped))
    profile.tintColor = .white
    navigationItem.rightBarButtonItems = [profile]
  }

    
    @objc private func buttonTapped() {
        
        let vc = ProfileViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
      }

}

