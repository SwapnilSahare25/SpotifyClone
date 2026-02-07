//
//  AudioPlayerManager.swift
//  NewProjectStructure
//
//  Created by Swapnil on 07/02/26.
//

import Foundation
import AVFoundation


protocol AudioPlayerDelegate: AnyObject {

  func didStartPlaying(song: Item)
  func didPause()
  func didResume()
  func didStop()
  func didUpdateProgress(currentTime: Double, duration: Double)

}

class AudioPlayerManager {

  static let shared = AudioPlayerManager()
  var player: AVPlayer?
  var isPlaying:Bool =  false
  var currentSong: Item?
  weak var delegate: AudioPlayerDelegate?

  private var timeObserver: Any?

  private init() {}

  func playSong(song: Item){
    if let observer = timeObserver {
          player?.removeTimeObserver(observer)
          timeObserver = nil
      }

    self.currentSong = song

    guard let url = URL(string: song.url ?? "") else {return}

    let playerItem = AVPlayerItem(url: url)

    self.player = AVPlayer(playerItem: playerItem)
    self.player?.play()
    isPlaying = true
    self.delegate?.didStartPlaying(song: song)


    if let totalSeconds = song.duration?.toSeconds() {
        setupTimeObserver(duration: totalSeconds)
    } else {
        setupTimeObserver(duration: 0)
    }
  }

  func togglePlayPause() {
    guard let player = player else { return }
    if isPlaying {
      player.pause()
      delegate?.didPause()
    } else {
      player.play()
      delegate?.didResume()
    }
    isPlaying.toggle()
  }

  func stop() {
    player?.pause()
    player = nil
    currentSong = nil
    isPlaying = false
    delegate?.didStop()
  }

  private func setupTimeObserver(duration: Double) {
      guard let player = player else { return }

      // Use the passed duration, or fallback to the player item duration once
      let finalDuration = duration > 0 ? duration : (player.currentItem?.duration.seconds ?? 0)

      timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { [weak self] time in
          guard let self = self, finalDuration > 0 else { return }

          let current = time.seconds // Cleaner than CMTimeGetSeconds(time)
          self.delegate?.didUpdateProgress(currentTime: current, duration: finalDuration)
      }
  }


}
