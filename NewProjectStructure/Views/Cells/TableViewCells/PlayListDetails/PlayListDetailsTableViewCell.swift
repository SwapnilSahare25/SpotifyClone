//
//  PlayListDetailsTableViewCell.swift
//  NewProjectStructure
//
//  Created by Swapnil on 04/02/26.
//

import UIKit

class PlayListDetailsTableViewCell: UITableViewCell, ReusableCell {


  private var containerView: UIView!
   private var titleLbl:UILabel!
  private var subTitle:UILabel!
  private var countLbl:UILabel!
  private var imgView: UIImageView!
  private var duretionLbl:UILabel!
  private var moreOptionsBtn:UIButton!

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
    imgView.addConstraints(constraintsDict: [.FixHeight:35,.FixWidth:35,.CenterY:0,.Leading:deviceMargin])

    self.countLbl = UIFactory.makeLabel(text:"50",textColor: SecondaryTextColor,font: UIFont(name: fontNameSemiBold, size: (SmallFontSize+1).scaled) ?? .boldSystemFont(ofSize: SmallFontSize+1),alignment: .center)
    self.containerView.addSubview(countLbl)
    countLbl.addConstraints(constraintsDict: [.FixHeight:25,.CenterY:0,.FixWidth:20])
    countLbl.addConstraints(constraintsDict: [.RightTo: 2.5],relativeTo: imgView)
    countLbl.backgroundColor = .clear


    self.titleLbl = UIFactory.makeLabel(text:"Dont Start Now",textColor: WhiteTextColor,font: UIFont(name: fontNameSemiBold, size: (SubTitleFontsize-1).scaled) ?? .boldSystemFont(ofSize: SubTitleFontsize-1),alignment: .left)
    self.containerView.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Trailing:40,.HeightLessThanOrEqual:25,.Top:10])
    titleLbl.addConstraints(constraintsDict: [.RightTo: 10],relativeTo: self.countLbl)
    titleLbl.backgroundColor = .clear

    self.subTitle = UIFactory.makeLabel(text:"subtitle",textColor: WhiteTextColor,font: UIFont(name: fontNameRegular, size: (SmallFontSize+1).scaled) ?? .boldSystemFont(ofSize: SmallFontSize+1),alignment: .left)
    self.containerView.addSubview(subTitle)
    subTitle.addConstraints(constraintsDict: [.Trailing:40,.HeightLessThanOrEqual:50,.Bottom:10])
    subTitle.addConstraints(constraintsDict: [.RightTo: 10],relativeTo: self.countLbl)
    subTitle.backgroundColor = .clear

    self.moreOptionsBtn = UIFactory.makeButton(backgroundColor: .clear,image: "moreOptsVerticle")
    self.containerView.addSubview(self.moreOptionsBtn)
    self.moreOptionsBtn.addConstraints(constraintsDict: [.FixWidth:15,.FixHeight:15,.CenterY:0,.Trailing:deviceMargin])


    self.duretionLbl = UIFactory.makeLabel(text:"3:45",textColor: SecondaryTextColor,font: UIFont(name: fontNameRegular, size: (SmallFontSize+1).scaled) ?? .boldSystemFont(ofSize: SmallFontSize+1),alignment: .center)
    self.containerView.addSubview(duretionLbl)
    duretionLbl.addConstraints(constraintsDict: [.CenterY:0,.FixHeight:15,.FixWidth:30])
    duretionLbl.addConstraints(constraintsDict: [.LeftTo: 10],relativeTo: self.moreOptionsBtn)
    duretionLbl.backgroundColor = .clear



  }


  func configure(obj: Item, index: Int) {
    self.countLbl.text = "\(index+1)."
    self.countLbl.alpha = 0.7
    self.titleLbl.text = obj.title ?? ""
    self.duretionLbl.text = obj.duration ?? ""
    self.subTitle.text = obj.artist ?? ""

  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
