//
//  SectionBgViewCollectionReusableView.swift
//  NewProjectStructure
//
//  Created by Swapnil on 25/12/25.
//

import UIKit

class SectionBgViewCollectionReusableView: UICollectionReusableView,ReusableCell {
        
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = CellBgColor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
