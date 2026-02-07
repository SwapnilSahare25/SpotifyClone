//
//  PlayerViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 07/02/26.
//

import UIKit

class PlayerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      self.view.backgroundColor = .red
      self.setupBackButton(action: #selector(self.dismissView))

    }
  @objc func dismissView(){
    self.dismiss(animated: true)
  }



}
