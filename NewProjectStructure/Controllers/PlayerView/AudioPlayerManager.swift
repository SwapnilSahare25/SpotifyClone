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
  func reloadData(index: Int)

}
extension AudioPlayerManager {
  func reloadData(){}
}

class AudioPlayerManager {

  static let shared = AudioPlayerManager()
  var player: AVPlayer?
  var isPlaying:Bool =  false
  var currentSong: Item?
  weak var delegate: AudioPlayerDelegate?

  private var timeObserver: Any?

  var isMiniPlayerVisible: Bool = false

  var songQueue: [Item] = []
  var currentIndex: Int?


  // MULTIPLE DELEGATES
  private var delegates = NSHashTable<AnyObject>.weakObjects()

  private init() {}

  // MARK: - Delegate Handling

  func addDelegate(_ delegate: AudioPlayerDelegate) {
    delegates.add(delegate)
  }

  func removeDelegate(_ delegate: AudioPlayerDelegate) {
    delegates.remove(delegate)
  }

  private func notify(_ action: (AudioPlayerDelegate) -> Void) {
    for delegate in delegates.allObjects {
      action(delegate as! AudioPlayerDelegate)
    }
  }

  func playSongs(_ songs: [Item], startIndex: Int=0) {
    guard !songs.isEmpty else { return }

    songQueue = songs
    currentIndex = startIndex
    notify { $0.reloadData(index: currentIndex ?? 0) }
    playCurrent()

  }
  private func playCurrent() {

      if let observer = timeObserver {
          player?.removeTimeObserver(observer)
          timeObserver = nil
      }

    let song = songQueue[currentIndex ?? 0]
      currentSong = song

      guard let url = URL(string: song.url ?? "") else { return }

      let playerItem = AVPlayerItem(url: url)
      player = AVPlayer(playerItem: playerItem)
      player?.play()

      isPlaying = true    // ✅ set true here

      // Notify delegates immediately about new song
    notify { $0.didStartPlaying(song: song) }

    if let totalSeconds = song.duration?.toSeconds() {
          setupTimeObserver(duration: totalSeconds)
      } else {
          setupTimeObserver(duration: 0)
      }

      observeSongCompletion()
  }
//  func pause() {
//    player?.pause()
//    notify { $0.didPause() }
//  }
//
//  func resume() {
//    player?.play()
//    notify { $0.didResume() }
//  }


  @objc private func songFinished() {
    if currentIndex ?? 0 < songQueue.count - 1 {
      currentIndex! += 1
      notify { $0.reloadData(index: self.currentIndex ?? 0) }
      playCurrent()
    } else {
      stop()
    }
  }

  func togglePlayPause() {
    guard let player = player else { return }

    if isPlaying {
      player.pause()
      isPlaying = false
      notify { $0.didPause() }
    } else {
      player.play()
      isPlaying = true
      notify { $0.didResume() }
    }
  }

  func stop() {
    player?.pause()
    player = nil
    currentSong = nil
    isPlaying = false
    isMiniPlayerVisible = false

    notify { $0.didStop() }
  }

  private func setupTimeObserver(duration: Double) {
      guard let player = player else { return }

      let finalDuration = duration > 0
          ? duration
          : (player.currentItem?.duration.seconds ?? 0)

      // Remove previous observer if exists
      if let observer = timeObserver {
          player.removeTimeObserver(observer)
          timeObserver = nil
      }

      timeObserver = player.addPeriodicTimeObserver(
          forInterval: CMTime(seconds: 0.5, preferredTimescale: 600),
          queue: .main
      ) { [weak self] time in
          guard let self = self, finalDuration > 0 else { return }
          // Notify all delegates about progress
          self.notify { $0.didUpdateProgress(currentTime: time.seconds, duration: finalDuration) }
      }
  }

  private func observeSongCompletion() {
      // Remove previous notification observers to avoid duplicates
      NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)

      // Listen for end of song
      NotificationCenter.default.addObserver(
          self,
          selector: #selector(songFinished),
          name: .AVPlayerItemDidPlayToEndTime,
          object: player?.currentItem
      )
  }



}




//  private func notifyResume() {
//      for delegate in delegates.allObjects {
//          (delegate as? AudioPlayerDelegate)?.didResume()
//      }
//  }
//
//  private func notifyProgress(current: Double, duration: Double) {
//      for delegate in delegates.allObjects {
//          (delegate as? AudioPlayerDelegate)?.didUpdateProgress(currentTime: current, duration: duration)
//      }
//  }
//  private func notifyStop() {
//      for delegate in delegates.allObjects {
//          (delegate as? AudioPlayerDelegate)?.didStop()
//      }
//  }
