//
//  GradientLikedSongsView.swift
//  NewProjectStructure
//
//  Created by Swapnil on 29/01/26.
//

import UIKit

class GradientLikedSongsView: UIView {

  private let gradientLayer = CAGradientLayer()

  private var titleLbl:UILabel!
  private var subTitle:UILabel!

  private var imgView:UIImageView!
  private var playPauseBtn:PlayPauseToggle!

  private var likeBtn:UIButton!
  private var shuffleBtn:UIButton!
  private var moreOptsBtn:UIButton!

  weak var delegate: PlayPauseToggleDelegate? {
      didSet {
          playPauseBtn?.actionDelegate = delegate
      }
  }


  func configure(count: Int) {
         subTitle.text = "\(count) songs"
     }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupGradient()
    self.setUpUI()
  }

  required init?(coder: NSCoder) { fatalError() }

  private func setUpUI(){

    self.imgView = UIFactory.makeImageView(imageName: "likedSongs",contentMode: .scaleAspectFit,clipsToBounds: true)
    self.addSubview(imgView)
    imgView.addConstraints(constraintsDict: [.Trailing:30,.FixHeight:200,.Top:statusBarHeight,.Leading:30])


    self.titleLbl = UIFactory.makeLabel(text:"Liked Songs",textColor: WhiteTextColor,font: UIFont(name: fontNameBlack, size: (HugeTitleFontSize+6).scaled) ?? .boldSystemFont(ofSize: HugeTitleFontSize+6),alignment: .left)
    self.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Trailing:80,.FixHeight:35,.Leading:deviceMargin])
    titleLbl.addConstraints(constraintsDict: [.BelowTo: 25],relativeTo: imgView)
    titleLbl.backgroundColor = .clear

    self.subTitle = UIFactory.makeLabel(text:"10 Songs",textColor: SecondaryTextColor,font: UIFont(name: fontNameRegular, size: (DetailTabFontSize).scaled) ?? .boldSystemFont(ofSize: DetailTabFontSize),alignment: .left)
    self.addSubview(subTitle)
    subTitle.addConstraints(constraintsDict: [.Trailing:80,.FixHeight:15,.Leading:deviceMargin])
    subTitle.addConstraints(constraintsDict: [.BelowTo: 5],relativeTo: titleLbl)
    subTitle.backgroundColor = .clear

    self.playPauseBtn = PlayPauseToggle(frame: .zero)
    self.addSubview(self.playPauseBtn)
    self.playPauseBtn.addConstraints(constraintsDict: [.FixWidth:50,.FixHeight:50,.Trailing:deviceMargin,.Bottom:10])


   // self.playPauseBtn.addConstraints(constraintsDict: [.BelowTo: 10],relativeTo: titleLbl)
    //self.playPauseBtn.tag = 100
    //self.playPauseBtn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
//    self.playPauseBtn.isHidden = true

    self.likeBtn = UIFactory.makeButton(backgroundColor: .clear,image: "unlike")
    self.addSubview(likeBtn)
    likeBtn.addConstraints(constraintsDict: [.FixWidth:25,.FixHeight:25,.Leading:deviceMargin,.Bottom:15])


    self.shuffleBtn = ShuffleButton(frame: .zero)
    self.addSubview(shuffleBtn)
    shuffleBtn.addConstraints(constraintsDict: [.FixWidth:20,.FixHeight:20,.Bottom:20])
    self.shuffleBtn.addConstraints(constraintsDict: [.LeftTo: 15],relativeTo: self.playPauseBtn)


    self.moreOptsBtn = UIFactory.makeButton(backgroundColor: .clear,image: "moreOptsHori")
    self.addSubview(self.moreOptsBtn)
    self.moreOptsBtn.addConstraints(constraintsDict: [.FixWidth:15,.FixHeight:15,.Bottom:20])
    self.moreOptsBtn.addConstraints(constraintsDict: [.RightTo:15],relativeTo: self.likeBtn)

    let spaceView = UIView()
    self.addSubview(spaceView)
    spaceView.addConstraints(constraintsDict: [.Leading:deviceMargin,.Bottom:0,.Trailing:deviceMargin])
    spaceView.addConstraints(constraintsDict: [.BelowTo: 20],relativeTo: playPauseBtn)


  }

  private func setupGradient() {

    let topPurple = UIColor(red: 105/255, green: 56/255, blue: 179/255, alpha: 1).cgColor
    let midBlue   = UIColor(red: 83/255, green: 129/255, blue: 196/255, alpha: 1).cgColor
    let bottomDark = UIColor.black.cgColor

    gradientLayer.colors = [topPurple, midBlue, bottomDark]
    gradientLayer.locations = [0.0, 0.35, 1.0]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint   = CGPoint(x: 0.5, y: 1)

    layer.insertSublayer(gradientLayer, at: 0)
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    CATransaction.begin()
    CATransaction.setDisableActions(true)
    gradientLayer.frame = self.bounds
    CATransaction.commit()


  }
}
