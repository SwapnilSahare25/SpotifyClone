//
//  LibraryViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 27/11/25.
//

import UIKit

class LibraryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Appcolor
        self.title = "Library"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
      self.setupMainView()
    }
    

  private func setupMainView(){

    let imgView = UIFactory.makeImageView(imageName: "splashIcon")
    self.view.addSubview(imgView)
    imgView.addConstraints(constraintsDict: [.FixHeight:200,.FixWidth:200,.CenterX:0,.CenterY:-80],multiplyWithDevice: true)

    let signInBtn = UIFactory.makeButton(title: "Sign Out",titleColor: PrimaryTextColor,font: UIFont(name: fontNameBold, size: SubTitleFontsize) ?? .boldSystemFont(ofSize: 12),backgroundColor: BtnBGColor,cornerRadius: 25*DeviceMultiplier)
    self.view.addSubview(signInBtn)
    signInBtn.addConstraints(constraintsDict: [.Leading:15,.FixHeight:50,.Trailing:15],multiplyWithDevice: true)
    signInBtn.addConstraints(constraintsDict: [.BelowTo:25],relativeTo: imgView,multiplyWithDevice: true)
    signInBtn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)

  }
  @objc func btnClicked(_ sender: UIButton){
    UserAuthenticationService.shared.logout()
  }

 

}
