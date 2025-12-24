//
//  HomeGreetingCollectionViewCell.swift
//  NewProjectStructure
//
//  Created by Swapnil on 24/12/25.
//

import UIKit

class HomeGreetingCollectionViewCell: UICollectionViewCell,ReusableCell {


  var containerView: UIView!

  var imgView: UIImageView!

  var titleLbl: UILabel!

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .white.withAlphaComponent(0.1)
    self.backgroundColor = .clear

    self.setUpUi()

  }
  override func layoutSubviews() {
          super.layoutSubviews()
          // Crucial: Update the gradient frame to the box size
          if let gradient = self.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
              gradient.frame = self.bounds
          }
      }

  private func setUpUi(){
    self.containerView = UIFactory.makeContinerView(backgroundColor: ViewBGColor,cornerRadius: 5*DeviceMultiplier)
    self.contentView.addSubview(self.containerView)
    self.containerView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.Bottom:0])
    let boxColor = UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 0.6)
            let bottomColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 0.8)

            self.setGradientBackground(
                colors: [boxColor, bottomColor],
                locations: [0.0, 1.0]
            )

    self.imgView = UIFactory.makeImageView()
    self.containerView.addSubview(self.imgView)
    self.imgView.addConstraints(constraintsDict: [.Leading:0,.Bottom:0,.Top:0,.FixWidth:50*DeviceMultiplier])

    self.titleLbl = UIFactory.makeLabel(text: "",textColor: WhiteTextColor,font: UIFont(name: fontNameBold, size: SmallFontSize-1) ?? .boldSystemFont(ofSize: 11),alignment: .center)
    self.titleLbl.adjustsFontForContentSizeCategory = true
    self.containerView.addSubview(self.titleLbl)
    self.titleLbl.addConstraints(constraintsDict: [.FixHeight:15*DeviceMultiplier,.CenterY:0,.Trailing:0])
    self.titleLbl.addConstraints(constraintsDict: [.RightTo:0],relativeTo: self.imgView)
  }
  func configure(obj: GridItem) {
    self.titleLbl.text = obj.title ?? ""
    self.imgView.setImage(urlStr: obj.image ?? "")
  }


  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
