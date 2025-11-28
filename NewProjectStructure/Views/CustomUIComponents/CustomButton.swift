//
//  CustomButton.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/11/25.
//

import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .black
    }
    
    // Update title
    func set(_ title: String) {
        self.setTitle(title, for: .normal)
    }
}
//let loginButton = CustomButton()
//loginButton.set("Login")
