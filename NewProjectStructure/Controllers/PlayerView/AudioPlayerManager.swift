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
  func reloadData(Index: Int)

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
  var currentIndex: Int = 0


  private init() {}

  func playSongs(_ songs: [Item], startIndex: Int=0) {
      guard !songs.isEmpty else { return }

      songQueue = songs
      currentIndex = startIndex

    playCurrent()
    delegate?.reloadData(Index: currentIndex)
  }
  //  Core engine
  private func playCurrent() {

      if let observer = timeObserver {
          player?.removeTimeObserver(observer)
          timeObserver = nil
      }

      let song = songQueue[currentIndex]
    currentSong?.isCurrentlyPlaying = true
      currentSong = song


      guard let url = URL(string: song.url ?? "") else { return }

    print(url,"Songs Url Str IS")

      let playerItem = AVPlayerItem(url: url)
      player = AVPlayer(playerItem: playerItem)
      player?.play()

      isPlaying = true
      delegate?.didStartPlaying(song: song)

      if let totalSeconds = song.duration?.toSeconds() {
          setupTimeObserver(duration: totalSeconds)
      } else {
          setupTimeObserver(duration: 0)
      }

      observeSongCompletion()
  }



//  private func playCurrentFromQueue() {
//      guard currentIndex < songQueue.count else { return }
//
//      let song = songQueue[currentIndex]
//      playSong(song: song)
//
//      observeSongCompletion()
//  }


//  func playSong(song: Item){
//    if let observer = timeObserver {
//          player?.removeTimeObserver(observer)
//          timeObserver = nil
//      }
//
//    self.currentSong = song
//
//    guard let url = URL(string: song.url ?? "") else {return}
//
//    let playerItem = AVPlayerItem(url: url)
//
//    self.player = AVPlayer(playerItem: playerItem)
//    self.player?.play()
//    isPlaying = true
//    self.delegate?.didStartPlaying(song: song)
//
//
//    if let totalSeconds = song.duration?.toSeconds() {
//        setupTimeObserver(duration: totalSeconds)
//    } else {
//        setupTimeObserver(duration: 0)
//    }
//  }

  @objc private func songFinished() {
        if currentIndex < songQueue.count - 1 {
            currentIndex += 1
            playCurrent()
        } else {
            stop()
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

        let finalDuration = duration > 0
            ? duration
            : (player.currentItem?.duration.seconds ?? 0)

        timeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            guard let self = self, finalDuration > 0 else { return }
            self.delegate?.didUpdateProgress(
                currentTime: time.seconds,
                duration: finalDuration
            )
        }
    }
  private func observeSongCompletion() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(songFinished),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
    }


}
