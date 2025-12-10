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
        self.view.backgroundColor = Appcolor
      self.callgetCurrentUserApi()
    }
    

  func callgetCurrentUserApi(){
    let endPoint = Endpoints.getCurrentUser()

    GetCurrentProfileService.shared.callGetCurrentUSerApi(endpoints: endPoint) { result in
      switch result {
      case .success( let user):
        print(user.displayName ?? "","NAme")
      case .failure(let error):
        print("Failed to load profile:", error)
      }
    }
  }

}
