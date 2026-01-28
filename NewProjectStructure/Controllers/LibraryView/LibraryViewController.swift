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

  private var tabViews: [UIView] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Appcolor
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        self.setupMainView()
    }
    

  private func setupMainView(){

    self.headerView = UIFactory.makeContinerView(backgroundColor: Appcolor)
    self.view.addSubview(self.headerView)
    self.headerView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.FixHeight:topBarHeight+55])

    let imgView = UIFactory.makeImageView(imageName: "Setting")
    self.headerView.addSubview(imgView)
    imgView.addConstraints(constraintsDict: [.FixHeight:30,.FixWidth:30,.Top:statusBarHeight+10,.Leading:deviceMargin])

    let titleLbl = UIFactory.makeLabel(text:"Your Library",textColor: WhiteTextColor,font: UIFont(name: fontNameBold, size: (SubTitleFontsize).scaled) ?? .boldSystemFont(ofSize: SubTitleFontsize),alignment: .left)
     self.headerView.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Trailing:80,.FixHeight:30,.Top:statusBarHeight+10])
    titleLbl.rightTo(view: imgView, constant: 10)
    titleLbl.backgroundColor = .clear

    let plusBtn = UIFactory.makeButton(backgroundColor: .clear, image: "plus")
    self.headerView.addSubview(plusBtn)
    plusBtn.addConstraints(constraintsDict: [.Trailing:deviceMargin,.FixHeight:25,.FixWidth:25,.Top:statusBarHeight+15])
    plusBtn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)

    let scrollView = UIFactory.makeScrollView()
    scrollView.backgroundColor = .clear
    self.headerView.addSubview(scrollView)
    scrollView.belowTo(view: imgView, constant: 10)
    scrollView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.FixHeight:40])

    var xAxis: CGFloat = 10*DeviceMultiplier

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

        xAxis += buttonWidth + (10*DeviceMultiplier)
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

    self.selectTab(index: index)
  }

  @objc func btnClicked(_ sender: UIButton){
   //UserAuthenticationService.shared.logout()
  }

 

}
extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: LibraryTableViewCell.identifier, for: indexPath) as! LibraryTableViewCell

    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 55*DeviceMultiplier
  }

}
