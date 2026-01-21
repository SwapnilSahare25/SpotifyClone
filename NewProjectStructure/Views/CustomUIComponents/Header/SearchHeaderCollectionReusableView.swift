//
//  SearchHeaderCollectionReusableView.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/12/25.
//

import UIKit

class SearchHeaderCollectionReusableView: UICollectionReusableView,ReusableCell {


  var titleLbl:UILabel!

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    self.setUpUi()

    
  }
  

  private func setUpUi() {


    titleLbl = UIFactory.makeLabel(text:"Good evening",textColor: WhiteTextColor,font: UIFont(name: fontNameMedium, size: DetailFontsize.scaled) ?? .boldSystemFont(ofSize: 14),alignment: .left)
    self.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Leading:deviceMargin,.Trailing:50,.FixHeight:25,.Top:17])
    titleLbl.backgroundColor = .clear
  }
  func configure(obj: SectionObject){
    self.titleLbl.text = obj.title ?? ""
  }


  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
