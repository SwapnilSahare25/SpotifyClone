//
//  ToggleLikeButton.swift
//  NewProjectStructure
//
//  Created by Swapnil on 09/02/26.
//

import UIKit

class ToggleLikeButton: UIButton {


  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = .clear
    self.setupBtnUI()


  }
  private func setupBtnUI(){
    self.setImage(UIImage(named: "unlike"), for: .normal)
    self.addTarget(self, action: #selector(self.toggleLikeApiCall), for: .touchUpInside)
  }


  @objc func toggleLikeApiCall(){
      print("LIke Btn Clicked")
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
