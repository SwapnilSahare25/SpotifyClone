//
//  LibraryViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 27/11/25.
//

import UIKit
import PopupKit
import Alamofire

class LibraryViewController: UIViewController, UITextFieldDelegate {

  private var headerView: UIView!
  private var libraryArray:[(title:String,tag:Int)] = [(title:"All",tag:0),(title:"Playlists",tag:1),(title:"Artists",tag:2),(title:"Albums",tag:3),(title:"Podcasts",tag:4)]

  private var tableView:UITableView!
  private var itemArray:[Item] = []

  private var tabViews: [UIView] = []
  private var type = "All"
   var libraryNameStr = ""
  private var plusBtn: UIButton!

  private var popupView = PopupView()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .black
    self.navigationController?.setNavigationBarHidden(true, animated: false)

    self.setupMainView()
    self.callLibraryApi()
  }


  private func setupMainView(){

    self.headerView = UIFactory.makeContinerView(backgroundColor: .black)
    self.view.addSubview(self.headerView)
    self.headerView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:0,.FixHeight:topBarHeight+65])

    let imgView = UIFactory.makeImageView(imageName: "profileIcon")
    self.headerView.addSubview(imgView)
    imgView.addConstraints(constraintsDict: [.FixHeight:30,.FixWidth:30,.Top:statusBarHeight+10,.Leading:CGFloat.DeviceMargin])

    let titleLbl = UIFactory.makeLabel(text:"Your Library",textColor: WhiteTextColor,font: UIFont(name: fontNameBold, size: (SubTitleFontsize)) ?? .boldSystemFont(ofSize: SubTitleFontsize),alignment: .left)
    self.headerView.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Trailing:80,.FixHeight:30,.Top:statusBarHeight+10])
    titleLbl.addConstraints(constraintsDict: [.RightTo: 10], relativeTo: imgView)
    //titleLbl.rightTo(view: imgView, constant: 10)
    titleLbl.backgroundColor = .clear


    self.plusBtn = UIFactory.makeButton(backgroundColor: .clear, image: "plus")
    self.headerView.addSubview(plusBtn)
    plusBtn.addConstraints(constraintsDict: [.Trailing:CGFloat.DeviceMargin,.FixHeight:20,.FixWidth:20,.Top:statusBarHeight+20])
    plusBtn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)

    let scrollView = UIFactory.makeScrollView(showsHorizontalScrollIndicator: false)
    scrollView.backgroundColor = .clear
    self.headerView.addSubview(scrollView)
    // scrollView.belowTo(view: imgView, constant: 15)
    scrollView.addConstraints(constraintsDict: [.BelowTo: 15], relativeTo: imgView)
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
    self.tableView.addConstraints(constraintsDict: [.BelowTo: 0], relativeTo: self.headerView)
    // self.tableView.belowTo(view: self.headerView, constant: 0)
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
    self.plusBtn.isHidden = (obj.tag != 0 && obj.tag != 1)
    self.callLibraryApi()

  }

  @objc func btnClicked(){
    
    if !self.libraryNameStr.isEmpty {
      self.libraryNameStr = ""
    }

    let container = UIFactory.makeContinerView(backgroundColor: Appcolor,frame: CGRect(x: 0, y: 0, width: DeviceWidth, height: 250*DeviceMultiplier))
    container.roundCorners([.topLeft,.topRight], radius: 15*DeviceMultiplier)

    let crossBtn = UIFactory.makeImageView(imageName: "crossIcon",contentMode: .scaleToFill)
    container.addSubview(crossBtn)
    crossBtn.addConstraints(constraintsDict: [.FixWidth:25,.FixHeight:25,.Trailing:CGFloat.DeviceMargin,.Top:15])
    crossBtn.isUserInteractionEnabled = true
    let btnAction = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
    crossBtn.addGestureRecognizer(btnAction)

    let titleLbl = UIFactory.makeLabel(text:"Playlist name",textColor: WhiteTextColor,font: UIFont(name: fontNameMedium, size: (SubTitleFontsize)) ?? .boldSystemFont(ofSize: SubTitleFontsize),alignment: .left)
    container.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Trailing:CGFloat.DeviceMargin,.FixHeight:15,.Leading:CGFloat.DeviceMargin])
    titleLbl.addConstraints(constraintsDict: [.BelowTo: 20],relativeTo: crossBtn)
    titleLbl.backgroundColor = .clear

    let nameTf = UIFactory.makeTextField(font: UIFont(name: fontNameMedium, size: (SubTitleFontsize)) ?? .boldSystemFont(ofSize: SubTitleFontsize),textColor: WhiteTextColor)
    container.addSubview(nameTf)
    nameTf.addConstraints(constraintsDict: [.Trailing:CGFloat.DeviceMargin,.FixHeight:45,.Leading:CGFloat.DeviceMargin])
    nameTf.addConstraints(constraintsDict: [.BelowTo: 15],relativeTo: titleLbl)
    nameTf.delegate = self
    nameTf.text = self.libraryNameStr


    let cancelBtn = UIFactory.makeButton(title: "Cancel",titleColor: WhiteTextColor,font: UIFont(name: fontNameBtn, size: DetailFontsize+2) ?? .boldSystemFont(ofSize: DetailFontsize+1),backgroundColor: .clear,cornerRadius: 5*DeviceMultiplier)
    container.addSubview(cancelBtn)
    cancelBtn.addConstraints(constraintsDict: [.Leading:CGFloat.DeviceMargin,.FixWidth:160,.Bottom:30,.FixHeight:50])
    cancelBtn.addTarget(self, action: #selector(dismissPopUp), for: .touchUpInside)
    cancelBtn.layer.borderWidth = 1
    cancelBtn.layer.borderColor = WhiteBgColor.cgColor

    let doneBtn = UIFactory.makeButton(title: "Create",titleColor: PrimaryTextColor,font: UIFont(name: fontNameBtn, size: DetailFontsize+2) ?? .boldSystemFont(ofSize: DetailFontsize),backgroundColor: BtnBGColor,cornerRadius: 5*DeviceMultiplier)
    container.addSubview(doneBtn)
    doneBtn.addConstraints(constraintsDict: [.Trailing:CGFloat.DeviceMargin,.FixWidth:160,.Bottom:30,.FixHeight:50])
     doneBtn.addTarget(self, action: #selector(callCreatePlaylistApi), for: .touchUpInside)


    self.popupView = PopupView(contentView: container, showType: .slideInFromBottom, dismissType: .slideOutToBottom, maskType: .dimmed, shouldDismissOnBackgroundTouch: false, shouldDismissOnContentTouch: false)
    self.popupView.show(with: PopupView.Layout(horizontal: .center, vertical: .bottom), in: sceneDelegate.window!)

    self.addKeyboardObservers()
  }

  func addKeyboardObservers() {

      NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification,object: nil)

      NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide),name: UIResponder.keyboardWillHideNotification,object: nil)
  }

  @objc func keyboardWillShow(notification: Notification) {

      guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }

      let keyboardHeight = keyboardFrame.height

      UIView.animate(withDuration: duration,delay: 0,options: UIView.AnimationOptions(rawValue: curve << 16),animations: {

              self.popupView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
          }
      )
  }

  @objc func keyboardWillHide(notification: Notification) {

      guard let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }

      UIView.animate(withDuration: duration,delay: 0,options: UIView.AnimationOptions(rawValue: curve << 16),animations: {

              self.popupView.transform = .identity
          }
      )
  }

  @objc func dismissPopUp(){
    self.view.endEditing(true)

    NotificationCenter.default.removeObserver(self)
    self.popupView.dismiss(animated: true)
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

  @objc private func callCreatePlaylistApi() {
    self.view.endEditing(true)


    if self.libraryNameStr.isEmpty {
      print("please enter playlist name")
      return
    }

    NotificationCenter.default.removeObserver(self)
    self.popupView.dismiss(animated: true)

    let endPoint = Endpoints.createPlaylist()

    let params: Parameters = [

      "name": self.libraryNameStr

    ]
    APIManager.shared.request(endpoint: endPoint, method: .post, parameters: params) { [weak self] (object: CreatePlayList) in

      guard let self = self else { return }

      self.callLibraryApi()
       // self.tableView.reloadData()


    } onFailure: { error in
      print(error)
    }

  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    print("should return called.." )
    textField.resignFirstResponder()
    self.view.endEditing(true)
    return true
  }


  func textFieldDidEndEditing(_ textField: UITextField) {

    guard let text = textField.text else {return}
    self.libraryNameStr = text
    print("My NAme is ",self.libraryNameStr)

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
