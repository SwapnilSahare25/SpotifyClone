//
//  SampleTableViewCell.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/11/25.
//

import UIKit

class SampleTableViewCell: UITableViewCell, ReusableCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
//         contentView.addSubview(bgView)
//         bgView.addSubview(itemLabel)
//
//         bgView.pinToEdges(of: contentView)
//         itemLabel.centerInSuperview()
     }

     func configure(text: String) {
         //itemLabel.text = text
     }
}
//tableView.register(BannerCell.self, forCellReuseIdentifier: BannerCell.identifier)
