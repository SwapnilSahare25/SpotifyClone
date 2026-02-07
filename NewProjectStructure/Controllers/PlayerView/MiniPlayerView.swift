//
//  MiniPlayerView.swift
//  NewProjectStructure
//
//  Created by Swapnil on 07/02/26.
//

import UIKit

protocol MiniPlayerDelegate: AnyObject {
    func didTapMiniPlayer()
    func didTapPlayPause()
  func didSwipeToClose()
}

class MiniPlayerView: UIView {



  private var imageView:UIImageView!
  private var titleLabel: UILabel!
  private var subtitleLabel: UILabel!
  private var playPauseButton: UIButton!

  private var likeBtn: UIButton!
  private var originalCenter: CGPoint = .zero

  private let progressBar = UIProgressView(progressViewStyle: .bar)

  weak var delegate: MiniPlayerDelegate?

     override init(frame: CGRect) {
         super.init(frame: frame)
         setupUI()
         setupActions()
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

     private func setupUI() {
       self.translatesAutoresizingMaskIntoConstraints = false

       self.backgroundColor = MiniPlayerBgColor

       self.progressBar.trackTintColor = .white.withAlphaComponent(0.3)
       self.progressBar.progressTintColor = .white
       self.progressBar.translatesAutoresizingMaskIntoConstraints = false
       self.addSubview(self.progressBar)
       self.progressBar.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Bottom:0,.FixHeight:2])


       self.imageView = UIFactory.makeImageView(contentMode: .scaleToFill,cornerRadius: 4*DeviceMultiplier,clipsToBounds: true)
       self.imageView.backgroundColor = CellBgColor
       self.addSubview(self.imageView)
       self.imageView.addConstraints(constraintsDict: [.Leading:deviceMargin,.CenterY:0,.FixHeight:40,.FixWidth:40])

       self.titleLabel = UIFactory.makeLabel(text:"Start Now",textColor: WhiteTextColor,font: UIFont(name: fontNameSemiBold, size: (DetailFontsize-1).scaled) ?? .boldSystemFont(ofSize: DetailFontsize-1),alignment: .left)
       self.addSubview(self.titleLabel)
       titleLabel.addConstraints(constraintsDict: [.Trailing:60,.FixHeight:15,.Top:12])
       titleLabel.addConstraints(constraintsDict: [.RightTo: 10],relativeTo: self.imageView)
       titleLabel.backgroundColor = .clear

       self.subtitleLabel = UIFactory.makeLabel(text:"3:45",textColor: SecondaryTextColor,font: UIFont(name: fontNameRegular, size: (SmallFontSize-1).scaled) ?? .boldSystemFont(ofSize: SmallFontSize-1),alignment: .left)
       self.addSubview(subtitleLabel)
       subtitleLabel.addConstraints(constraintsDict: [.Trailing:40,.FixHeight:15,.Bottom:12])
       subtitleLabel.addConstraints(constraintsDict: [.RightTo: 10],relativeTo: self.imageView)
       subtitleLabel.backgroundColor = .clear


       playPauseButton = UIFactory.makeButton(backgroundColor: .clear,image: "miniPause")
       self.addSubview(playPauseButton)
       playPauseButton.addConstraints(constraintsDict: [.FixWidth:25,.FixHeight:25,.Trailing:deviceMargin,.CenterY:0])
       playPauseButton.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)

       self.likeBtn = UIFactory.makeButton(backgroundColor: .clear,image: "unlike")
       self.addSubview(likeBtn)
       likeBtn.addConstraints(constraintsDict: [.FixWidth:25,.FixHeight:25,.CenterY:0])
       likeBtn.addConstraints(constraintsDict: [.LeftTo:10],relativeTo: playPauseButton)
       //likeBtn.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)


     }

     private func setupActions() {
         let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
         addGestureRecognizer(tap)


       let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
              addGestureRecognizer(pan)
          
     }

  @objc private func handleTap(){
    delegate?.didTapMiniPlayer()
  }

  @objc private func playPauseTapped(){
    print("PlayBtnClicked")
    delegate?.didTapPlayPause()
  }

     func configure(title: String, subtitle: String, imageURL: String?) {
         titleLabel.text = title
         subtitleLabel.text = subtitle
        imageView.setImage(urlStr: imageURL ?? "")
     }

     func setPlaying(_ isPlaying: Bool) {

         let iconName = isPlaying ? "miniPause" : "miniPlay"
         playPauseButton.setImage(UIImage(named: iconName), for: .normal)
     }

     func setProgress(_ progress: Float) {
         progressBar.setProgress(progress, animated: true)
     }


  @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
      guard let targetView = gesture.view else { return }
      let translation = gesture.translation(in: superview)

      switch gesture.state {
      case .began:
          originalCenter = targetView.center
      case .changed:
          // Only allow dragging DOWN
          if translation.y > 0 {
              targetView.center = CGPoint(x: originalCenter.x, y: originalCenter.y + translation.y)
          }
      case .ended:
          // If dragged down more than 50 points, close it
          if translation.y > 50 {
              delegate?.didSwipeToClose()
          } else {
              // Return to original position
              UIView.animate(withDuration: 0.3) {
                  targetView.center = self.originalCenter
              }
          }
      default:
          break
      }
  }

}
