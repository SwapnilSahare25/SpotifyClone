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

  private var playPauseBtn:PlayPauseToggle!

  private var followBtn:UIButton!
  private var likeBtn:UIButton!
  private var moreOptsBtn:UIButton!

  private var followerLbl:UILabel!

  private var gradientOverlay:UIView!

  weak var delegate: PlayPauseToggleDelegate? {
    didSet{
      self.playPauseBtn?.actionDelegate = self.delegate
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    self.setupUi()
    self.setNeedsLayout()
    self.layoutIfNeeded()

  }

  private func setupUi(){

    self.imgView = UIFactory.makeImageView(imageName: "AppIcon",contentMode: .scaleToFill)
    self.contentView.addSubview(self.imgView)
    self.imgView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.Bottom:0])
    self.imgView.layoutIfNeeded()

    self.containerView = UIFactory.makeContinerView(backgroundColor:.clear)
    self.contentView.addSubview(self.containerView)
    self.containerView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.FixHeight:65,.Bottom:0])

    self.titleLbl = UIFactory.makeLabel(text:"Title",textColor: WhiteTextColor,font: UIFont(name: fontNameBlack, size: (HugeTitleFontSize+6).scaled) ?? .boldSystemFont(ofSize: HugeTitleFontSize+6),alignment: .left)
    self.contentView.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Trailing:40,.HeightLessThanOrEqual:50,.Leading:deviceMargin])
    titleLbl.addConstraints(constraintsDict: [.AboveTo: 0],relativeTo: self.containerView)
    titleLbl.backgroundColor = .clear

    self.playPauseBtn = PlayPauseToggle(frame: .zero)
    self.containerView.addSubview(self.playPauseBtn)
    self.playPauseBtn.addConstraints(constraintsDict: [.FixWidth:50,.FixHeight:50,.Trailing:deviceMargin,.Bottom:5])
    self.playPauseBtn.addTarget(self, action: #selector(method), for: .touchUpInside)

    self.followerLbl = UIFactory.makeLabel(text:"1.2M monthly listeners",textColor: SecondaryTextColor,font: UIFont(name: fontNameRegular, size: (SmallFontSize+1).scaled) ?? .boldSystemFont(ofSize: SmallFontSize+1),alignment: .left)
    self.containerView.addSubview(followerLbl)
    followerLbl.addConstraints(constraintsDict: [.Trailing:60,.FixHeight:15,.Leading:deviceMargin,.Top:5])
    followerLbl.backgroundColor = .clear

    self.likeBtn = UIFactory.makeButton(backgroundColor: .clear,image: "unlike")
    self.containerView.addSubview(likeBtn)
    likeBtn.addConstraints(constraintsDict: [.FixWidth:25,.FixHeight:25,.Leading:deviceMargin,.Bottom:5])

    self.followBtn = UIFactory.makeButton(title: "Following",font: UIFont(name: fontNameMedium, size: DetailTabFontSize.scaled) ?? .boldSystemFont(ofSize: 13),backgroundColor: .clear,cornerRadius: 12.5*DeviceMultiplier)
    self.containerView.addSubview(self.followBtn)
    self.followBtn.addConstraints(constraintsDict: [.FixWidth:80,.FixHeight:25,.Bottom:5])
    self.followBtn.addConstraints(constraintsDict: [.RightTo:15],relativeTo: self.likeBtn)
    self.followBtn.layer.borderColor = WhiteBgColor.cgColor
    self.followBtn.layer.borderWidth = 1*DeviceMultiplier
    self.followBtn.addTarget(self, action: #selector(method), for: .touchUpInside)

    self.moreOptsBtn = UIFactory.makeButton(backgroundColor: .clear,image: "moreOptsHori")
    self.containerView.addSubview(self.moreOptsBtn)
    self.moreOptsBtn.addConstraints(constraintsDict: [.FixWidth:15,.FixHeight:15,.Bottom:10])
    self.moreOptsBtn.addConstraints(constraintsDict: [.RightTo:15],relativeTo: self.followBtn)

    self.gradientOverlay = UIFactory.makeContinerView(backgroundColor:.clear)
    self.imgView.addSubview(self.gradientOverlay)
    self.gradientOverlay.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.Bottom:0])

  }

  // MARK: - Layout Subviews
  override func layoutSubviews() {
    super.layoutSubviews()
    self.gradientOverlay.setGradientBackground(colors: [UIColor.clear,UIColor.black.withAlphaComponent(0.15),UIColor.black.withAlphaComponent(0.45),
                                                        UIColor.black.withAlphaComponent(0.85),UIColor.black.withAlphaComponent(1)],locations: [0, 0.35, 0.55, 0.75, 1],
                                               startPoint: CGPoint(x: 0.5, y: 0.0),endPoint: CGPoint(x: 0.5, y: 1.0))
  }


  // MARK: - Prepare For Reuse
  override func prepareForReuse() {
    super.prepareForReuse()
    imgView.image = nil
  }
  func configure(obj: ArtistObject){
    self.imgView.setImage(urlStr: obj.image ?? "")
    self.titleLbl.text = obj.name ?? ""
    let followerCount = obj.followers ?? ""
    self.followerLbl.text = followerCount+" "+"monthly listeners"

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
