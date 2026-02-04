//
//  ArtistDetailsViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 04/02/26.
//

import UIKit

class ArtistProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      self.view.backgroundColor = .black
      self.navigationController?.setNavigationBarHidden(false, animated: false)
      navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
      navigationController?.navigationBar.shadowImage = UIImage()
      navigationController?.navigationBar.isTranslucent = true
      navigationController?.navigationBar.backgroundColor = .clear
      self.setupBackButton()
    }
    

}
