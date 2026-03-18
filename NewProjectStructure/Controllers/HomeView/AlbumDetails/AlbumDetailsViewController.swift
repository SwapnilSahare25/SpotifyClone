//
//  AlbumDetailsViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 03/02/26.
//

import UIKit

class AlbumDetailsViewController: UIViewController, AudioPlayerDelegate, PlayPauseToggleDelegate, LikeUpdateDelegate {
  func didUpdateLike() {
    self.callAlbumDetailsApi()
  }
  
  func didRequestInitialPlayback() {
    guard let songs = self.albumDetails?.tracks?.items,
          !songs.isEmpty else { return }
    AudioPlayerManager.shared.playSongs(songs, startIndex: 0, playlistId: self.albumId)
    updateTableViewInset()
  }
  
  func didUpdateShuffle(_ isEnabled: Bool) {
  
  }
  
  func didStartPlaying(song: Item) {
    self.currentTime = 0
    tableView.reloadData()
  }

  func didPause() {
    tableView.reloadData()
  }

  func didResume() {
    tableView.reloadData()
  }

  func didStop() {
    tableView.reloadData()
  }

  func didUpdateProgress(currentTime: Double, duration: Double) {
    self.currentTime = currentTime
    tableView.reloadData()
  }

  func reloadData(index: Int) {
    tableView.reloadData()
  }




  private var tableView: UITableView!
  var albumId:Int = 0
  var albumDetails: AlbumObject?
  var currentTime: Double = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .black
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.backgroundColor = .clear
    
    self.edgesForExtendedLayout = .all
    self.extendedLayoutIncludesOpaqueBars = true
    self.navigationItem.largeTitleDisplayMode = .never
    self.setupBackButton()
    self.setUpMainView()
    self.setupHeader()
    self.callAlbumDetailsApi()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    AudioPlayerManager.shared.addDelegate(self)
    tableView.reloadData()
    updateTableViewInset()

  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    AudioPlayerManager.shared.removeDelegate(self)
  }
  private func updateTableViewInset() {
    if AudioPlayerManager.shared.isMiniPlayerVisible {
      let playerHeight: CGFloat = 56.0*DeviceMultiplier
      tableView.contentInset.bottom = playerHeight + 25*DeviceMultiplier
    } else {
      tableView.contentInset.bottom = 0
    }
  }


  private func setUpMainView(){

    self.tableView = UIFactory.makeTableView(separatorStyle: .none)
    self.view.addSubview(self.tableView)
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.backgroundColor = .clear
    self.tableView.register(AlbumDetailsTableViewCell.self, forCellReuseIdentifier: AlbumDetailsTableViewCell.identifier)
    self.tableView.contentInsetAdjustmentBehavior = .never
    self.tableView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Bottom:0,.Top:0])


  }

  private func setupHeader(){

    let headerView = UIFactory.makeContinerView(backgroundColor: .black,frame: CGRect(x: 0, y: 0, width: DeviceWidth, height: 450*DeviceMultiplier))
    headerView.setGradientBackground(colors: [UIColor(hex: "#3B5563"),UIColor(hex: "#050708")], locations: [0.0,1.0],startPoint: CGPoint(x: 0.5, y: 0.0),endPoint: CGPoint(x: 0.5, y: 1.0))

    let imgView = UIFactory.makeImageView(imageName: self.albumDetails?.image ?? "",contentMode: .scaleAspectFit,cornerRadius: 0,clipsToBounds: true)
    headerView.addSubview(imgView)
    imgView.addConstraints(constraintsDict: [.Trailing:60,.FixHeight:245,.Top:statusBarHeight+10,.Leading:60])

    let titleLbl = UIFactory.makeLabel(text:self.albumDetails?.title ?? "",textColor: WhiteTextColor,font: UIFont(name: fontNameBlack, size: (HugeTitleFontSize+4)) ?? .boldSystemFont(ofSize: BigTitleFontsize),alignment: .left)
    headerView.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Trailing:CGFloat.DeviceMargin,.FixHeight:35,.Leading:CGFloat.DeviceMargin])
    titleLbl.addConstraints(constraintsDict: [.BelowTo: 25],relativeTo: imgView)
    titleLbl.backgroundColor = .clear


    let type = self.albumDetails?.type?.capitalized ?? ""
    let artist = self.albumDetails?.artist ?? ""
    let year = self.albumDetails?.year ?? 0

    let subTitleText = "\(type):- \(artist) - \(year)"

    let subTitle = UIFactory.makeLabel(text:subTitleText,textColor: SecondaryTextColor,font: UIFont(name: fontNameRegular, size: (DetailTabFontSize)) ?? .boldSystemFont(ofSize: DetailTabFontSize),alignment: .left)
    headerView.addSubview(subTitle)
    subTitle.addConstraints(constraintsDict: [.Trailing:CGFloat.DeviceMargin,.FixHeight:15,.Leading:CGFloat.DeviceMargin])
    subTitle.addConstraints(constraintsDict: [.BelowTo: 5],relativeTo: titleLbl)
    subTitle.backgroundColor = .clear


    let songsCount = self.albumDetails?.tracks?.total ?? 0
    let totalDuration = self.albumDetails?.totalDuration ?? ""

    let songsCountAndDuretionTitleText = "\(songsCount) songs - \(totalDuration)"


    let songsCountAndDuretionTitle = UIFactory.makeLabel(text:songsCountAndDuretionTitleText,textColor: SecondaryTextColor,font: UIFont(name: fontNameRegular, size: (DetailTabFontSize)) ?? .boldSystemFont(ofSize: DetailTabFontSize),alignment: .left)
    headerView.addSubview(songsCountAndDuretionTitle)
    songsCountAndDuretionTitle.addConstraints(constraintsDict: [.Trailing:50,.FixHeight:15,.Leading:CGFloat.DeviceMargin])
    songsCountAndDuretionTitle.addConstraints(constraintsDict: [.BelowTo: 5],relativeTo: subTitle)
    songsCountAndDuretionTitle.backgroundColor = .clear

    let playBtn = PlayPauseToggle(frame: .zero,playImage: "playSong",pauseImage: "pauseSong")
    headerView.addSubview(playBtn)
    playBtn.addConstraints(constraintsDict: [.FixWidth:60,.FixHeight:60,.Trailing:CGFloat.DeviceMargin,.Bottom:5])
    playBtn.actionDelegate = self
    playBtn.playlistId = albumId
    playBtn.isHeader = true
    playBtn.updateUI(isPlaying: AudioPlayerManager.shared.isPlaying && AudioPlayerManager.shared.currentPlaylistId == albumId)


    //playBtn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)

    let shuffleBtn = ShuffleButton(frame: .zero)
    headerView.addSubview(shuffleBtn)
    shuffleBtn.addConstraints(constraintsDict: [.FixWidth:20,.FixHeight:20,.Bottom:20])
    shuffleBtn.addConstraints(constraintsDict: [.LeftTo: 15],relativeTo: playBtn)
//    if AudioPlayerManager.shared.isPlaying {
//      shuffleBtn.isUserInteractionEnabled = true
//      shuffleBtn.isEnabled = true
//    }else{
//      shuffleBtn.isUserInteractionEnabled = false
//      shuffleBtn.isEnabled = false
//    }
//

    let likeBtn = ToggleLikeButton(frame: .zero)
    headerView.addSubview(likeBtn)
    likeBtn.addConstraints(constraintsDict: [.FixWidth:25,.FixHeight:25,.Leading:CGFloat.DeviceMargin,.Bottom:5])
    likeBtn.delegate = self
    likeBtn.configure(id: self.albumDetails?.id ?? 0, type: "album", isLiked: albumDetails?.isLiked ?? false)
    //likeBtn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)


    let moreOptsBtn = UIFactory.makeButton(backgroundColor: .clear,image: "moreOptsHori")
    headerView.addSubview(moreOptsBtn)
    moreOptsBtn.addConstraints(constraintsDict: [.FixWidth:15,.FixHeight:15,.Bottom:10])
    moreOptsBtn.addConstraints(constraintsDict: [.RightTo:15],relativeTo: likeBtn)


    self.tableView.tableHeaderView = headerView

  }


  private func callAlbumDetailsApi() {
    let endPoint = Endpoints.getAlbumDetails(albumId: self.albumId)

    APIManager.shared.request(endpoint: endPoint) { [weak self] (object: AlbumObject) in

      if let self = self {
        self.albumDetails = object
        self.setupHeader()

        self.tableView.reloadData()

      }else{
        print("No Data Found")
      }
    } onFailure: { error in
      print(error)
    }

  }



  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let triggerOffset = (tableView.tableHeaderView?.frame.height ?? 300) - 100*DeviceMultiplier

    if offsetY >= triggerOffset {
      navigationItem.title = "Album"
      self.setNavBarGradient(colors: [UIColor(hex: "#3B5563"),UIColor(hex: "#050708")])
    } else {
      navigationItem.title = ""
      setNavBarColor(.clear)
    }
  }


}
extension AlbumDetailsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.albumDetails?.tracks?.items?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: AlbumDetailsTableViewCell.identifier, for: indexPath) as! AlbumDetailsTableViewCell

    if let items = self.albumDetails?.tracks?.items{
      let currentSong = AudioPlayerManager.shared.currentSong
      let currentSongPlaying = currentSong?.id == items[indexPath.row].id
      cell.configure(obj: items[indexPath.row], index: indexPath.row,isCurrentSong: currentSongPlaying,currectTime: currentTime)
    }

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60*DeviceMultiplier
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    guard let items = self.albumDetails?.tracks?.items else { return }
    AudioPlayerManager.shared.playSongs(items, startIndex: indexPath.row, playlistId: self.albumId)
    self.updateTableViewInset()

  }
}
