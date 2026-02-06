//
//  RelatedArtistCollectionViewCell.swift
//  NewProjectStructure
//
//  Created by Swapnil on 04/02/26.
//

import UIKit

class RelatedArtistCollectionViewCell: UICollectionViewCell, ReusableCell {

  private var containerView: UIView!
   private var titleLbl:UILabel!
  private var imgView: UIImageView!

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    self.setupUi()
  }

  private func setupUi(){
    self.containerView = UIFactory.makeContinerView(backgroundColor: .clear)
    self.contentView.addSubview(self.containerView)
    self.containerView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.Bottom:0])


    self.imgView = UIFactory.makeImageView(imageName: "likedSongs",contentMode: .scaleToFill,cornerRadius: 47.5*DeviceMultiplier)
    self.containerView.addSubview(imgView)
    imgView.addConstraints(constraintsDict: [.FixWidth:95,.CenterX:0,.Top:2,.FixHeight:95])



    self.titleLbl = UIFactory.makeLabel(text:"Start Now",textColor: SecondaryTextColor,font: UIFont(name: fontNameSemiBold, size: (DetailTabFontSize).scaled) ?? .boldSystemFont(ofSize: DetailTabFontSize),alignment: .center)
    self.containerView.addSubview(titleLbl)
    self.titleLbl.addConstraints(constraintsDict: [.BelowTo:5],relativeTo: self.imgView)
    titleLbl.addConstraints(constraintsDict: [.Trailing:0,.Leading:0,.Bottom:2])
    titleLbl.backgroundColor = .clear


  }

  func configure(object: Artist){


    self.titleLbl.text = object.name ?? ""
    self.imgView.setImage(urlStr: object.image ?? "")

  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
