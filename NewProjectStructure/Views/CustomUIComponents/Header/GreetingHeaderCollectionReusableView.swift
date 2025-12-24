//
//  GreetingHeaderCollectionReusableView.swift
//  NewProjectStructure
//
//  Created by Swapnil on 24/12/25.
//

import UIKit

class GreetingHeaderCollectionReusableView: UICollectionReusableView, ReusableCell {


  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .red
    self.setUpUi()
  }

  private func setUpUi() {
    let profileImage = UIImage(named: "Setting")?.withRenderingMode(.alwaysTemplate)
    let profile = UIBarButtonItem(image:profileImage, style: .plain, target: self, action: #selector(buttonTapped))
    profile.tintColor = .white
    //navigationItem.rightBarButtonItems = [profile]
  }


    @objc private func buttonTapped() {

        let vc = ProfileViewController()
        vc.hidesBottomBarWhenPushed = true
        //self.navigationController?.pushViewController(vc, animated: true)
      }


  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
