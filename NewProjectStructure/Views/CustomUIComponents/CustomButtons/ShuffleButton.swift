//
//  ShuffleButton.swift
//  NewProjectStructure
//
//  Created by Swapnil on 12/02/26.
//

import UIKit

class ShuffleButton: UIButton {


  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupBtnUI()
    AudioPlayerManager.shared.addDelegate(self)


  }
  private func setupBtnUI(){

    self.setImage(UIImage(named: "shuffleOff"), for: .normal)

    self.addTarget(self, action: #selector(shuffleTapped), for: .touchUpInside)


  }

  deinit {
         AudioPlayerManager.shared.removeDelegate(self)
     }

  @objc private func shuffleTapped() {
         AudioPlayerManager.shared.toggleShuffle()
     }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
extension ShuffleButton: AudioPlayerDelegate {

  func didStartPlaying(song: Item) {

  }

  func didPause() {

  }

  func didResume() {

  }

  func didStop() {

  }

  func didUpdateProgress(currentTime: Double, duration: Double) {

  }

  func reloadData(index: Int) {

  }

  func didUpdateShuffle(_ isEnabled: Bool) {
    self.setImage(UIImage(named: isEnabled ? "shuffleOn" : "shuffleOff"), for: .normal)
  }
}
