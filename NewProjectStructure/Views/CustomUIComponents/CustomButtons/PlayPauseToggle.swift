//
//  PlayPauseToggle.swift
//  NewProjectStructure
//
//  Created by Swapnil on 12/02/26.
//

import UIKit

protocol PlayPauseToggleDelegate: AnyObject {
  func didRequestInitialPlayback()
}


class PlayPauseToggle: UIButton {


  weak var actionDelegate: PlayPauseToggleDelegate?

  private var playImageName: String
  private var pauseImageName: String
  private var isPlaying = false
  var playlistId: Int?
  var isHeader: Bool = false

  // MARK: - Initializer
  init(frame: CGRect, playImage: String = "playSong", pauseImage: String = "pauseSong") {
    self.playImageName = playImage
    self.pauseImageName = pauseImage
    super.init(frame: frame)
    setupBtnUI()
    AudioPlayerManager.shared.addDelegate(self)
  }
  private func setupBtnUI(){

    updateState()
    self.addTarget(self, action: #selector(togglePlayPauseTapped), for: .touchUpInside)


  }



  @objc private func togglePlayPauseTapped() {
      let manager = AudioPlayerManager.shared
      guard let playlistId = playlistId else { return }

      if isHeader {
          // header button: play whole playlist
          if manager.currentPlaylistId == playlistId {
              manager.togglePlayPause()
          } else {
              actionDelegate?.didRequestInitialPlayback()
          }
      } else {
          // cell button: play single song
          if manager.currentSong?.id == playlistId {
              manager.togglePlayPause()
          } else if let queueIndex = manager.songQueue.firstIndex(where: { $0.id == playlistId }) {
              manager.playSongs(manager.songQueue, startIndex: queueIndex)
          }
      }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  deinit {
    AudioPlayerManager.shared.removeDelegate(self)
  }
  private func updateState() {
      let manager = AudioPlayerManager.shared
      guard let playlistId = playlistId else { return }

      let playing: Bool
      if isHeader {
          // Header: any song in this playlist
          playing = manager.isPlaying && manager.songQueue.contains(where: { $0.id == playlistId || manager.currentPlaylistId == playlistId })
      } else {
          // Cell: only if this song is currentSong
          playing = manager.isPlaying && manager.currentSong?.id == playlistId
      }
      updateUI(isPlaying: playing)
  }

  public func updateUI(isPlaying: Bool) {
      self.isPlaying = isPlaying
      let imageName = isPlaying ? pauseImageName : playImageName
      self.setImage(UIImage(named: imageName), for: .normal)
  }
}
extension PlayPauseToggle: AudioPlayerDelegate {

  func didStartPlaying(song: Item) {
    updateState()
  }

  func didPause() {
    updateState()
  }

  func didResume() {
    updateState()
  }

  func didStop() {
    updateUI(isPlaying: false)
  }

  func didUpdateProgress(currentTime: Double, duration: Double) {
  }

  func reloadData(index: Int) {
    updateState()
  }

  func didUpdateShuffle(_ isEnabled: Bool) {
  }

}















//  override init(frame: CGRect) {
//    super.init(frame: frame)
//    self.setupBtnUI()
//    AudioPlayerManager.shared.addDelegate(self)
//  }
