//
//  CustomGradientDecorationCollectionReusableView.swift
//  NewProjectStructure
//
//  Created by Swapnil on 24/12/25.
//

import UIKit

class CustomGradientDecorationCollectionReusableView: UICollectionReusableView,ReusableCell {

  private let gradientLayer = CAGradientLayer()
  override init(frame: CGRect) {
          super.init(frame: frame)

    let color0 = UIColor(red: 59/255, green: 19/255, blue: 176/255, alpha: 1.0).cgColor   // #3B13B0
            let color30 = UIColor(red: 39/255, green: 19/255, blue: 99/255, alpha: 1.0).cgColor  // #271363
            let color63 = UIColor(red: 27/255, green: 18/255, blue: 53/255, alpha: 1.0).cgColor  // #1B1235
            let color100 = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0).cgColor // #121212

            gradientLayer.colors = [color0, color30, color63, color100]

            // Push the colors up so the black starts sooner
            gradientLayer.locations = [0.0, 0.2, 0.4, 0.7]

            // Start top-left
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)

            // This is the most important part:
            // By setting y: 0.7, the gradient reaches pure black before the section ends
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1)

            self.layer.insertSublayer(gradientLayer, at: 0)
      }

      override func layoutSubviews() {
          super.layoutSubviews()
        gradientLayer.frame = self.bounds
      }

      required init?(coder: NSCoder) { fatalError() }
}
