//
//  SplashViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 25/11/25.
//

import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Appcolor
        let imgView = UIFactory.makeImageView(imageName: "splashIcon")
        self.view.addSubview(imgView)
        imgView.addConstraints(constraintsDict: [.FixHeight:200,.FixWidth:200,.CenterX:0,.CenterY:0],multiplyWithDevice: true)
        self.goToMainAfterDelay()
        
    }
    
    private func goToMainAfterDelay() {

      if !IsIntroHasSeen {
        let introVc = UINavigationController(rootViewController: IntroViewController())
        WindowManager.shared.setRootController(introVc)
        return
      }

      if !isUserLoggedIn {
        let loginVc = LoginViewController()
        WindowManager.shared.setRootController(loginVc, animated: true)
        return
      }
      UserAuthenticationService.shared.getValidAccessToken { token in

        DispatchQueue.main.async {
          if let token = token {
            sceneDelegate.goToMainApp()

          } else {

            isUserLoggedIn = false
            let loginVc = LoginViewController()
            WindowManager.shared.setRootController(loginVc, animated: true)
          }
        }
      }

//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            if IsIntroHasSeen {
//              if isUserLoggedIn{
//                let homeVc = HomeViewController()
//                let searchVc = SearchViewController()
//                let libraryVc = LibraryViewController()
//
//                sceneDelegate.goToMainApp(vcs: [homeVc,searchVc,libraryVc], titles: ["Home","Search","Library"], images: ["house", "magnifyingglass", "music.note.list"])
//              }else{
//                let loginVc = LoginViewController()
//                WindowManager.shared.setRootController(loginVc, animated: true)
//              }
//            }else{
//                let introVc = UINavigationController(rootViewController: IntroViewController())
//                WindowManager.shared.setRootController(introVc)
//            }
//        }
        
    }
    
}
