//
//  RelatedArtistCollectionViewCell.swift
//  NewProjectStructure
//
//  Created by Swapnil on 04/02/26.
//

import UIKit

class RelatedArtistCollectionViewCell: UICollectionViewCell, ReusableCell {


  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .yellow

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
