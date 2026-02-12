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
  func didUpdateShuffle(_ isEnabled: Bool)

}
extension AudioPlayerManager {
  func reloadData(){}
}

class AudioPlayerManager {

  static let shared = AudioPlayerManager()
  var player: AVPlayer?
  var isPlaying:Bool =  false
  var currentSong: Item?
  // weak var delegate: AudioPlayerDelegate?

  private var timeObserver: Any?

  var isMiniPlayerVisible: Bool = false

  var songQueue: [Item] = []
  private var originalQueue: [Item] = []
  var currentIndex: Int?
  var isShuffleEnabled: Bool = false

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
      if let delegate = delegate as? AudioPlayerDelegate {
        action(delegate)
      }
    }
  }


  func playSongs(_ songs: [Item], startIndex: Int=0) {
    guard !songs.isEmpty else { return }

    // If new playlist, set queues once
    if originalQueue.isEmpty {
      originalQueue = songs
      songQueue = songs
    }

    if isShuffleEnabled {
      playSelectedSongInShuffledQueue(songs: songs, index: startIndex)
    } else {
      originalQueue = songs
      songQueue = songs
      currentIndex = startIndex
    }

    notify { $0.reloadData(index: currentIndex ?? 0) }
    playCurrent()

  }
  // MARK: - Shuffle Handling
  private func playSelectedSongInShuffledQueue(songs: [Item], index: Int) {

    let selectedSong = songs[index]

    // Shuffle only once if not already shuffled
    if songQueue.count != songs.count {
      songQueue = songs.shuffled()
    }

    // Find selected song inside shuffled queue
    if let newIndex = songQueue.firstIndex(where: { $0.id == selectedSong.id }) {
      currentIndex = newIndex
    } else {
      currentIndex = 0
    }
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

    isPlaying = true

    // Notify delegates immediately about new song
    notify { $0.didStartPlaying(song: song) }

    if let totalSeconds = song.duration?.toSeconds() {
      setupTimeObserver(duration: totalSeconds)
    } else {
      setupTimeObserver(duration: 0)
    }

    observeSongCompletion()
  }


  @objc private func songFinished() {
    // If only one song → stop
        if songQueue.count <= 1 {
            stop()
            return
        }
        // If not last song → move forward
    if currentIndex ?? 0 < songQueue.count - 1 {
          currentIndex! += 1
        } else {
            // If last song → go back to first (loop)
            currentIndex = 0
        }

    notify { $0.reloadData(index: currentIndex ?? 0) }
        playCurrent()

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

  func toggleShuffle() {
    guard currentSong != nil else { return }

    isShuffleEnabled.toggle()

    if isShuffleEnabled {
      songQueue = originalQueue.shuffled()
    } else {
      songQueue = originalQueue
    }
    if let currentSong = currentSong,
       let newIndex = songQueue.firstIndex(where: { $0.id == currentSong.id }) {
      currentIndex = newIndex
    }

    notify { $0.didUpdateShuffle(isShuffleEnabled) }
    notify { $0.reloadData(index: currentIndex ?? 0) }
  }

  func stop() {
    player?.pause()
    player = nil
    currentSong = nil
    isPlaying = false
    isMiniPlayerVisible = false
    self.songQueue.removeAll()
    self.originalQueue.removeAll()
    isShuffleEnabled = false
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
