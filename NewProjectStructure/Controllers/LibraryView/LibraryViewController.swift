//
//  LibraryViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 27/11/25.
//

import UIKit

class LibraryViewController: UIViewController {

  private var headerView: UIView!
  private var libraryArray:[(title:String,tag:Int)] = [(title:"All",tag:0),(title:"Playlists",tag:1),(title:"Artists",tag:2),(title:"Albums",tag:3),(title:"Podcasts",tag:4)]

  private var tableView:UITableView!
  private var itemArray:[Item] = []

  private var tabViews: [UIView] = []
  var type = "All"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Appcolor
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        self.setupMainView()
      self.callLibraryApi()
    }
    

  private func setupMainView(){

    self.headerView = UIFactory.makeContinerView(backgroundColor: Appcolor)
    self.view.addSubview(self.headerView)
    self.headerView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.FixHeight:topBarHeight+65])

    let imgView = UIFactory.makeImageView(imageName: "profileIcon")
    self.headerView.addSubview(imgView)
    imgView.addConstraints(constraintsDict: [.FixHeight:30,.FixWidth:30,.Top:statusBarHeight+10,.Leading:deviceMargin])

    let titleLbl = UIFactory.makeLabel(text:"Your Library",textColor: WhiteTextColor,font: UIFont(name: fontNameBold, size: (SubTitleFontsize).scaled) ?? .boldSystemFont(ofSize: SubTitleFontsize),alignment: .left)
     self.headerView.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Trailing:80,.FixHeight:30,.Top:statusBarHeight+10])
    titleLbl.rightTo(view: imgView, constant: 10)
    titleLbl.backgroundColor = .clear

    let plusBtn = UIFactory.makeButton(backgroundColor: .clear, image: "plus")
    self.headerView.addSubview(plusBtn)
    plusBtn.addConstraints(constraintsDict: [.Trailing:deviceMargin,.FixHeight:20,.FixWidth:20,.Top:statusBarHeight+20])
    plusBtn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)

    let scrollView = UIFactory.makeScrollView(showsHorizontalScrollIndicator: false)
    scrollView.backgroundColor = .clear
    self.headerView.addSubview(scrollView)
    scrollView.belowTo(view: imgView, constant: 15)
    scrollView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.FixHeight:40])

    var xAxis: CGFloat = 15*DeviceMultiplier

    for object in libraryArray{

      let size = UIFactory.getTextWidth(text: object.title,font: UIFont(name: fontNameRegular, size: DetailTabFontSize) ?? .boldSystemFont(ofSize: 12),constrainedSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30))

      let buttonWidth = object.tag == 0 ? (size + 40*DeviceMultiplier) : (size + 20*DeviceMultiplier)

      let mainContainer =  UIFactory.makeContinerView(backgroundColor: Appcolor,cornerRadius: 15*DeviceMultiplier, borderWidth: 1*DeviceMultiplier,borderColor: WhiteBgColor,frame: CGRect(x: xAxis, y: 5*DeviceMultiplier, width: buttonWidth, height: 30*DeviceMultiplier))
        scrollView.addSubview(mainContainer)
      mainContainer.isUserInteractionEnabled = true
      mainContainer.tag = object.tag
      mainContainer.addTarget(self, action: #selector(self.containerClicked))

        let titleLbl = UIFactory.makeLabel(text: object.title,textColor: WhiteTextColor,font: UIFont(name: fontNameRegular, size: DetailTabFontSize) ?? .boldSystemFont(ofSize: 12),alignment: .center)
        titleLbl.textAlignment = .center

        mainContainer.addSubview(titleLbl)
        titleLbl.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.Bottom:0])

      tabViews.append(mainContainer)

        xAxis += buttonWidth + (15*DeviceMultiplier)
    }

    scrollView.contentSize.width = xAxis


    let dividerLine = UIFactory.makeContinerView(backgroundColor: DisableColor)
    self.headerView.addSubview(dividerLine)
    dividerLine.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Bottom:0,.FixHeight:5])

    self.tableView = UIFactory.makeTableView(separatorStyle: .none)
    self.view.addSubview(self.tableView)
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.register(LibraryTableViewCell.self, forCellReuseIdentifier: LibraryTableViewCell.identifier)
    self.tableView.belowTo(view: self.headerView, constant: 0)
    self.tableView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Bottom:0])

    self.selectTab(index: 0)
  }

  private func selectTab(index: Int) {

    for (i, view) in tabViews.enumerated() {
      UIView.animate(withDuration: 0.25) {
        if i == index {
          view.backgroundColor = BtnBGColor
          view.layer.borderColor = BtnBGColor.cgColor
        } else {
          view.backgroundColor = Appcolor
          view.layer.borderColor = WhiteBgColor.cgColor
        }
      }
    }


  }


  @objc func containerClicked(_ sender: UITapGestureRecognizer){

    guard let index = sender.view?.tag else { return }
    let obj = self.libraryArray[index]
    self.type = obj.title
    self.selectTab(index: index)
    self.callLibraryApi()

  }

  @objc func btnClicked(_ sender: UIButton){
   //UserAuthenticationService.shared.logout()
  }

  private func callLibraryApi() {
    let endPoint = Endpoints.library(type: self.type)

     APIManager.shared.request(endpoint: endPoint) { [weak self] (object: LibraryObject) in

       if let self = self {
         if let items = object.items {
           self.itemArray = items
         }

         self.tableView.reloadData()

       }else{
         print("No Data Found")
       }
     } onFailure: { error in
       print(error)
     }

   }


}
extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.itemArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: LibraryTableViewCell.identifier, for: indexPath) as! LibraryTableViewCell
    cell.configure(obj: self.itemArray[indexPath.row])
    cell.dividerLine.isHidden = indexPath.row == self.itemArray.count-1
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 55*DeviceMultiplier
  }

}
