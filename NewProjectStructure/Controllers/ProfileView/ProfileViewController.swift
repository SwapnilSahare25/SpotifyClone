//
//  ProfileViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/11/25.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      self.view.backgroundColor = .black
      self.navigationController?.setNavigationBarHidden(false, animated: false)
      self.setupBackButton()
      self.setupMainView()
     // self.callgetCurrentUserApi()
    }

  private func setupMainView(){

    let imgView = UIFactory.makeImageView(imageName: "splashIcon")
    self.view.addSubview(imgView)
    imgView.addConstraints(constraintsDict: [.FixHeight:200,.FixWidth:200,.CenterX:0,.CenterY:-80])

    let signInBtn = UIFactory.makeButton(title: "Sign Out",titleColor: PrimaryTextColor,font: UIFont(name: fontNameBold, size: SubTitleFontsize) ?? .boldSystemFont(ofSize: 12),backgroundColor: BtnBGColor,cornerRadius: 25*DeviceMultiplier)
    self.view.addSubview(signInBtn)
    signInBtn.addConstraints(constraintsDict: [.Leading:15,.FixHeight:50,.Trailing:15])
    signInBtn.addConstraints(constraintsDict: [.BelowTo:25],relativeTo: imgView)
    signInBtn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)

  }
  @objc func btnClicked(_ sender: UIButton){
    UserAuthenticationService.shared.logout()
  }


  func callgetCurrentUserApi(){
//    let endPoint = Endpoints.getCurrentUser()
//
//    GetCurrentProfileService.shared.callGetCurrentUSerApi(endpoints: endPoint) { result in
//      switch result {
//      case .success( let user):
//        print(user.displayName ?? "","NAme")
//      case .failure(let error):
//        print("Failed to load profile:", error)
//      }
//    }
  }

}
