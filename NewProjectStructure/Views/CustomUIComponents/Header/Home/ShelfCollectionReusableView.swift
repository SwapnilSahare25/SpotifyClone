//
//  ShelfCollectionReusableView.swift
//  NewProjectStructure
//
//  Created by Swapnil on 24/12/25.
//

import UIKit

class ShelfCollectionReusableView: UICollectionReusableView, ReusableCell {
        

  var titleLbl:UILabel!
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    self.setUpUi()
  }

  private func setUpUi() {


    titleLbl = UIFactory.makeLabel(text:"",textColor: WhiteTextColor,font: UIFont(name: fontNameBold, size: HeaderFontSize.scaled) ?? .boldSystemFont(ofSize: 19),alignment: .left)
    self.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Leading:0,.Trailing:50,.FixHeight:25,.Bottom:13])
    titleLbl.backgroundColor = .clear
  }

   func configure(obj: Section){
    self.titleLbl.text = obj.title ?? ""
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
