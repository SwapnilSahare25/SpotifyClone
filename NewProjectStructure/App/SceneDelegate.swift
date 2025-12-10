//
//  SceneDelegate.swift
//  NewProjectStructure
//
//  Created by Swapnil on 25/11/25.
//

import UIKit
import AHKNavigationController

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        for family in UIFont.familyNames.sorted() {
            print("Family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("Font: \(name)")
            }
        }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        self.window?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.window?.overrideUserInterfaceStyle = .dark
        self.window?.backgroundColor = .white
        let rootView = SplashViewController()
        
        window?.rootViewController = rootView
        window?.makeKeyAndVisible()
        
    }

    
    func goToMainApp(vcs: [UIViewController], titles: [String], images: [String]) {

        TabBarManager.shared.setupTabs(vcs: vcs, titles: titles, imageNames: images)

           guard let window = self.window else { return }

           UIView.transition(with: window,duration: 0.1,options: .transitionCrossDissolve,animations: {
               window.rootViewController = TabBarManager.shared}, completion: nil)
        
       }

  // SceneDelegate.swift

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {

      // 1. Get the URL and code (unchanged)
      guard let url = URLContexts.first?.url,
            let code = url.queryValue(for: "code") else {
          return
      }

      print("Spotify code received in SceneDelegate: \(code)")

      UserAuthenticationService.shared.exchangeCodeForToken(code: code) { result in

          DispatchQueue.main.async {
              switch result {
              case .success(let token):
                  print("Access Token received via SceneDelegate: \(token.access_token)")
                  isUserLoggedIn = true
                  let homeVc = HomeViewController()
                  let searchVc = SearchViewController()
                  let libraryVc = LibraryViewController()
                  sceneDelegate.goToMainApp(vcs: [homeVc, searchVc, libraryVc], titles: ["Home","Search","Library"], images: ["Home", "Search", "Library"])
                  UIApplication.shared.topMostViewController()?.dismiss(animated: true, completion: nil)


              case .failure(let error):
                  print("Token Exchange Error in SceneDelegate:", error.localizedDescription)
                  // Dismiss the SFSafariViewController even if login failed
                  UIApplication.shared.topMostViewController()?.dismiss(animated: true, completion: nil)
              }
          }
      }
  }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

