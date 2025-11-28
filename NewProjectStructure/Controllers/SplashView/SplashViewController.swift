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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if IsIntroHasSeen {
              if isUserLoggedIn{
                let homeVc = HomeViewController()
                let searchVc = SearchViewController()
                let libraryVc = LibraryViewController()

                sceneDelegate.goToMainApp(vcs: [homeVc,searchVc,libraryVc], titles: ["Home","Search","Library"], images: ["house", "magnifyingglass", "music.note.list"])
              }else{
                let loginVc = LoginViewController()
                WindowManager.shared.setRootController(loginVc, animated: true)
              }
            }else{
                let introVc = UINavigationController(rootViewController: IntroViewController())
                WindowManager.shared.setRootController(introVc)
            }
        }
        
    }
    
}
