//
//  ActiveSearchViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/12/25.
//

import UIKit

class ActiveSearchViewController: UIViewController {


  
  override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = .black

         title = "Active Search"

         navigationItem.leftBarButtonItem = UIBarButtonItem(
             title: "Back",
             style: .plain,
             target: self,
             action: #selector(close)
         )
     }

     @objc private func close() {
         dismiss(animated: true)
     }


}
