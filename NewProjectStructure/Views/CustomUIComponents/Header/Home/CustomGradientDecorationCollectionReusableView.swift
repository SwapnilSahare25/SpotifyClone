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
    let colors = [
                UIColor(red: 59/255, green: 19/255, blue: 176/255, alpha: 1.0).cgColor,  // #3B13B0
                UIColor(red: 39/255, green: 19/255, blue: 99/255, alpha: 1.0).cgColor,   // #271363
                UIColor(red: 27/255, green: 18/255, blue: 53/255, alpha: 1.0).cgColor,   // #1B1235
                UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0).cgColor    // #121212
            ]

            // 1. Change type to .radial to get that "Curved" look from your red mark
            gradientLayer.type = .radial
            gradientLayer.colors = colors

            // 2. These locations ensure the purple stays behind the first boxes
            // and turns black quickly as it moves toward the bottom
            gradientLayer.locations = [0.0, 0.2, 0.45, 0.7]

            // 3. Start at Top-Left (where 'Good evening' is)
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.1)

            // 4. In radial, endPoint is the bottom-right radius
            // Setting it to (1.5, 1.0) stretches the "glow" horizontally
            // to match the breadth-to-length ratio you asked for.
            gradientLayer.endPoint = CGPoint(x: 1.5, y: 1.0)

            self.layer.insertSublayer(gradientLayer, at: 0)
      }

      override func layoutSubviews() {
          super.layoutSubviews()
        gradientLayer.frame = self.bounds
      }

      required init?(coder: NSCoder) { fatalError() }
}
