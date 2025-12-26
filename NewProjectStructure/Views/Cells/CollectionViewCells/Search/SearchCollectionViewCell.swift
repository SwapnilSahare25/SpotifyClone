//
//  SearchCollectionViewCell.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/12/25.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell,ReusableCell {

 private var containerView: UIView!
  private var titleLbl:UILabel!

  private var imgView:UIImageView!

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    self.setUpUi()

    
  }

  private func setUpUi(){
    self.containerView = UIFactory.makeContinerView(backgroundColor: .clear,cornerRadius: 5*DeviceMultiplier)
    self.contentView.addSubview(self.containerView)
    self.containerView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.Bottom:0])

    titleLbl = UIFactory.makeLabel(text:"Good evening",textColor: WhiteTextColor,font: UIFont(name: fontNameSemiBold, size: (DetailFontsize+1).scaled) ?? .boldSystemFont(ofSize: 14),alignment: .left)
    self.containerView.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Leading:5,.Trailing:40,.HeightLessThanOrEqual:50,.Top:10])
    titleLbl.backgroundColor = .clear

    imgView = UIFactory.makeImageView(imageName: "",contentMode: .scaleToFill,cornerRadius: 0,clipsToBounds: true)
    self.containerView.addSubview(imgView)
    imgView.addConstraints(constraintsDict: [.FixHeight:75,.FixWidth:75,.Bottom:0,.Trailing:-15])
//    imgView.backgroundColor = .red

    self.applyExactSpotifyTransform()

  }
  
  func configure(obj: Item) {
    self.containerView.backgroundColor = UIColor(hex: obj.color ?? "")
    self.titleLbl.text = obj.name ?? ""
    self.imgView.setImage(urlStr: obj.image ?? "")
  }

  private func applyExactSpotifyTransform() {
      var transform = CATransform3DIdentity

      // Perspective: gives it depth
      transform.m34 = -1.0 / 500

      // Rotate 20 degrees on Z (the "lean")
      transform = CATransform3DRotate(transform, CGFloat(24 * Double.pi / 180), 0, 0, 1)

      // Rotate -25 degrees on Y (the "3D tilt" into the screen)
      transform = CATransform3DRotate(transform, CGFloat(-20 * Double.pi / 180), 0, 1, 0)

      imgView.layer.transform = transform

    // This smooths the edges of the tilted image
      imgView.layer.allowsEdgeAntialiasing = true


  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
