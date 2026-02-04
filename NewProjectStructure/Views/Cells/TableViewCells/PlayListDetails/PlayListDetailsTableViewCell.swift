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

    self.countLbl = UIFactory.makeLabel(text:"50",textColor: SecondaryTextColor,font: UIFont(name: fontNameRegular, size: (SmallFontSize+3).scaled) ?? .boldSystemFont(ofSize: 14),alignment: .center)
    self.containerView.addSubview(countLbl)
    countLbl.addConstraints(constraintsDict: [.Leading:20,.FixHeight:30,.CenterY:0,.FixWidth:40])
    countLbl.backgroundColor = .clear

    self.titleLbl = UIFactory.makeLabel(text:"Dont Start Now",textColor: WhiteTextColor,font: UIFont(name: fontNameSemiBold, size: (TitleFontsize+1).scaled) ?? .boldSystemFont(ofSize: TitleFontsize),alignment: .left)
    self.containerView.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Trailing:40,.FixHeight:25,.Top:15])
    titleLbl.addConstraints(constraintsDict: [.RightTo: 15],relativeTo: self.countLbl)
    titleLbl.backgroundColor = .clear

    self.subTitle = UIFactory.makeLabel(text:"3:45",textColor: SecondaryTextColor,font: UIFont(name: fontNameRegular, size: (SmallFontSize+3).scaled) ?? .boldSystemFont(ofSize: 14),alignment: .left)
    self.containerView.addSubview(subTitle)
    subTitle.addConstraints(constraintsDict: [.Trailing:40,.FixHeight:15,.Bottom:15])
    subTitle.addConstraints(constraintsDict: [.RightTo: 15],relativeTo: self.countLbl)
    subTitle.backgroundColor = .clear



  }


  func configure(obj: Item, index: Int) {
    self.countLbl.text = "\(index + 1)"
    self.countLbl.alpha = 0.7
    self.titleLbl.text = obj.title ?? ""
    self.subTitle.text = obj.duration ?? ""

  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
