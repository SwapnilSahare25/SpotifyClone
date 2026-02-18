//
//  NewReleaseCollectionViewCell.swift
//  NewProjectStructure
//
//  Created by Swapnil on 24/12/25.
//

import UIKit


class NewReleaseCollectionViewCell: UICollectionViewCell,ReusableCell, PlayPauseToggleDelegate {


  func didRequestInitialPlayback() {
    guard let id = newReleaseId else { return }
    APIManager.shared.request(endpoint: Endpoints.getAlbumDetails(albumId: id)) { [weak self] (object: AlbumObject) in
     // guard let self = self else { return }
      if let items = object.tracks?.items{
        AudioPlayerManager.shared.playSongs(items, startIndex: 0, playlistId: id)
        //self.delegate?.reloadData()
      }else{
        print("NO Songs Found")
      }
      } onFailure: { error in
          print(error)
      }
  }
  
    
  var containerView: UIView!
  var imgView: UIImageView!

  var songTitleLbl: UILabel!
  var artistNameLbl: UILabel!

  var playPauseBtn:PlayPauseToggle!

  var likeUnlikeBtn:ToggleLikeButton!

  var newReleaseId: Int?

  weak var homeReloadDelegate: LikeUpdateDelegate?{
    didSet{
      self.likeUnlikeBtn.delegate = self.homeReloadDelegate
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = CellBgColor
    self.setUpUi()

  }
  private func setUpUi(){
    self.containerView = UIFactory.makeContinerView(backgroundColor: ViewBGColor,cornerRadius: 10*DeviceMultiplier)
    self.contentView.addSubview(self.containerView)
    self.containerView.addConstraints(constraintsDict: [.Leading:deviceMargin,.Trailing:deviceMargin,.Top:0,.Bottom:0])

    self.imgView = UIFactory.makeImageView(contentMode: .scaleToFill)
    self.containerView.addSubview(self.imgView)
    self.imgView.addConstraints(constraintsDict: [.Leading:0,.Bottom:0,.Top:0,.FixWidth:140])

    self.songTitleLbl = UIFactory.makeLabel(text: "",textColor: WhiteTextColor,font: UIFont(name: fontNameMedium, size: (SmallFontSize).scaled) ?? .boldSystemFont(ofSize: 12),alignment: .left)
    self.songTitleLbl.adjustsFontForContentSizeCategory = true
    self.containerView.addSubview(self.songTitleLbl)
    self.songTitleLbl.addConstraints(constraintsDict: [.FixHeight:14,.Top:20,.Trailing:0])
    self.songTitleLbl.addConstraints(constraintsDict: [.RightTo:16],relativeTo: self.imgView)
    //self.songTitleLbl.backgroundColor = .red

    self.artistNameLbl = UIFactory.makeLabel(text: "",textColor: WhiteTextColor,font: UIFont(name: fontNameRegular, size: (SmallFontSize-1).scaled) ?? .boldSystemFont(ofSize: 11),alignment: .left)
    self.artistNameLbl.adjustsFontForContentSizeCategory = true
    self.containerView.addSubview(self.artistNameLbl)
    self.artistNameLbl.addConstraints(constraintsDict: [.FixHeight:13,.Trailing:0])
    self.artistNameLbl.addConstraints(constraintsDict: [.BelowTo:2],relativeTo: self.songTitleLbl)
    self.artistNameLbl.addConstraints(constraintsDict: [.RightTo:16],relativeTo: self.imgView)
    //self.artistNameLbl.backgroundColor = .red


    self.playPauseBtn = PlayPauseToggle(frame: .zero,playImage: "playSong",pauseImage: "pauseSong")
    self.containerView.addSubview(self.playPauseBtn)
    self.playPauseBtn.addConstraints(constraintsDict: [.FixWidth:40,.FixHeight:40,.Trailing:deviceMargin,.Bottom:15])
    self.playPauseBtn.actionDelegate = self

    self.likeUnlikeBtn = ToggleLikeButton(frame: .zero)
    self.containerView.addSubview(self.likeUnlikeBtn)
    self.likeUnlikeBtn.addConstraints(constraintsDict: [.FixWidth:25,.FixHeight:25,.Bottom:20])
    self.likeUnlikeBtn.addConstraints(constraintsDict: [.RightTo:16],relativeTo: self.imgView)

  }


  func configure(obj: NewRelease) {
    self.newReleaseId = obj.content?.id ?? 0
    self.songTitleLbl.text = obj.content?.title ?? ""
    self.artistNameLbl.text = obj.content?.subtitle ?? ""
    self.imgView.setImage(urlStr: obj.content?.image ?? "")

    self.likeUnlikeBtn.configure(id: obj.content?.id ?? 0, type: "album", isLiked: obj.content?.isLiked ?? false)

    self.playPauseBtn.playlistId = obj.content?.id ?? 0
    self.playPauseBtn.isHeader = true
    self.playPauseBtn.updateUI(isPlaying: AudioPlayerManager.shared.isPlaying && AudioPlayerManager.shared.currentPlaylistId == obj.content?.id)





  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
