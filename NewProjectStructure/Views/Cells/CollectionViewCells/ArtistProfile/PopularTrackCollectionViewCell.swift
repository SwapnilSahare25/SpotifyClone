//
//  PopularTrackCollectionViewCell.swift
//  NewProjectStructure
//
//  Created by Swapnil on 04/02/26.
//

import UIKit

class PopularTrackCollectionViewCell: UICollectionViewCell, ReusableCell {

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .blue

    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
