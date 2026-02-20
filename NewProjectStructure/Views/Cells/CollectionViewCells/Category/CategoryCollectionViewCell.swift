//
//  CategoryCollectionViewCell.swift
//  NewProjectStructure
//
//  Created by Swapnil on 20/02/26.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell, ReusableCell {

  private var containerView: UIView!
  var imgView:UIImageView!
  var titleLbl:UILabel!
  var subTitleLbl:UILabel!

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    self.setUpUi()


  }

  private func setUpUi(){


    self.containerView = UIFactory.makeContinerView(backgroundColor: CellBgColor,cornerRadius: 15*DeviceMultiplier)
    self.contentView.addSubview(self.containerView)
    self.containerView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.Bottom:0])

    self.imgView = UIFactory.makeImageView(imageName: "likedSongs",contentMode: .scaleToFill,cornerRadius: 10*DeviceMultiplier)
    self.containerView.addSubview(self.imgView)
    self.imgView.addConstraints(constraintsDict: [.Leading:30,.Trailing:30,.Top:10,.FixHeight:105])


    self.titleLbl = UIFactory.makeLabel(text: "Classic Rock Essentials",textColor: WhiteTextColor,font: UIFont(name: fontNameSemiBold, size: (SmallFontSize+1)) ?? .boldSystemFont(ofSize: SmallFontSize+1),alignment: .left)
    self.containerView.addSubview(self.titleLbl)
    self.titleLbl.addConstraints(constraintsDict: [.Leading:10,.Trailing:10,.FixHeight:15])
    self.titleLbl.addConstraints(constraintsDict: [.BelowTo: 10],relativeTo: imgView)

    self.subTitleLbl = UIFactory.makeLabel(text: "",textColor: WhiteTextColor,font: UIFont(name: fontNameRegular, size: (SmallFontSize-2)) ?? .boldSystemFont(ofSize: SmallFontSize-2),alignment: .left)
    self.subTitleLbl.adjustsFontForContentSizeCategory = true
    self.containerView.addSubview(self.subTitleLbl)
    self.subTitleLbl.addConstraints(constraintsDict: [.Leading:10,.Trailing:10,.Bottom:5])
    self.subTitleLbl.addConstraints(constraintsDict: [.BelowTo: 2.5],relativeTo: titleLbl)




  }

  func configure(obj: Item){
    self.imgView.setImage(urlStr: obj.image ?? "")
    self.titleLbl.text = obj.title ?? ""
    self.subTitleLbl.text = obj.description ?? ""

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
