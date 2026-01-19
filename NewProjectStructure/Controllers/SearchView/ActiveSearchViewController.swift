//
//  ActiveSearchViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/12/25.
//

import UIKit

class ActiveSearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {


  private var collectionView:UICollectionView!
  private var searchController: UISearchController!
  override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = .black
         title = "Active Search"
         navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",style: .plain,target: self,action: #selector(close))
    self.setupSearchBar()
    self.setupMainView()


     }

     @objc private func close() {
         dismiss(animated: true)
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
    
          return true
      }

  private func setupMainView(){

    let layout = self.createCompositionalLayout()
    self.collectionView = UIFactory.makeCollectionView(layout: layout,backgroundColor: .black)
    self.collectionView.delegate = self
    self.collectionView.dataSource = self

    self.collectionView.register(ActiveSearchCollectionViewCell.self, forCellWithReuseIdentifier: ActiveSearchCollectionViewCell.identifier)


    self.view.addSubview(self.collectionView)
    self.collectionView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.Bottom:0])

  }

  private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {

    return UICollectionViewCompositionalLayout{ [weak self] index,environment -> NSCollectionLayoutSection? in

      guard let self = self else {return nil}

      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))

      let item = NSCollectionLayoutItem(layoutSize: itemSize)

      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))

      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
     // group.interItemSpacing = .fixed(10)
      group.contentInsets = .init(top: 0, leading: deviceMargin, bottom: 0, trailing: deviceMargin)

      let section = NSCollectionLayoutSection(group: group)
      section.interGroupSpacing = 10


      return section

    }
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActiveSearchCollectionViewCell.identifier, for: indexPath) as! ActiveSearchCollectionViewCell


    return cell

  }


}
