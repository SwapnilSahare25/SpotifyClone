//
//  LibraryTableViewCell.swift
//  NewProjectStructure
//
//  Created by Swapnil on 28/01/26.
//

import UIKit

class LibraryTableViewCell: UITableViewCell, ReusableCell {


  private var containerView: UIView!
   private var titleLbl:UILabel!
  private var subTitle:UILabel!

   private var imgView:UIImageView!
  private var dividerLine: UIView!

  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.backgroundColor = .clear
    self.selectionStyle = .none
    self.setUpUi()


    
  }

  private func setUpUi(){
    self.containerView = UIFactory.makeContinerView(backgroundColor: .clear,cornerRadius: 0)
    self.contentView.addSubview(self.containerView)
    self.containerView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.Bottom:0])
   // containerView.backgroundColor = .blue

    self.imgView = UIFactory.makeImageView(imageName: "Setting",contentMode: .scaleToFill,cornerRadius: 17.5*DeviceMultiplier,clipsToBounds: true)
    self.containerView.addSubview(imgView)
    imgView.addConstraints(constraintsDict: [.FixHeight:35,.FixWidth:35,.CenterY:0,.Leading:deviceMargin])
    //imgView.backgroundColor = .red

    self.titleLbl = UIFactory.makeLabel(text:"Good evening",textColor: WhiteTextColor,font: UIFont(name: fontNameSemiBold, size: (DetailFontsize+1).scaled) ?? .boldSystemFont(ofSize: 14),alignment: .left)
    self.containerView.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Trailing:40,.HeightLessThanOrEqual:50,.Top:10])
    titleLbl.addConstraints(constraintsDict: [.RightTo: 10],relativeTo: imgView)
    titleLbl.backgroundColor = .clear

    self.subTitle = UIFactory.makeLabel(text:"Good",textColor: WhiteTextColor,font: UIFont(name: fontNameRegular, size: (SmallFontSize).scaled) ?? .boldSystemFont(ofSize: 12),alignment: .left)
    self.containerView.addSubview(subTitle)
    subTitle.addConstraints(constraintsDict: [.Trailing:40,.HeightLessThanOrEqual:50,.Bottom:10])
    subTitle.addConstraints(constraintsDict: [.RightTo: 10],relativeTo: imgView)
    subTitle.backgroundColor = .clear

    self.dividerLine = UIFactory.makeContinerView(backgroundColor: DisableColor)
    self.containerView.addSubview(dividerLine)
    dividerLine.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Bottom:0,.FixHeight:1])





  }
//
//  func configure(obj: Item) {
//    self.containerView.backgroundColor = UIColor(hex: obj.color ?? "")
//    self.titleLbl.text = obj.title ?? ""
//    self.subTitle.text = obj.subtitle ?? ""
//    self.imgView.setImage(urlStr: obj.image ?? "")
//  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
