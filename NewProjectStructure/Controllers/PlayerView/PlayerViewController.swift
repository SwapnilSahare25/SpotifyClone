//
//  PlayerViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 07/02/26.
//

import UIKit

class PlayerViewController: UIViewController, UIScrollViewDelegate, AudioPlayerDelegate, PlayPauseToggleDelegate {
  func didRequestInitialPlayback() {
    AudioPlayerManager.shared.playCurrent()
  }

  func didStartPlaying(song: Item) {
    updateCurrentSongUI(song: song)

  }

  func didPause() {
    playPauseBtn.updateUI(isPlaying: false)
  }

  func didResume() {
    playPauseBtn.updateUI(isPlaying: true)
  }

  func didStop() {
    playPauseBtn.updateUI(isPlaying: false)
    progressView.setProgress(0)
  }

  func didUpdateProgress(currentTime: Double, duration: Double) {
    let progress = Float(currentTime / duration)
    progressView.setProgress(progress)
    progressView.currentSecLabel.text = currentTime.toTimeString()
    progressView.duretionLabel.text = duration.toTimeString()
  }

  func reloadData(index: Int) {

  }

  func didUpdateShuffle(_ isEnabled: Bool) {

  }


  var scrollView:UIScrollView!
  var mainContainer: UIView!
  var progressView: MusicProgressView!
  var playPauseBtn: PlayPauseToggle!
  var titleLbl: UILabel!
  var subTitle: UILabel!
  var imgView: UIImageView!
  var replyBtn: UIButton!

  var currentPlaylistId: Int?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.setGradientBackground(colors: [UIColor(hex: "#141f3f"),UIColor(hex: "#0b1225"),UIColor.black], locations: [0.30,0.55,1.0])
    self.setupBackButton(image: "down",action: #selector(self.dismissView))
    self.setUpMainView()

  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    AudioPlayerManager.shared.addDelegate(self)
    if let currentSong = AudioPlayerManager.shared.currentSong {
           updateCurrentSongUI(song: currentSong)
       }
    updateRepeatButtonUI()

  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    AudioPlayerManager.shared.removeDelegate(self)
  }


  func setUpMainView(){

    self.scrollView = UIFactory.makeScrollView(isPagingEnabled: false,showsHorizontalScrollIndicator: false)
    self.view.addSubview(self.scrollView)
    self.scrollView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.Bottom:0])
    self.scrollView.delegate = self

    self.scrollView.backgroundColor = .clear
    self.scrollView.alwaysBounceVertical = false
    self.scrollView.contentInsetAdjustmentBehavior = .never

    mainContainer = UIFactory.makeContinerView(backgroundColor: .clear)
    scrollView.addSubview(mainContainer)
    mainContainer.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.Bottom:0])
    NSLayoutConstraint.activate([
      mainContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)

    ])

    imgView = UIFactory.makeImageView(imageName: "likedSongs",contentMode: .scaleToFill,cornerRadius:5*DeviceMultiplier,clipsToBounds: true)
    mainContainer.addSubview(imgView)
    imgView.addConstraints(constraintsDict: [.Trailing:30,.FixHeight:320,.Top:topBarHeight+20,.Leading:30])

//    titleLbl = MarqueeLabel(frame: .zero)
//    titleLbl.font = UIFont(name: fontNameBlack, size: (HugeTitleFontSize+6).scaled)
//    titleLbl.textColor = WhiteTextColor
//    mainContainer.addSubview(titleLbl)
//    titleLbl.addConstraints(constraintsDict: [.Trailing:80,.FixHeight:33,.Leading:30])
//    titleLbl.addConstraints(constraintsDict: [.BelowTo: 25], relativeTo: imgView)
//    titleLbl.backgroundColor = .clear
//    titleLbl.type = .continuous
//    titleLbl.speed = .rate(30)
//            titleLbl.animationDelay = 1.0
//            titleLbl.trailingBuffer = 30

    titleLbl = UIFactory.makeLabel(text:"Liked Songs",textColor: WhiteTextColor,font: UIFont(name: fontNameBlack, size: (HugeTitleFontSize+6).scaled) ?? .boldSystemFont(ofSize: HugeTitleFontSize+6),alignment: .left)
    self.mainContainer.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Trailing:80,.FixHeight:33,.Leading:30])
    titleLbl.addConstraints(constraintsDict: [.BelowTo: 25],relativeTo: imgView)
    titleLbl.backgroundColor = .clear

    subTitle = UIFactory.makeLabel(text:"10 Songs",textColor: SecondaryTextColor,font: UIFont(name: fontNameMedium, size: (SubTitleFontsize).scaled) ?? .boldSystemFont(ofSize: SubTitleFontsize),alignment: .left)
    self.mainContainer.addSubview(subTitle)
    subTitle.addConstraints(constraintsDict: [.Trailing:80,.FixHeight:17,.Leading:30])
    subTitle.addConstraints(constraintsDict: [.BelowTo: 5],relativeTo: titleLbl)
    subTitle.backgroundColor = .clear

    let likeBtn = ToggleLikeButton(frame: .zero)
    self.mainContainer.addSubview(likeBtn)
    likeBtn.addConstraints(constraintsDict: [.FixWidth:30,.FixHeight:25,.Trailing:30])
    likeBtn.addConstraints(constraintsDict: [.BelowTo: 45],relativeTo: imgView)


    progressView = MusicProgressView(frame: .zero)
    self.mainContainer.addSubview(progressView)
    progressView.addConstraints(constraintsDict: [.Leading:30,.Trailing:30,.FixHeight:60])
    progressView.addConstraints(constraintsDict: [.BelowTo: 10],relativeTo: subTitle)


    let btnStackView = UIStackView()
    btnStackView.axis = .horizontal
    btnStackView.distribution = .fillProportionally
    btnStackView.spacing = 31*DeviceMultiplier
    btnStackView.alignment = .center
    self.mainContainer.addSubview(btnStackView)
    btnStackView.translatesAutoresizingMaskIntoConstraints = false

    btnStackView.backgroundColor = .clear // Note: StackView background color works in iOS 14+
    btnStackView.addConstraints(constraintsDict: [.Leading:30, .Trailing:30, .FixHeight:90])
    btnStackView.addConstraints(constraintsDict: [.BelowTo:0], relativeTo: progressView)


    let shuffleBtn = ShuffleButton(frame: .zero)

    let previousBtn = UIFactory.makeButton(backgroundColor: .clear, image: "previous")
    previousBtn.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)

    playPauseBtn = PlayPauseToggle(frame: .zero,playImage: "playBlackIcon",pauseImage: "pauseBlackIcon")
    playPauseBtn.layer.cornerRadius = 40*DeviceMultiplier
    playPauseBtn.actionDelegate = self
    playPauseBtn.playlistId = currentPlaylistId
    playPauseBtn.isHeader = true
    playPauseBtn.updateUI(isPlaying: AudioPlayerManager.shared.isPlaying && AudioPlayerManager.shared.currentPlaylistId == currentPlaylistId)

    let nextBtn = UIFactory.makeButton(backgroundColor: .clear, image: "next")
    nextBtn.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)

    replyBtn = UIFactory.makeButton(backgroundColor: .clear, image: "replyOff")
    replyBtn.addTarget(self, action: #selector(repeatTapped), for: .touchUpInside)


    [shuffleBtn, previousBtn, playPauseBtn, nextBtn, replyBtn].forEach { btnStackView.addArrangedSubview($0) }

    shuffleBtn.addConstraints(constraintsDict: [.FixWidth:30, .FixHeight:30])
    previousBtn.addConstraints(constraintsDict: [.FixWidth:30, .FixHeight:30])
    playPauseBtn.addConstraints(constraintsDict: [.FixWidth:80, .FixHeight:80])
    nextBtn.addConstraints(constraintsDict: [.FixWidth:30, .FixHeight:30])
    replyBtn.addConstraints(constraintsDict: [.FixWidth:30, .FixHeight:30])


    let speakerBtn = UIFactory.makeButton(backgroundColor: .clear, image: "speaker")
    self.mainContainer.addSubview(speakerBtn)
    speakerBtn.addConstraints(constraintsDict: [.FixWidth:30,.FixHeight:30,.Leading:30])
    speakerBtn.addConstraints(constraintsDict: [.BelowTo: 25],relativeTo: btnStackView)


    let queueBtn = UIFactory.makeButton(backgroundColor: .clear, image: "queue")
    self.mainContainer.addSubview(queueBtn)
    queueBtn.addConstraints(constraintsDict: [.FixWidth:25,.FixHeight:25,.Trailing:30])
    queueBtn.addConstraints(constraintsDict: [.BelowTo: 25],relativeTo: btnStackView)


    let shareBtn = UIFactory.makeButton(backgroundColor: .clear, image: "share")
    self.mainContainer.addSubview(shareBtn)
    shareBtn.addConstraints(constraintsDict: [.FixWidth:25,.FixHeight:25])
    shareBtn.addConstraints(constraintsDict: [.BelowTo: 25],relativeTo: btnStackView)
    shareBtn.addConstraints(constraintsDict: [.LeftTo: 25],relativeTo: queueBtn)


    let spacerView = UIView()
    self.mainContainer.addSubview(spacerView)
    spacerView.addConstraints(constraintsDict: [.Leading:0,.FixHeight:5,.Trailing:0])
    spacerView.addConstraints(constraintsDict: [.BelowTo: 30],relativeTo: speakerBtn)
    spacerView.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor, constant: -20).isActive = true

  }
  private func updateCurrentSongUI(song: Item) {
    self.view.layoutIfNeeded()
      titleLbl.text = song.title
      subTitle.text = song.artist
      imgView.setImage(urlStr: song.image ?? "")
      playPauseBtn.updateUI(isPlaying: AudioPlayerManager.shared.isPlaying)

      if let duration = song.duration?.toSeconds() {
          progressView.duretionLabel.text = duration.toTimeString()
      }
      progressView.currentSecLabel.text = "0:00"
      progressView.setProgress(0)
    updateRepeatButtonUI()
  }

  @objc func previousTapped() {
    AudioPlayerManager.shared.playPrevious()
  }
  @objc func nextTapped() {
    AudioPlayerManager.shared.playNext()
  }

  func didTapPlayPause() {
    AudioPlayerManager.shared.togglePlayPause()
  }
  @objc func repeatTapped() {
      AudioPlayerManager.shared.toggleRepeat()
    self.updateRepeatButtonUI()
     }
  private func updateRepeatButtonUI() {
      switch AudioPlayerManager.shared.repeatMode {
      case .off:
          replyBtn.setImage(UIImage(named: "replyOff"), for: .normal)
      case .all:
          replyBtn.setImage(UIImage(named: "replyAll"), for: .normal)
      case .one:
          replyBtn.setImage(UIImage(named: "replyOne"), for: .normal)
      }
  }

  @objc func dismissView() {
    self.navigationController?.dismiss(animated: true)
  }



}
