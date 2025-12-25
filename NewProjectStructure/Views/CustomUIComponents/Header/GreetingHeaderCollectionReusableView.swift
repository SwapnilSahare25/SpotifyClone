//
//  GreetingHeaderCollectionReusableView.swift
//  NewProjectStructure
//
//  Created by Swapnil on 24/12/25.
//

import UIKit

class GreetingHeaderCollectionReusableView: UICollectionReusableView, ReusableCell {


  var target:UIViewController?
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
        self.setUpUi()

  }
  
//  override func layoutSubviews() {
//      super.layoutSubviews()
//      // Ensure the gradient layer matches the view's final size
//    if let gradientLayer = self.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
//            gradientLayer.frame = self.bounds
//        }
//  }

  private func setUpUi() {
    let topOffset = (statusBarHeight) + ((navBarHeight - 25) / 2)


    let profileImage = UIFactory.makeImageView(imageName: "Setting",clipsToBounds: true)
    self.addSubview(profileImage)
    profileImage.addConstraints(constraintsDict: [.Trailing:deviceMargin,.FixHeight:25,.FixWidth:25,.Top:topOffset])
    profileImage.tintColor = .white
    profileImage.isUserInteractionEnabled = true
    profileImage.addTarget(self, action: #selector(buttonTapped))

    let titleLbl = UIFactory.makeLabel(text:"Good evening",textColor: WhiteTextColor,font: UIFont(name: fontNameBold, size: HeaderFontSize.scaled) ?? .boldSystemFont(ofSize: 19),alignment: .left)
    self.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Leading:deviceMargin,.Trailing:50,.FixHeight:25,.Top:topOffset])
    titleLbl.backgroundColor = .clear
  }


    @objc private func buttonTapped() {

        let vc = ProfileViewController()
        vc.hidesBottomBarWhenPushed = true
        self.target?.navigationController?.pushViewController(vc, animated: true)
      }


  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

