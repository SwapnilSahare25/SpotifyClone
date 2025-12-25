//
//  ArtistCollectionViewCell.swift
//  NewProjectStructure
//
//  Created by Swapnil on 24/12/25.
//

import UIKit

class ArtistCollectionViewCell: UICollectionViewCell,ReusableCell {
    
  var containerView: UIView!
  var imgView:UIImageView!
  var titleLbl:UILabel!
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = CellBgColor
    self.setUpUi()


  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpUi(){
    self.containerView = UIFactory.makeContinerView(backgroundColor: .clear,cornerRadius: 0)
    self.contentView.addSubview(self.containerView)
    self.containerView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.Bottom:0])

    self.imgView = UIFactory.makeImageView(contentMode: .scaleToFill)
    self.containerView.addSubview(self.imgView)
    self.imgView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.FixHeight:175])


    self.titleLbl = UIFactory.makeLabel(text: "",textColor: WhiteTextColor,font: UIFont(name: fontNameMedium, size: (SmallFontSize).scaled) ?? .boldSystemFont(ofSize: 13),alignment: .center)
    self.titleLbl.adjustsFontForContentSizeCategory = true
    self.containerView.addSubview(self.titleLbl)
    self.titleLbl.addConstraints(constraintsDict: [.Leading:5,.Trailing:5,.Bottom:5])
    self.titleLbl.belowTo(view: self.imgView, constant: 5)

  }

  func configure(obj: Item) {

    self.imgView.setImage(urlStr: obj.image ?? "")
    self.titleLbl.text = obj.name ?? ""
  }


}
