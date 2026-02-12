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

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupBtnUI()
    AudioPlayerManager.shared.addDelegate(self)
  }
  private func setupBtnUI(){

    self.setImage(UIImage(named: "playSong"), for: .normal)

    self.addTarget(self, action: #selector(togglePlayPauseTapped), for: .touchUpInside)


  }

  
  @objc private func togglePlayPauseTapped() {
    let manager = AudioPlayerManager.shared
    // If queue exists → just toggle
    print(manager.songQueue.count,"Count is ")
    if !manager.songQueue.isEmpty {
        manager.togglePlayPause()
    } else {
      // First time play
      actionDelegate?.didRequestInitialPlayback()
    }
     }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  deinit {
         AudioPlayerManager.shared.removeDelegate(self)
     }
  private func updateUI(isPlaying: Bool) {
          let imageName = isPlaying ? "pauseSong" : "playSong"
          setImage(UIImage(named: imageName), for: .normal)
      }
}
extension PlayPauseToggle: AudioPlayerDelegate {

  func didStartPlaying(song: Item) {
    updateUI(isPlaying: true)
  }

  func didPause() {
    updateUI(isPlaying: false)
  }

  func didResume() {
    updateUI(isPlaying: true)
  }

  func didStop() {
    updateUI(isPlaying: false)
  }

  func didUpdateProgress(currentTime: Double, duration: Double) {
  }

  func reloadData(index: Int) {
  }

  func didUpdateShuffle(_ isEnabled: Bool) {
  }
}
