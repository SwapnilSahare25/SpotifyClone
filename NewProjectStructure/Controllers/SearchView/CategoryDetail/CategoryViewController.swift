//
//  CategoryViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 18/02/26.
//

import UIKit

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {



  private var catgoryObject: CategoryObject?
  private var collectionView:UICollectionView!

  var categoryType: String = ""
  var titleStr: String = "Category"

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    self.title = titleStr
    self.navigationItem.largeTitleDisplayMode = .always
    self.setupBackButton()
    self.setupMainView()
    self.callCategoryDetailsApi()


  }




  private func setupMainView(){

    let layout = self.createCompositionalLayout()
    self.collectionView = UIFactory.makeCollectionView(layout: layout,backgroundColor: .black)
    self.collectionView.delegate = self
    self.collectionView.dataSource = self

    self.collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)

    self.view.addSubview(self.collectionView)
    self.collectionView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.Bottom:0])

  }

  private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {

    return UICollectionViewCompositionalLayout{ [weak self] index,environment -> NSCollectionLayoutSection? in

      guard let self = self else {return nil}

      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))

      let item = NSCollectionLayoutItem(layoutSize: itemSize)

      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(190))

      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
      group.interItemSpacing = .fixed(15)
      group.contentInsets = .init(top: 0, leading: CGFloat.DeviceMargin, bottom: 0, trailing: CGFloat.DeviceMargin)

      let section = NSCollectionLayoutSection(group: group)
      section.interGroupSpacing = 15


      return section


    }
  }

  private func callCategoryDetailsApi() {
    let endPoint = Endpoints.categoryDetails(categoryType: self.categoryType)

    APIManager.shared.request(endpoint: endPoint) { [weak self] (object: CategoryObject) in

      if let self = self {
        self.catgoryObject = object

        self.collectionView.reloadData()

      }else{
        print("No Data Found")
      }
    } onFailure: { error in
      print(error)
    }

  }


  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.catgoryObject?.items?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell

    guard let items = catgoryObject?.items else { return cell}

    cell.configure(obj: items[indexPath.item])

    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let items = catgoryObject?.items else { return }
    let obj = items[indexPath.item]

    if obj.type == "playlist" {
      let vc = PlayListDetailsViewController()
      vc.playListId = obj.id ?? 0
      vc.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(vc, animated: true)
    }else if obj.type == "album"{
      let vc = AlbumDetailsViewController()
      vc.albumId = obj.id ?? 0
      vc.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(vc, animated: true)
    }else{
      print("No Type Found")
    }




  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    if offsetY > 10 {
        setNavBarColor(.black)
    }
  }



}
