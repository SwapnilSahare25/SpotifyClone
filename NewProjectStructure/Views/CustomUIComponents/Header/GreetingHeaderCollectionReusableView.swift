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
    self.backgroundColor = .clear
    let color0 = UIColor(red: 59/255, green: 19/255, blue: 176/255, alpha: 1.0)   // #3B13B0
        let color30 = UIColor(red: 39/255, green: 19/255, blue: 99/255, alpha: 1.0)  // #271363
        let color63 = UIColor(red: 27/255, green: 18/255, blue: 53/255, alpha: 1.0)  // #1B1235
        let color100 = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0) // #121212

        // If the gradient still looks too short, push these numbers higher (e.g., 0.5, 0.8)
//        self.setGradientBackground(
//            colors: [color0, color30, color63, color100],
//            locations: [0.0, 0.35, 0.70, 1.0]
//        )

        self.setUpUi()
  }
  override func layoutSubviews() {
      super.layoutSubviews()
      // Ensure the gradient layer matches the view's final size
    if let gradientLayer = self.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradientLayer.frame = self.bounds
        }
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
