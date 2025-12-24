//
//  ViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 25/11/25.
//

import UIKit

class HomeViewController: UIViewController {


  var collectionView:UICollectionView!

  var homeSectionArray:[HomeSectionsArray] = []


  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = Appcolor
    navigationController?.setNavigationBarHidden(true, animated: false)
    edgesForExtendedLayout = [.top]
    extendedLayoutIncludesOpaqueBars = true
    self.setUpMainView()
    self.callHomeApi()





  }

  func generateHomeSectionArray(object:HomeObject){
    var sectionArray: [HomeSectionsArray] = []

    var section1 = HomeSectionsArray()
    section1.isRequiredHeader = false
    section1.headerHeight = 30

    if let gridObj = object.gridItems,gridObj.count > 0{
      section1.homeSectionType = .quickAccess(gridObj)

      sectionArray.append(section1)
    }

    var section2 = HomeSectionsArray()
    if let newReleaseObj = object.newRelease{

      section2.isRequiredIconAndSubtitle = true
      section2.sectionHeaderIcon = newReleaseObj.content?.image ?? ""
      section2.sectionHeaderTitleStr = newReleaseObj.artist?.name ?? ""
      section2.sectionHeaderSubtitle = "NEW RELEASE FROM"
      section2.isRequiredHeader = true
      section2.headerHeight = 100
      section2.homeSectionType = .newRelease(newReleaseObj)

      sectionArray.append(section2)
    }

    if let shelves = object.sections {
      for shelf in shelves {

        var section = HomeSectionsArray()
        section.sectionHeaderTitleStr = shelf.title ?? ""
        section.isRequiredIconAndSubtitle = false
        section.sectionHeaderTitleStr = ""
        section.isRequiredHeader = true
        section.headerHeight = 50
        switch shelf.type {
        case "horizontal_scroll":
          section.homeSectionType = .horizontalShelf(shelf)

        case "horizontal_scroll_circle":
          section.homeSectionType = .circularArtistShelf(shelf)

        default:
          continue
        }

        sectionArray.append(section)
      }
    }


    self.homeSectionArray = sectionArray



  }


  func setUpMainView(){
    let layout = self.createCompositionalLayout()
    layout.register(CustomGradientDecorationCollectionReusableView.self, forDecorationViewOfKind: CustomGradientDecorationCollectionReusableView.identifier)
    self.collectionView = UIFactory.makeCollectionView(layout: layout,backgroundColor: Appcolor)
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    self.collectionView.contentInsetAdjustmentBehavior = .never

    self.collectionView.register(HomeGreetingCollectionViewCell.self, forCellWithReuseIdentifier: HomeGreetingCollectionViewCell.identifier)
    self.collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
    self.collectionView.register(HomeSectionShelfCollectionViewCell.self, forCellWithReuseIdentifier: HomeSectionShelfCollectionViewCell.identifier)
    self.collectionView.register(ArtistCollectionViewCell.self, forCellWithReuseIdentifier: ArtistCollectionViewCell.identifier)

    self.collectionView.register(GreetingHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GreetingHeaderCollectionReusableView.identifier)
    self.collectionView.register(NewReleaseCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NewReleaseCollectionReusableView.identifier)
    self.collectionView.register(ShelfCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ShelfCollectionReusableView.identifier)
    self.collectionView.register(EmptyHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyHeaderCollectionReusableView.identifier)


    self.view.addSubview(self.collectionView)
    self.collectionView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Bottom:0,.Top:0])


  }


  func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout {[weak self] sectionIndex, environment -> NSCollectionLayoutSection? in
      guard let self = self else {return nil}
      guard sectionIndex < self.homeSectionArray.count else { return nil }
      let sectionData = self.homeSectionArray[sectionIndex]

      switch sectionData.homeSectionType {
      case .quickAccess(_):
        return self.createQuickAccessSection()
      case .newRelease(_):
        return self.createQuickAccessSection()
      case .horizontalShelf(_):
        return self.createQuickAccessSection()
      case .circularArtistShelf(_):
        return self.createQuickAccessSection()
      case .none:
        return nil
      }
    }
  }




  func callHomeApi() {
    let endPoint = Endpoints.home()

    APIManager.shared.request(endpoint: endPoint) { [weak self] (object: HomeObject) in

      if let self = self {

        self.generateHomeSectionArray(object: object)
        print(homeSectionArray.count,"ArrayCount is")
        self.collectionView.reloadData()

      }else{
        print("No Data Found")
      }
    } onFailure: { error in
      print(error)
    }

  }


  func setNavbarRightBtn() {
    let profileImage = UIImage(named: "Setting")?.withRenderingMode(.alwaysTemplate)
    let profile = UIBarButtonItem(image:profileImage, style: .plain, target: self, action: #selector(buttonTapped))
    profile.tintColor = .white
    navigationItem.rightBarButtonItems = [profile]
  }


  @objc private func buttonTapped() {

    let vc = ProfileViewController()
    vc.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(vc, animated: true)
  }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.homeSectionArray.count

  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let sectionData = homeSectionArray[section]
    switch sectionData.homeSectionType {
    case .quickAccess(let items):
      return items.count
    case .newRelease(_):
      return 1
    case .horizontalShelf(let sectionObj):
      return sectionObj.items?.count ?? 0
    case .circularArtistShelf(let sectionObj):
      return sectionObj.items?.count ?? 0
    default:
      return 0
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let sectionData = homeSectionArray[indexPath.section]

    switch sectionData.homeSectionType {
    case .quickAccess(let items):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeGreetingCollectionViewCell.identifier, for: indexPath) as! HomeGreetingCollectionViewCell
      cell.configure(obj: items[indexPath.item])
      return cell

    case .newRelease(let newRelease):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCollectionViewCell.identifier, for: indexPath) as! NewReleaseCollectionViewCell
      // Configure cell with newRelease
      return cell

    case .horizontalShelf(let sectionObj):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeSectionShelfCollectionViewCell.identifier, for: indexPath) as! HomeSectionShelfCollectionViewCell
      // Configure with sectionObj.items?[indexPath.item]
      return cell

    case .circularArtistShelf(let sectionObj):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCollectionViewCell.identifier, for: indexPath) as! ArtistCollectionViewCell
      // Configure with sectionObj.items?[indexPath.item]
      return cell

    default:
      return UICollectionViewCell()
    }
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let sectionData = homeSectionArray[indexPath.section]

    switch sectionData.homeSectionType {

    case .quickAccess(let items):
      let sectionHeader1 = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GreetingHeaderCollectionReusableView.identifier, for: indexPath) as! GreetingHeaderCollectionReusableView

      return sectionHeader1

    default:

      let emptyHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmptyHeaderCollectionReusableView.identifier, for: indexPath) as! EmptyHeaderCollectionReusableView

      return emptyHeader
    }
  }


}
extension HomeViewController {

  func createQuickAccessSection() -> NSCollectionLayoutSection {
    // 1. Define the Item: Half the width of the group
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),heightDimension: .absolute(55))

    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 0,leading: 4,bottom: 0,trailing: 4)

    // 2. Define the Group: Full width, fixed height (e.g., 60-80 pts)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(63))

    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,subitem: item,count: 2)
    // Apply horizontal margin to GROUP (not section)
    group.contentInsets = NSDirectionalEdgeInsets(top: 0,leading: deviceMargin,bottom: 0,trailing: deviceMargin)


    let section = NSCollectionLayoutSection(group: group)

    // --- ADD THIS LINE FOR THE SCROLLING GRADIENT ---
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: CustomGradientDecorationCollectionReusableView.identifier)
        section.decorationItems = [backgroundDecoration]

    // Assign Header
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(100))

    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,elementKind: UICollectionView.elementKindSectionHeader,alignment: .top)

    section.boundarySupplementaryItems = [header]

    section.contentInsets = NSDirectionalEdgeInsets(top: 8,leading: 0,bottom: 0,trailing: 0)

    return section
  }


  //
  //  func createNewReleaseSection() -> NSCollectionLayoutSection {
  //
  //    let section = NSCollectionLayoutSection(group: group)
  //    return section
  //  }
  //
  //  func createHorizontalShelfSection() -> NSCollectionLayoutSection {
  //    let section = NSCollectionLayoutSection(group: group)
  //
  //    return section
  //  }
  //
  //  func createCircularArtistShelfSection() -> NSCollectionLayoutSection {
  //    let section = NSCollectionLayoutSection(group: group)
  //
  //    return section
  //  }

}
