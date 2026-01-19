//
//  ActiveSearchCollectionViewCell.swift
//  NewProjectStructure
//
//  Created by Swapnil on 19/01/26.
//

import UIKit

class ActiveSearchCollectionViewCell: UICollectionViewCell,ReusableCell {

  private var containerView: UIView!
   private var titleLbl:UILabel!

   private var imgView:UIImageView!


  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    self.setUpUi()



  }
  private func setUpUi(){
    self.containerView = UIFactory.makeContinerView(backgroundColor: .clear,cornerRadius: 5*DeviceMultiplier)
    self.contentView.addSubview(self.containerView)
    self.containerView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.Bottom:0])
    containerView.backgroundColor = .blue

    imgView = UIFactory.makeImageView(imageName: "",contentMode: .scaleToFill,cornerRadius: 22.5*DeviceMultiplier,clipsToBounds: true)
    self.containerView.addSubview(imgView)
    imgView.addConstraints(constraintsDict: [.FixHeight:45,.FixWidth:45,.CenterY:0,.Leading:10])
    imgView.backgroundColor = .red

    titleLbl = UIFactory.makeLabel(text:"Good evening",textColor: WhiteTextColor,font: UIFont(name: fontNameSemiBold, size: (DetailFontsize+1).scaled) ?? .boldSystemFont(ofSize: 14),alignment: .left)
    self.containerView.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Trailing:40,.HeightLessThanOrEqual:50,.CenterY:0])
    titleLbl.addConstraints(constraintsDict: [.RightTo: 10],relativeTo: imgView)
    titleLbl.backgroundColor = .clear





  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
