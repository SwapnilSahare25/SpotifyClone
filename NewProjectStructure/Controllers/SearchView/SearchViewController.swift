//
//  SearchViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 27/11/25.
//

import UIKit
//import MaterialComponents

class SearchViewController: UIViewController, UISearchBarDelegate {


  private var searchSectionArray: [SearchLayoutObject] = []
  private var collectionView:UICollectionView!

 // private var appBar: MDCAppBar!
  private var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Appcolor
      title = "Search"
      self.navigationController?.navigationBar.prefersLargeTitles = true
      self.navigationItem.largeTitleDisplayMode = .always
      self.setupSearchBar()
        self.setupMainView()
          self.callSearchApi()

    }

  private func setupSearchBar() {
          searchController = UISearchController(searchResultsController: nil)
          searchController.obscuresBackgroundDuringPresentation = false
          searchController.hidesNavigationBarDuringPresentation = false
          searchController.searchBar.placeholder = "Artists, songs, or podcasts"
          searchController.searchBar.searchBarStyle = .minimal

          searchController.searchBar.delegate = self

          navigationItem.searchController = searchController
          navigationItem.hidesSearchBarWhenScrolling = false
      }


  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
          openActiveSearch()
          return false
      }
  @objc private func openActiveSearch() {
          let activeVC = ActiveSearchViewController()
          let nav = UINavigationController(rootViewController: activeVC)
          nav.modalPresentationStyle = .fullScreen
          self.present(nav, animated: false)
      }


  override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()

    self.collectionView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 15,right: 0)

    self.collectionView.scrollIndicatorInsets = collectionView.contentInset
  }



  private func setupMainView(){

    let layout = self.createCompositionalLayout()
    self.collectionView = UIFactory.makeCollectionView(layout: layout,backgroundColor: .black)
    self.collectionView.delegate = self
    self.collectionView.dataSource = self

    self.collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)

    self.collectionView.register(SearchHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchHeaderCollectionReusableView.identifier)

    self.collectionView.register(EmptyHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyHeaderCollectionReusableView.identifier)

    self.view.addSubview(self.collectionView)
    self.collectionView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.Bottom:0])

  }


  private func generateSearchArray(obj:SearchObject) {

    var sectionArray: [SearchLayoutObject] = []

    if let sections = obj.sections{

      for item in sections{

        var section = SearchLayoutObject()
        switch item.type {
        case "grid_2x2":
          section.searcType = .topGenres(item)
        case "grid_dynamic":
          section.searcType = .browseAll(item)
        default:
          continue
        }

        sectionArray.append(section)
      }
      self.searchSectionArray = sectionArray
    }

  }

  


  private func callSearchApi() {
    let endPoint = Endpoints.search()

    APIManager.shared.request(endpoint: endPoint) { [weak self] (object: SearchObject) in

      if let self = self {

        self.generateSearchArray(obj: object)

        self.collectionView.reloadData()

      }else{
        print("No Data Found")
      }
    } onFailure: { error in
      print(error)
    }
  }

  private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {

    return UICollectionViewCompositionalLayout{ [weak self] index,environment -> NSCollectionLayoutSection? in

      guard let self = self else {return nil}

      let section = self.searchSectionArray[index]

      switch section.searcType {
      case .topGenres(_):
        return self.createCommonSection()
      case .browseAll(_):
        return self.createCommonSection()
      case .none:
        return nil
      }

    }
  }


//  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//
//    self.handleSearchBarTap()
//      return false
//  }

}

extension SearchViewController {

  private func createCommonSection() -> NSCollectionLayoutSection{

    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))

    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))

    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
    group.interItemSpacing = .fixed(10)
    group.contentInsets = .init(top: 0, leading: deviceMargin, bottom: 0, trailing: deviceMargin)

    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 10

    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))

    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,elementKind: UICollectionView.elementKindSectionHeader,alignment: .top)


    section.boundarySupplementaryItems = [header]


    return section
  }

}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.searchSectionArray.count
  }


  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    switch self.searchSectionArray[section].searcType {
    case .browseAll(let items),.topGenres(let items):
      return items.items?.count ?? 0
    case .none:
      return 0
    }

  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let sections = self.searchSectionArray[indexPath.section]
    switch sections.searcType {
    case .browseAll(let section), .topGenres(let section):
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
      if let items = section.items{
        cell.configure(obj: items[indexPath.item])
      }


      return cell
    default:
      return UICollectionViewCell()

    }


  }
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let section = searchSectionArray[indexPath.section]

    switch section.searcType {

    case .topGenres(let section), .browseAll(let section):
      let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchHeaderCollectionReusableView.identifier, for: indexPath) as! SearchHeaderCollectionReusableView

      sectionHeader.configure(obj: section)


      return sectionHeader

  
    default:
      let emptyHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmptyHeaderCollectionReusableView.identifier, for: indexPath) as! EmptyHeaderCollectionReusableView

      return emptyHeader
    }
  }



}

