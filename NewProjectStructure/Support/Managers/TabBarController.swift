//
//  TabbarManager.swift
//  NewProjectStructure
//
//  Created by Swapnil on 25/11/25.
//

import Foundation
import UIKit
import AHKNavigationController
import StickyTabBarViewController

struct TabItem {
  let viewController: UIViewController
  let title: String
  let selectedImageName: String
  let unSelectedImageName: String
}

class TabBarController: UITabBarController, UITabBarControllerDelegate {


  private let miniPlayerView = MiniPlayerView()
  private var miniPlayerBottomConstraint: NSLayoutConstraint?
  private let kMiniPlayerHeight: CGFloat = 56.0*DeviceMultiplier
  private var playerBottomConstraint: NSLayoutConstraint?

  // weak var miniPlayerDelegate: MiniPlayerVisibilityDelegate?
  private let transitionManager = MiniPlayerTransitionManager()

  init(tabs:[TabItem]){
    super.init(nibName: nil, bundle: nil)
    self.delegate = self
    setupTabs(with: tabs)
    configureTabBarAppearance()

    self.setupMiniPlayerUI(true)
    self.selectedIndex = 0

    AudioPlayerManager.shared.delegate = self
  }

  private func setupMiniPlayerUI(_ isHidden: Bool = false) {

    view.insertSubview(miniPlayerView, belowSubview: tabBar)
    miniPlayerView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.FixHeight:kMiniPlayerHeight])
    playerBottomConstraint = miniPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    playerBottomConstraint?.isActive = true
    miniPlayerView.isHidden = isHidden // Hidden by default until song plays
    miniPlayerView.delegate = self

    view.layoutIfNeeded()

  }


  // MARK: - Layout & Position Logic
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updatePlayerPosition()
    if !tabBar.isHidden {
      self.tabBar.setNeedsLayout()
      tabBar.layoutIfNeeded()
    }
    //updateContentInsets()
  }

  private func updatePlayerPosition() {
    guard !miniPlayerView.isHidden else { return }

    // 1. Determine where the player *should* be bottom-aligned to.
    // Option A: If TabBar is visible and on-screen, sit on top of it.
    // Option B: If TabBar is hidden or off-screen, sit at Safe Area Bottom.

    //let tabBarHeight = tabBar.frame.height
    let tabBarY = tabBar.frame.origin.y
    let viewHeight = view.frame.height

    // Check if TabBar is effectively hidden
    // It is hidden if isHidden=true OR if it is pushed off screen (Y >= viewHeight)
    let isTabBarHidden = tabBar.isHidden || (tabBarY >= viewHeight)

    let bottomOffset: CGFloat

    if isTabBarHidden {
      // Dock to Safe Area Bottom
      // We use negative inset because constraint is to view.bottomAnchor
      bottomOffset = -view.safeAreaInsets.bottom
    } else {
      // Dock to Tab Bar Top
      // The Tab Bar Top relative to View Bottom is -(viewHeight - tabBarY)
      // Ideally, this is just -tabBarHeight, but during animation tabBarY changes.
      bottomOffset = -(viewHeight - tabBarY)
    }

    // Apply smooth constraint update
    if playerBottomConstraint?.constant != bottomOffset {
      playerBottomConstraint?.constant = bottomOffset

      // If we are in an animation block, this will animate automatically.
      // If not, it snaps (which is fine for layout passes).
    }

    view.bringSubviewToFront(miniPlayerView)
  }

  private func setupTabs(with items: [TabItem]) {

    var controllers: [UIViewController] = []

    for (index, item) in items.enumerated() {

      let selectedImage = UIImage(named: item.selectedImageName)?
        .withRenderingMode(.alwaysOriginal)

      let unSelectedImage = UIImage(named: item.unSelectedImageName)?
        .withTintColor(.gray, renderingMode: .alwaysOriginal)

      let nav = AHKNavigationController(rootViewController: item.viewController)

      nav.tabBarItem = UITabBarItem(title: item.title,image: unSelectedImage,selectedImage: selectedImage)

      nav.tabBarItem.tag = index
      controllers.append(nav)
    }

    self.viewControllers = controllers
  }


  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  private func configureTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = Appcolor // Global App Color

    let normalAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.gray,
      .font: UIFont.systemFont(ofSize: 10, weight: .medium)
    ]

    let selectedAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: WhiteBgColor, // Global White Color
      .font: UIFont.systemFont(ofSize: 10, weight: .bold)
    ]

    appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes

    tabBar.standardAppearance = appearance
    if #available(iOS 15.0, *) {
      tabBar.scrollEdgeAppearance = appearance
    }

    // Fix for iOS 15+ tab bar hidden/shown bug
    tabBar.itemWidth = tabBar.frame.width / CGFloat(tabBar.items?.count ?? 1)
    tabBar.itemPositioning = .centered
    tabBar.tintColor = WhiteBgColor
    tabBar.unselectedItemTintColor = .gray
    tabBar.clipsToBounds = true

  }

  func tabBarController(_ tabBarController: UITabBarController,didSelect viewController: UIViewController) {
    print("Selected tab: \(viewController.title ?? "")")
  }

}

extension TabBarController: AudioPlayerDelegate {
  func reloadData(Index: Int) {
    
  }
  


  func didStartPlaying(song: Item) {
    miniPlayerView.configure(title: song.title ?? "", subtitle: song.artist ?? "", imageURL: song.image)
    miniPlayerView.setPlaying(true)

    AudioPlayerManager.shared.isMiniPlayerVisible = true

    if miniPlayerView.isHidden {
      miniPlayerView.alpha = 0
      miniPlayerView.isHidden = false

      // Update Position Immediately before animating alpha
      self.view.setNeedsLayout()
      self.view.layoutIfNeeded()
      // 2. Notify Observers (Optional)
      //NotificationCenter.default.post(name: NSNotification.Name("MiniPlayerStateChanged"), object: nil)

      UIView.animate(withDuration: 0.3) {
        self.miniPlayerView.alpha = 1
        //self.updateContentInsets()
      }
    }
  }


  func didPause() {
    miniPlayerView.setPlaying(false)
  }

  func didResume() {
    miniPlayerView.setPlaying(true)
  }

  func didStop() {
    AudioPlayerManager.shared.isMiniPlayerVisible = false
    //NotificationCenter.default.post(name: NSNotification.Name("MiniPlayerStateChanged"), object: nil)
    UIView.animate(withDuration: 0.3, animations: {
      self.miniPlayerView.alpha = 0
    }) { _ in
      self.miniPlayerView.isHidden = true
      self.miniPlayerView.alpha = 1
      //self.updateContentInsets()
    }
  }

  func didUpdateProgress(currentTime: Double, duration: Double) {
    let progress = Float(currentTime / duration)
    miniPlayerView.setProgress(progress)
  }
}
// MARK: - Mini Player Interaction
extension TabBarController: MiniPlayerDelegate {


  func didTapMiniPlayer() {

    let playerVC = UINavigationController(rootViewController: PlayerViewController())

          // 1. Calculate the frame of the Mini Player in the Window's coordinate system
          if let window = view.window {
              let frame = miniPlayerView.convert(miniPlayerView.bounds, to: window)
              transitionManager.originFrame = frame
          } else {
              transitionManager.originFrame = miniPlayerView.frame
          }

          // 2. Set the transition delegate
          playerVC.transitioningDelegate = transitionManager

          // 3. Use .custom for custom transitions -> keeps presenting view (TabBar) visible behind
          playerVC.modalPresentationStyle = .custom

          self.present(playerVC, animated: true)

  }

  func didTapPlayPause() {
    AudioPlayerManager.shared.togglePlayPause()
  }

  func didSwipeToClose() {
    AudioPlayerManager.shared.stop()
  }
}
