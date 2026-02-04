//
//  DiscographyCollectionViewCell.swift
//  NewProjectStructure
//
//  Created by Swapnil on 04/02/26.
//

import UIKit

class DiscographyCollectionViewCell: UICollectionViewCell, ReusableCell {


  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .green

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
