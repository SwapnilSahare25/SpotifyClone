//
//  EmptyHeaderCollectionReusableView.swift
//  NewProjectStructure
//
//  Created by Swapnil on 24/12/25.
//

import UIKit

class EmptyHeaderCollectionReusableView: UICollectionReusableView,ReusableCell {
        

  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
