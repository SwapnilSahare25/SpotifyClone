//
//  ArtistDetailsViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 04/02/26.
//

import UIKit

class ArtistProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AudioPlayerDelegate {
  func didStartPlaying(song: Item) {
    self.currentTime = 0
    self.collectionView.reloadData()

  }
  
  func didPause() {
    self.collectionView.reloadData()
  }
  
  func didResume() {
    self.collectionView.reloadData()
  }
  
  func didStop() {
    self.collectionView.reloadData()
    self.updateInset()
  }
  
  func didUpdateProgress(currentTime: Double, duration: Double) {
    self.currentTime = currentTime
    self.collectionView.reloadData()
  }
  
  func reloadData(index: Int) {
    self.collectionView.reloadData()
  }
  



  private var collectionView: UICollectionView!

  private var artistSectionArray:[ArtistSectionsArray] = []

  var artistId: Int = 0
  var artistName: String = ""
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
    self.callArtistProfileApi()


  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.collectionView.contentInsetAdjustmentBehavior = .never
    AudioPlayerManager.shared.addDelegate(self)
    self.updateInset()
    self.collectionView.reloadData()
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    AudioPlayerManager.shared.removeDelegate(self)
  }
  private func updateInset() {
    if AudioPlayerManager.shared.isMiniPlayerVisible {
      let playerHeight: CGFloat = 56.0*DeviceMultiplier
      collectionView.contentInset.bottom = playerHeight + 25*DeviceMultiplier
    } else {
      collectionView.contentInset.bottom = 0
    }
  }

  private func setUpMainView(){


    let layout = self.createCompositionalLayout()
    self.collectionView = UIFactory.makeCollectionView(layout: layout,backgroundColor: .black)
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    self.collectionView.contentInsetAdjustmentBehavior = .never

    self.collectionView.register(PopularTrackCollectionViewCell.self, forCellWithReuseIdentifier: PopularTrackCollectionViewCell.identifier)
    self.collectionView.register(DiscographyCollectionViewCell.self, forCellWithReuseIdentifier: DiscographyCollectionViewCell.identifier)
    self.collectionView.register(RelatedArtistCollectionViewCell.self, forCellWithReuseIdentifier: RelatedArtistCollectionViewCell.identifier)
    self.collectionView.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: HeaderCollectionViewCell.identifier)

    self.collectionView.register(ShelfCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ShelfCollectionReusableView.identifier)


    self.view.addSubview(self.collectionView)
    self.collectionView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0])
    NSLayoutConstraint.activate([
      self.collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }

  private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout {[weak self] sectionIndex, environment -> NSCollectionLayoutSection? in
      guard let self = self else {return nil}
      guard sectionIndex < self.artistSectionArray.count else { return nil }
      let sectionData = self.artistSectionArray[sectionIndex]

      switch sectionData.artistSectionType {
      case .popularTracks:
        return self.createPopularTracksSection()
      case .album:
        return self.createAlbumSection()
      case .relatedArtist:
        return self.createRelatedArtistSection()
      case .header:
        return self.createTopHeaderSection()
      case .none:
        return nil

      }
    }
  }


  private func generateArtistProfileArray(object: ArtistObject){

    var artistArray: [ArtistSectionsArray] = []

    var obj1 = ArtistSectionsArray()
    obj1.headerHeight = 0
    obj1.artistSectionType = .header(object)


    var obj2 = ArtistSectionsArray()
    obj2.headerHeight = 50*DeviceMultiplier
    obj2.sectionHeaderTitleStr = "Popular"

    if let array = object.popularTracks{
      if object.popularTracks?.count ?? 0 > 0 {
        obj2.artistSectionType = .popularTracks(array)
      }
    }


    var obj3 = ArtistSectionsArray()
    obj3.headerHeight = 50*DeviceMultiplier
    obj3.sectionHeaderTitleStr = "Discography"

    if let array = object.albums{
      if object.albums?.count ?? 0 > 0 {
        obj3.artistSectionType = .album(array)
      }
    }


    var obj4 = ArtistSectionsArray()
    obj4.headerHeight = 50*DeviceMultiplier
    obj4.sectionHeaderTitleStr = "Fans also like"

    if let array = object.relatedArtists{
      if object.relatedArtists?.count ?? 0 > 0 {
        obj4.artistSectionType = .relatedArtist(array)
      }
    }

    artistArray.append(obj1)
    artistArray.append(obj2)
    artistArray.append(obj3)
    artistArray.append(obj4)


    self.artistSectionArray = artistArray



  }

  private func callArtistProfileApi() {

    let endPoint = Endpoints.getArtistProfileDetails(artistId: self.artistId)

    APIManager.shared.request(endpoint: endPoint) { [weak self] (object: ArtistObject) in

      if let self = self {
        self.artistName = object.name ?? ""
        self.generateArtistProfileArray(object: object)

        self.collectionView.reloadData()

      }else{
        print("No Data Found")
      }
    } onFailure: { error in
      print(error)
    }

  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let triggerOffset = 200*DeviceMultiplier

    if offsetY >= triggerOffset {
      navigationItem.title = self.artistName
      self.setNavBarGradient(colors: [UIColor.black])
    } else {
      navigationItem.title = ""
      setNavBarColor(.clear)
    }
  }


  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.artistSectionArray.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let sectionData = artistSectionArray[section]
    switch sectionData.artistSectionType {
    case .header:
      return 1
    case .popularTracks(let popularTrackArray):
      return popularTrackArray.count
    case .album(let albumArray):
      return albumArray.count
    case .relatedArtist(let relatedArtist):
      return relatedArtist.count
    default:
      return 0
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let sectionData = artistSectionArray[indexPath.section]

    switch sectionData.artistSectionType {
    case .header(let obj):

      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCollectionViewCell.identifier, for: indexPath) as! HeaderCollectionViewCell
      cell.configure(obj: obj)

      return cell

    case .popularTracks(let popularTracks):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularTrackCollectionViewCell.identifier, for: indexPath) as! PopularTrackCollectionViewCell

//      cell.configure(object: popularTracks[indexPath.item], index: indexPath.item)
      let currentSong = AudioPlayerManager.shared.currentSong
      let currentSongPlaying = currentSong?.id == popularTracks[indexPath.row].id
      cell.configure(object: popularTracks[indexPath.item], index: indexPath.row,isCurrentSong: currentSongPlaying,currectTime: currentTime)

      return cell

    case .album(let album):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscographyCollectionViewCell.identifier, for: indexPath) as! DiscographyCollectionViewCell

      cell.configure(object: album[indexPath.item])

      return cell

    case .relatedArtist(let relatedArtist):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RelatedArtistCollectionViewCell.identifier, for: indexPath) as! RelatedArtistCollectionViewCell

      cell.configure(object: relatedArtist[indexPath.item])

      return cell

    default:
      return UICollectionViewCell()
    }
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

    let sectionData = artistSectionArray[indexPath.section]
    switch sectionData.artistSectionType {

    case .popularTracks(_),.album(_),.relatedArtist(_):
      let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ShelfCollectionReusableView.identifier, for: indexPath) as! ShelfCollectionReusableView
      sectionHeader.titleLbl.text = sectionData.sectionHeaderTitleStr
      sectionHeader.setBottom(5*DeviceMultiplier)
      return sectionHeader

    default:
      return UICollectionReusableView()
    }



  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let sectionData = artistSectionArray[indexPath.section]

    switch sectionData.artistSectionType {
    case .popularTracks(let popularTracks):

      AudioPlayerManager.shared.playSongs(popularTracks, startIndex: indexPath.item)
      self.updateInset()

    case .album(let album):

      let albumVC = AlbumDetailsViewController()
      albumVC.albumId = album[indexPath.item].id ?? 0
      albumVC.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(albumVC, animated: true)

    case .relatedArtist(let relatedArtist):

      let obj = relatedArtist[indexPath.row]
      let vc = ArtistProfileViewController()
      vc.artistId = obj.id ?? 0
      vc.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(vc, animated: true)

    default:
      break

    }


  }
}


extension ArtistProfileViewController {

  private func createTopHeaderSection() -> NSCollectionLayoutSection {
    // Define the Item: Half the width of the group
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalHeight(1.0))

    let item = NSCollectionLayoutItem(layoutSize: itemSize)
   // item.contentInsets = NSDirectionalEdgeInsets(top: 0,leading: 5,bottom: 0,trailing: 5)

    // Define the Group: Full width, fixed height (e.g., 60-80 pts)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(360))

    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    // Apply horizontal margin to GROUP (not section)
    //group.contentInsets = NSDirectionalEdgeInsets(top: 0,leading: deviceMargin-5,bottom: 0,trailing: deviceMargin-5)


    let section = NSCollectionLayoutSection(group: group)



    //section.contentInsets = NSDirectionalEdgeInsets(top: 8,leading: 0,bottom: 0,trailing: 0)

    return section
  }


  //
  private func createPopularTracksSection() -> NSCollectionLayoutSection {

      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
     // item.contentInsets = NSDirectionalEdgeInsets(top: 0,leading: deviceMargin-5,bottom: 0,trailing: deviceMargin-5)

      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(55))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      //group.contentInsets = NSDirectionalEdgeInsets(top: 0,leading: deviceMargin-5,bottom: 0,trailing: deviceMargin-5)

      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = NSDirectionalEdgeInsets(top: 0,leading: deviceMargin,bottom: 0,trailing: deviceMargin)

      let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))

      let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
      section.boundarySupplementaryItems = [header]



      return section
    }

  private func createAlbumSection() -> NSCollectionLayoutSection {
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: 0,leading: 0,bottom: 0,trailing: 0)

      let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(170))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      //group.interItemSpacing = .fixed(10)
      //group.contentInsets = NSDirectionalEdgeInsets(top: 0,leading: deviceMargin,bottom: 0,trailing: deviceMargin)

      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .continuous
      section.interGroupSpacing = 10
      section.contentInsets = NSDirectionalEdgeInsets(top: 0,leading: deviceMargin,bottom: 0,trailing: deviceMargin)


      let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
      let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
      section.boundarySupplementaryItems = [header]



      return section
    }

  private func createRelatedArtistSection() -> NSCollectionLayoutSection {
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: 0,leading: 0,bottom: 0,trailing: 0)

      let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(105), heightDimension: .absolute(150))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      //group.interItemSpacing = .fixed(10)
      //group.contentInsets = NSDirectionalEdgeInsets(top: 0,leading: deviceMargin,bottom: 0,trailing: deviceMargin)

      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .continuous
      section.interGroupSpacing = 10
      section.contentInsets = NSDirectionalEdgeInsets(top: 0,leading: deviceMargin,bottom: 0,trailing: deviceMargin)


      let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
      let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
      section.boundarySupplementaryItems = [header]


      return section
    }

}
