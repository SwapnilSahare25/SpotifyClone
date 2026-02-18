//
//  ToggleLikeButton.swift
//  NewProjectStructure
//
//  Created by Swapnil on 09/02/26.
//

import UIKit
import Alamofire


protocol LikeUpdateDelegate: AnyObject {
  func didUpdateLike()
}

class ToggleLikeButton: UIButton {


  weak var delegate: LikeUpdateDelegate?
  var itemID: Int?
  var itemType: String?
  private var isLiked: Bool = false
  private var isLoading = false

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = .clear
    self.setupBtnUI()


  }
  private func setupBtnUI(){
    // self.setImage(UIImage(named: "unlike"), for: .normal)
    self.addTarget(self, action: #selector(self.toggleLikeApiCall), for: .touchUpInside)
  }
  func configure(id: Int,type: String,isLiked: Bool) {

    self.itemID = id
    self.itemType = type
    self.isLiked = isLiked
    updateUI()
  }
  private func updateUI() {
    let imageName = self.isLiked ? "like" : "unlike"
    self.setImage(UIImage(named: imageName), for: .normal)
  }

  @objc func toggleLikeApiCall(){
    guard !isLoading else { return }
    guard let id = itemID,
          let type = itemType else { return }

    isLoading = true
    isUserInteractionEnabled = false

    callToggleLike(id: id, type: type)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func callToggleLike(id: Int,type: String) {
    let endPoint = Endpoints.toggleLike()

    let params: Parameters = [
      "user_id": userId,
      "type": type,      // "song", "album", "artist", or "playlist"
      "id": id            // ID of the item
    ]

    APIManager.shared.request(endpoint: endPoint,method: .post,parameters: params) { [weak self] (object: LikeObject) in


      guard let self = self else { return }

      self.isLoading = false
      self.isUserInteractionEnabled = true

      self.isLiked = object.isLiked ?? false
      self.updateUI()

      //Update current playing song if matches
      if AudioPlayerManager.shared.currentSong?.id == id {
          AudioPlayerManager.shared.currentSong?.isLiked = object.isLiked
      }


      self.delegate?.didUpdateLike()

    } onFailure: { error in
      self.isLoading = false
      self.isUserInteractionEnabled = true
      print(error)
    }

  }
}
