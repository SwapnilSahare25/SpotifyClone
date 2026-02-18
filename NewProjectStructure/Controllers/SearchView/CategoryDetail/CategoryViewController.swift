//
//  CategoryViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 18/02/26.
//

import UIKit

class CategoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = .black
      title = "Category"
      self.navigationController?.navigationBar.prefersLargeTitles = false
      self.navigationItem.largeTitleDisplayMode = .never
      self.setupBackButton()

      
    }
    


}
