//
//  LikedSongsTableViewCell.swift
//  NewProjectStructure
//
//  Created by Swapnil on 29/01/26.
//

import UIKit

class LikedSongsTableViewCell: UITableViewCell, ReusableCell {

  private var containerView: UIView!
   private var titleLbl:UILabel!
  private var subTitle:UILabel!

   private var imgView:UIImageView!
   var dividerLine: UIView!



  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    self.backgroundColor = .black
    self.setUpUi()

  }

  private func setUpUi(){
    self.containerView = UIFactory.makeContinerView(backgroundColor: .clear,cornerRadius: 0)
    self.contentView.addSubview(self.containerView)
    self.containerView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.Bottom:0])

    self.imgView = UIFactory.makeImageView(imageName: "likedSongs",contentMode: .scaleToFill,cornerRadius: 5*DeviceMultiplier,clipsToBounds: true)
    self.containerView.addSubview(imgView)
    imgView.addConstraints(constraintsDict: [.FixHeight:45,.FixWidth:45,.CenterY:0,.Leading:deviceMargin])

    self.titleLbl = UIFactory.makeLabel(text:"title",textColor: WhiteTextColor,font: UIFont(name: fontNameSemiBold, size: (TitleFontsize+1).scaled) ?? .boldSystemFont(ofSize: TitleFontsize),alignment: .left)
    self.containerView.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Trailing:40,.HeightLessThanOrEqual:50,.Top:15])
    titleLbl.addConstraints(constraintsDict: [.RightTo: 10],relativeTo: imgView)
    titleLbl.backgroundColor = .clear

    self.subTitle = UIFactory.makeLabel(text:"subtitle",textColor: WhiteTextColor,font: UIFont(name: fontNameRegular, size: (SmallFontSize+2).scaled) ?? .boldSystemFont(ofSize: 14),alignment: .left)
    self.containerView.addSubview(subTitle)
    subTitle.addConstraints(constraintsDict: [.Trailing:40,.HeightLessThanOrEqual:50,.Bottom:15])
    subTitle.addConstraints(constraintsDict: [.RightTo: 10],relativeTo: imgView)
    subTitle.backgroundColor = .clear

    self.dividerLine = UIFactory.makeContinerView(backgroundColor: DisableColor)
    self.containerView.addSubview(dividerLine)
    dividerLine.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Bottom:0,.FixHeight:1])





  }

  func configure(obj: Item) {
    self.titleLbl.text = obj.title ?? ""
    self.subTitle.text = obj.artist ?? ""
    self.imgView.setImage(urlStr: obj.image ?? "")
  
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
