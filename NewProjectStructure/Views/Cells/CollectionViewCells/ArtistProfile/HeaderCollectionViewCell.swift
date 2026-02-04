//
//  HeaderCollectionViewCell.swift
//  NewProjectStructure
//
//  Created by Swapnil on 04/02/26.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell, ReusableCell {

  private var imgView:UIImageView!
 private var titleLbl:UILabel!
  private var containerView:UIView!

  private var playPauseBtn:UIButton!

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    self.setupUi()

    
  }

  private func setupUi(){

    self.imgView = UIFactory.makeImageView(imageName: "AppIcon",contentMode: .scaleToFill)
    self.contentView.addSubview(self.imgView)
    self.imgView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.Bottom:0])
    self.imgView.layoutIfNeeded()

    self.containerView = UIFactory.makeContinerView(backgroundColor: UIColor(red: 12/255,green: 18/255,blue: 16/255,alpha: 0.97))
    self.contentView.addSubview(self.containerView)
    self.containerView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.FixHeight:65,.Bottom:0])

    self.playPauseBtn = UIFactory.makeButton(backgroundColor: .clear,cornerRadius: 25*DeviceMultiplier,image: "playSong")
    self.containerView.addSubview(self.playPauseBtn)
    self.playPauseBtn.addConstraints(constraintsDict: [.FixWidth:50,.FixHeight:50,.Trailing:deviceMargin,.Bottom:5])
   // self.playPauseBtn.tag = 200
    self.playPauseBtn.addTarget(self, action: #selector(method), for: .touchUpInside)


  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.imgView.setGradientBackground(colors: [  UIColor(red: 25/255, green: 110/255, blue: 85/255, alpha: 0.30),
                                                  UIColor(red: 20/255, green: 80/255, blue: 65/255, alpha: 0.45),
                                                  UIColor.clear],
                                              locations: [0.0, 0.45, 0.75, 1.0],startPoint: CGPoint(x: 0.5, y: 0.0),endPoint: CGPoint(x: 0.5, y: 1.0))
  }

  override func prepareForReuse() {
         super.prepareForReuse()
         imgView.image = nil
     }

  func configure(obj: ArtistObject){
    self.imgView.setImage(urlStr: obj.image ?? "")

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
