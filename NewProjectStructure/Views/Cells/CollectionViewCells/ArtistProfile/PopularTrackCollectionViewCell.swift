//
//  PopularTrackCollectionViewCell.swift
//  NewProjectStructure
//
//  Created by Swapnil on 04/02/26.
//

import UIKit

class PopularTrackCollectionViewCell: UICollectionViewCell, ReusableCell {


  private var containerView: UIView!
   private var titleLbl:UILabel!
  private var subTitle:UILabel!
  private var duretionLbl:UILabel!
  private var countLbl:UILabel!
  private var imgView: UIImageView!
  private var moreOptionsBtn:UIButton!

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    self.setupUi()

    
  }

  private func setupUi(){
    self.containerView = UIFactory.makeContinerView(backgroundColor: .clear,cornerRadius: 0)
    self.contentView.addSubview(self.containerView)
    self.containerView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.Bottom:0])

    self.countLbl = UIFactory.makeLabel(text:"",textColor: SecondaryTextColor,font: UIFont(name: fontNameRegular, size: (SmallFontSize).scaled) ?? .boldSystemFont(ofSize: SmallFontSize),alignment: .center)
    self.containerView.addSubview(countLbl)
    countLbl.addConstraints(constraintsDict: [.Leading:0,.FixHeight:30,.CenterY:0,.FixWidth:0])
    countLbl.backgroundColor = .clear

    self.imgView = UIFactory.makeImageView(imageName: "likedSongs",contentMode: .scaleToFill,cornerRadius: 20*DeviceMultiplier,clipsToBounds: true)
    self.containerView.addSubview(imgView)
    imgView.addConstraints(constraintsDict: [.FixHeight:40,.FixWidth:40,.CenterY:0])
    imgView.addConstraints(constraintsDict: [.RightTo: 0],relativeTo: self.countLbl)


    self.titleLbl = UIFactory.makeLabel(text:"Start Now",textColor: WhiteTextColor,font: UIFont(name: fontNameSemiBold, size: (TitleFontsize-2).scaled) ?? .boldSystemFont(ofSize: TitleFontsize-2),alignment: .left)
    self.containerView.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Trailing:40,.FixHeight:16,.Top:9])
    titleLbl.addConstraints(constraintsDict: [.RightTo: 5],relativeTo: self.imgView)
    titleLbl.backgroundColor = .clear

    self.subTitle = UIFactory.makeLabel(text:"3:45",textColor: SecondaryTextColor,font: UIFont(name: fontNameRegular, size: (SmallFontSize+1).scaled) ?? .boldSystemFont(ofSize: SmallFontSize+1),alignment: .left)
    self.containerView.addSubview(subTitle)
    subTitle.addConstraints(constraintsDict: [.Trailing:40,.FixHeight:15,.Bottom:9])
    subTitle.addConstraints(constraintsDict: [.RightTo: 5],relativeTo: self.imgView)
    subTitle.backgroundColor = .clear

    self.moreOptionsBtn = UIFactory.makeButton(backgroundColor: .clear,image: "moreOptsVerticle")
    self.containerView.addSubview(self.moreOptionsBtn)
    self.moreOptionsBtn.addConstraints(constraintsDict: [.FixWidth:15,.FixHeight:15,.CenterY:0,.Trailing:0])

    self.duretionLbl = UIFactory.makeLabel(text:"3:45",textColor: SecondaryTextColor,font: UIFont(name: fontNameRegular, size: (SmallFontSize+1).scaled) ?? .boldSystemFont(ofSize: SmallFontSize+1),alignment: .left)
    self.containerView.addSubview(duretionLbl)
    duretionLbl.addConstraints(constraintsDict: [.CenterY:0,.FixHeight:15,.FixWidth:35])
    duretionLbl.addConstraints(constraintsDict: [.LeftTo: 10],relativeTo: self.moreOptionsBtn)
    duretionLbl.backgroundColor = .clear


  }

  func configure(object: PopularTrack,index:Int){

//    self.countLbl.text = "\(index+1)"
//    self.countLbl.alpha = 0.7

    self.titleLbl.text = object.title ?? ""
    self.subTitle.text = object.play_count ?? 0 > 0 ? "\(object.play_count ?? 0) plays" : "\(object.play_count ?? 0)"
    self.duretionLbl.text = object.duration ?? ""
    self.imgView.setImage(urlStr: object.image ?? "")

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
