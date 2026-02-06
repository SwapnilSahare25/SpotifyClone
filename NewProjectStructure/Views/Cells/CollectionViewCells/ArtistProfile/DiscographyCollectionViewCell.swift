//
//  DiscographyCollectionViewCell.swift
//  NewProjectStructure
//
//  Created by Swapnil on 04/02/26.
//

import UIKit

class DiscographyCollectionViewCell: UICollectionViewCell, ReusableCell {

  private var containerView: UIView!
   private var titleLbl:UILabel!
  private var subTitleLbl:UILabel!
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


    self.imgView = UIFactory.makeImageView(imageName: "likedSongs",contentMode: .scaleToFill)
    self.containerView.addSubview(imgView)
    imgView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.FixHeight:110])



    self.titleLbl = UIFactory.makeLabel(text:"Start Now",textColor: SecondaryTextColor,font: UIFont(name: fontNameSemiBold, size: (DetailTabFontSize-2).scaled) ?? .boldSystemFont(ofSize: DetailTabFontSize-2),alignment: .center)
    self.containerView.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Trailing:0,.HeightLessThanOrEqual:30,.Leading:0])
    titleLbl.addConstraints(constraintsDict: [.BelowTo:2],relativeTo: self.imgView)
    titleLbl.backgroundColor = .clear

    self.subTitleLbl = UIFactory.makeLabel(text:"Start Now",textColor: SecondaryTextColor,font: UIFont(name: fontNameMedium, size: (SmallFontSize-3).scaled) ?? .boldSystemFont(ofSize: SmallFontSize-3),alignment: .center)
    self.containerView.addSubview(subTitleLbl)
    subTitleLbl.addConstraints(constraintsDict: [.Trailing:0,.HeightLessThanOrEqual:30,.Bottom:2,.Leading:0])
    subTitleLbl.backgroundColor = .clear


  }

  func configure(object: AlbumObject){
    let type = object.type?.capitalized ?? ""
    let artist = object.artist ?? ""
    let year = object.year ?? 0

    let subTitleText = "\(type):- \(artist) - \(year)"

    self.titleLbl.text = object.title ?? ""
    self.subTitleLbl.text = subTitleText
    self.imgView.setImage(urlStr: object.image ?? "")

  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
