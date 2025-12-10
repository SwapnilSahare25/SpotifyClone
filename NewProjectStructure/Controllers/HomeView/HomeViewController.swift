//
//  ViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 25/11/25.
//

import UIKit

class HomeViewController: UIViewController {

    var btn = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Appcolor
        self.title = "Home"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        setupButton()
        
        
    }
    private func setupButton() {
            // Set title
            btn.setTitle("Click Me", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            
            view.addSubview(btn)
            btn.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                btn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                btn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                btn.heightAnchor.constraint(equalToConstant: 50),
                btn.widthAnchor.constraint(equalToConstant: 200)
            ])
        }
    
    @objc private func buttonTapped() {
        
//        let vc = NextViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
      }

}

