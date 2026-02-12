//
//  LikedSongsViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 29/01/26.
//

import UIKit
import SwipeCellKit

class LikedSongsViewController: UIViewController, AudioPlayerDelegate {
  func didStartPlaying(song: Item) {
    //indexpath = AudioPlayerManager.shared.currentIndex
    self.currentTime = 0
        tableView.reloadData()
       // updateTableViewInset()
  }
  
  func didPause() {
    tableView.reloadData()
//    if let index = indexpath {
//               tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
//           }
  }
  
  func didResume() {
    tableView.reloadData()
//    if let index = indexpath {
//               tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
//           }
  }
  
  func didStop() {
    tableView.reloadData()
//    let previous = indexpath
//        indexpath = nil
//
//           if let previous = previous {
//               tableView.reloadRows(at: [IndexPath(row: previous, section: 0)], with: .none)
//           }
    //updateTableViewInset()
  }
  
  func didUpdateProgress(currentTime: Double, duration: Double) {
    self.currentTime = currentTime
    tableView.reloadData()
  }
  
  func reloadData(index: Int) {
    tableView.reloadData()

//    let previousIndex = indexpath
//    indexpath = index
//
//    var rowsToReload: [IndexPath] = []
//
//    if let previous = previousIndex {
//        rowsToReload.append(IndexPath(row: previous, section: 0))
//    }
//
//    rowsToReload.append(IndexPath(row: index, section: 0))
//
//    tableView.reloadRows(at: rowsToReload, with: .none)
  }




  private var tableView: UITableView!


  let topPurple = UIColor(red: 105/255, green: 56/255, blue: 179/255, alpha: 1)
  let midBlue = UIColor(red: 83/255, green: 129/255, blue: 196/255, alpha: 1)

  var songsObj: Tracks?
  var currentTime: Double = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .black
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.backgroundColor = .clear
    self.setupBackButton()
    self.setUpMainView()
    self.setupHeader()
    self.callLikedSongsApi()


  }

  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
    self.tableView.contentInsetAdjustmentBehavior = .never
    AudioPlayerManager.shared.addDelegate(self)
    updateTableViewInset()
    tableView.reloadData()
  }

  private func updateTableViewInset() {
    if AudioPlayerManager.shared.isMiniPlayerVisible {
               let playerHeight: CGFloat = 56.0*DeviceMultiplier
               tableView.contentInset.bottom = playerHeight + 25*DeviceMultiplier
           } else {
               tableView.contentInset.bottom = 0
           }
  }

  override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
    AudioPlayerManager.shared.removeDelegate(self)
  }


  private func setUpMainView(){

    self.tableView = UIFactory.makeTableView(separatorStyle: .none)
    self.view.addSubview(self.tableView)
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.backgroundColor = .clear
    //self.tableView.contentInsetAdjustmentBehavior = .never
    self.tableView.register(LikedSongsTableViewCell.self, forCellReuseIdentifier: LikedSongsTableViewCell.identifier)
    self.tableView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Bottom:0,.Top:0])


  }


  private func setupHeader() {


    let gradientView = GradientLikedSongsView(frame: CGRect(x: 0, y: 0, width: DeviceWidth, height: 390*DeviceMultiplier))
    gradientView.clipsToBounds = true
    gradientView.configure(count: self.songsObj?.total ?? 0)
    self.tableView.tableHeaderView = gradientView


  }



  private func callLikedSongsApi() {
    let endPoint = Endpoints.getLikedSongs()

     APIManager.shared.request(endpoint: endPoint) { [weak self] (object: SongsObject) in

       if let self = self {
         if let items = object.tracks {
           self.songsObj = items
         }
         self.setupHeader()
         //self.headerView?.configure(count: self.songsObj?.total ?? 0)

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
    let triggerOffset = (tableView.tableHeaderView?.frame.height ?? 300) - 120*DeviceMultiplier

    if offsetY >= triggerOffset {
      navigationItem.title = "Liked Songs"
      self.setNavBarGradient(colors: [topPurple, midBlue])
    } else {
      navigationItem.title = ""
      setNavBarColor(.clear)
    }
  }

}
extension LikedSongsViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.songsObj?.items?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: LikedSongsTableViewCell.identifier, for: indexPath) as! LikedSongsTableViewCell
    cell.delegate = self
    if let items = self.songsObj?.items{
      let currentSong = AudioPlayerManager.shared.currentSong
      let currentSongPlaying = currentSong?.id == items[indexPath.row].id

      cell.configure(obj: items[indexPath.row],isCurrentSong: currentSongPlaying,currectTime: currentTime)

      cell.dividerLine.isHidden = indexPath.row == items.count-1
    }

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 65*DeviceMultiplier
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let items = self.songsObj?.items else { return }
    self.currentTime = 0
    AudioPlayerManager.shared.playSongs(items, startIndex: indexPath.row)
    self.updateTableViewInset()

  }

}

extension LikedSongsViewController: SwipeTableViewCellDelegate{

  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
    guard orientation == .right else { return nil }

       let deleteAction = SwipeAction(style: .destructive, title: "Remove") { action, indexPath in

         action.fulfill(with: .delete)

       }
       deleteAction.image = UIImage(named: "remove")

       return [deleteAction]
  }

//  func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> SwipeCellKit.SwipeOptions {
//    <#code#>
//  }

//  func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) {
//    <#code#>
//  }
//
//  func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?, for orientation: SwipeCellKit.SwipeActionsOrientation) {
//    <#code#>
//  }
//
//  func visibleRect(for tableView: UITableView) -> CGRect? {
//    <#code#>
//  }

}
