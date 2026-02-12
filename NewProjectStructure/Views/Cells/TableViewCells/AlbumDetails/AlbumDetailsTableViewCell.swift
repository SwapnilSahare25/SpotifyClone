//
//  AlbumDetailsTableViewCell.swift
//  NewProjectStructure
//
//  Created by Swapnil on 03/02/26.
//

import UIKit

class AlbumDetailsTableViewCell: UITableViewCell, ReusableCell {

  private var containerView: UIView!
   private var titleLbl:UILabel!
  private var duretionTitle:UILabel!
  private var countLbl:UILabel!
  private var subTitle:UILabel!
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

    self.countLbl = UIFactory.makeLabel(text:"50",textColor: SecondaryTextColor,font: UIFont(name: fontNameSemiBold, size: (SmallFontSize+1).scaled) ?? .boldSystemFont(ofSize: SmallFontSize+1),alignment: .center)
    self.containerView.addSubview(countLbl)
    countLbl.addConstraints(constraintsDict: [.Leading:deviceMargin,.FixHeight:25,.CenterY:0,.FixWidth:30])
    countLbl.backgroundColor = .clear

    self.titleLbl = UIFactory.makeLabel(text:"Dont Start Now",textColor: WhiteTextColor,font: UIFont(name: fontNameSemiBold, size: (SubTitleFontsize-1).scaled) ?? .boldSystemFont(ofSize: SubTitleFontsize-1),alignment: .left)
    self.containerView.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Trailing:40,.FixHeight:25,.Top:10])
    titleLbl.addConstraints(constraintsDict: [.RightTo: 5],relativeTo: self.countLbl)
    titleLbl.backgroundColor = .clear

    self.subTitle = UIFactory.makeLabel(text:"323232323",textColor: SecondaryTextColor,font: UIFont(name: fontNameRegular, size: (SmallFontSize+1).scaled) ?? .boldSystemFont(ofSize: SmallFontSize+1),alignment: .left)
    self.containerView.addSubview(subTitle)
    subTitle.addConstraints(constraintsDict: [.Trailing:40,.FixHeight:15,.Bottom:10])
    subTitle.addConstraints(constraintsDict: [.RightTo: 5],relativeTo: self.countLbl)
    subTitle.backgroundColor = .clear

    self.moreOptionsBtn = UIFactory.makeButton(backgroundColor: .clear,image: "moreOptsVerticle")
    self.containerView.addSubview(self.moreOptionsBtn)
    self.moreOptionsBtn.addConstraints(constraintsDict: [.FixWidth:15,.FixHeight:15,.CenterY:0,.Trailing:deviceMargin])


    self.duretionTitle = UIFactory.makeLabel(text:"3:45",textColor: SecondaryTextColor,font: UIFont(name: fontNameRegular, size: (SmallFontSize+1).scaled) ?? .boldSystemFont(ofSize: SmallFontSize+1),alignment: .center)
    self.containerView.addSubview(duretionTitle)
    duretionTitle.addConstraints(constraintsDict: [.FixHeight:15,.CenterY:0,.FixWidth:30])
    duretionTitle.addConstraints(constraintsDict: [.LeftTo: 10],relativeTo: self.moreOptionsBtn)
    duretionTitle.backgroundColor = .clear



  }


  func configure(obj: Item, index: Int,isCurrentSong: Bool,currectTime: Double) {

    if isCurrentSong {
      self.duretionTitle.text = UIFactory.updateProgress(currentTime: currectTime, totalDuration: obj.duration)
    } else {
      self.duretionTitle.text = UIFactory.resetDuration(totalDuration: obj.duration)
    }

    self.countLbl.text = "\(index+1)."
    self.countLbl.alpha = 0.7
    self.titleLbl.text = obj.title ?? ""
   // self.duretionTitle.text = obj.duration ?? ""
    self.subTitle.text = obj.playCount ?? 0 > 0 ? "\(obj.playCount ?? 0) plays" : "\(obj.playCount ?? 0)"
    
    self.titleLbl.textColor = isCurrentSong ? UIColor(hex: "#1DB954"): WhiteTextColor
    self.subTitle.textColor = isCurrentSong ? UIColor(hex: "#1DB954") : WhiteTextColor
    self.duretionTitle.textColor = isCurrentSong ? UIColor(hex: "#1DB954") : SecondaryTextColor

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
