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
    self.setUpUi()

  }

  private func setUpUi(){
    self.containerView = UIFactory.makeContinerView(backgroundColor: ViewBGColor,cornerRadius: 5*DeviceMultiplier)
    self.contentView.addSubview(self.containerView)
    self.containerView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.Bottom:0])


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
