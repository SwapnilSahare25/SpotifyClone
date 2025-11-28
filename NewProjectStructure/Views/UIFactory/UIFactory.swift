//
//  UIFactory.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/11/25.
//

import Foundation
import UIKit
import Kingfisher

final class UIFactory {
    
    
    // MARK: Make View
    static func makeContinerView(backgroundColor: UIColor = .clear,cornerRadius: CGFloat = 0,borderWidth: CGFloat = 0,
                                 borderColor: UIColor = .clear,frame: CGRect? = nil,clipsToBounds: Bool = true) -> UIView {
        
        let view = UIView(frame: frame ?? .zero)
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
        view.clipsToBounds = clipsToBounds
        
        view.translatesAutoresizingMaskIntoConstraints = (frame != nil ? true : false)
        return view
    }
    
    
    // MARK: - UIButton
    static func makeButton(title: String? = nil,titleColor: UIColor = .white,font: UIFont = .systemFont(ofSize: 16, weight: .medium),
                           backgroundColor: UIColor = .white,cornerRadius: CGFloat = 0,image: String? = nil,
                           contentMode: UIView.ContentMode = .scaleAspectFit,frame: CGRect? = nil) -> UIButton {
        
        let button = UIButton(frame: frame ?? .zero)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = font
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
        button.setImage(UIImage(named: image ?? ""), for: .normal)
        button.imageView?.contentMode = contentMode
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    // MARK: - UILabel
    static func makeLabel(text: String,textColor: UIColor = .black,font: UIFont = .systemFont(ofSize: 14),alignment: NSTextAlignment = .left,numberOfLines: Int = 0,frame: CGRect? = nil) -> UILabel {
        
        let label = UILabel(frame: frame ?? .zero)
        label.text = text
        label.textColor = textColor
        label.font = font
        label.textAlignment = alignment
        label.numberOfLines = numberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    // MARK: - UIImageView
    @MainActor static func makeImageView(imageName: String? = nil,contentMode: UIView.ContentMode = .scaleAspectFit,
                                         cornerRadius: CGFloat = 0,clipsToBounds: Bool = true,frame: CGRect? = nil) -> UIImageView {
        
        let imageView = UIImageView(frame: frame ?? .zero)
        imageView.contentMode = contentMode
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = clipsToBounds
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        if let imageName = imageName {
            if let url = URL(string: imageName), imageName.hasPrefix("http") {
                imageView.kf.setImage(with: url)
            } else {
                imageView.image = UIImage(named: imageName)
            }
        }
        
        return imageView
    }
    
    // MARK: - UITextField
    static func makeTextField(placeholder: String? = nil,font: UIFont = .systemFont(ofSize: 14),textColor: UIColor = .black,
                              keyboardType: UIKeyboardType = .default,borderStyle: UITextField.BorderStyle = .roundedRect,isSecure: Bool = false,frame: CGRect? = nil) -> UITextField {
        
        let tf = UITextField(frame: frame ?? .zero)
        tf.placeholder = placeholder
        tf.font = font
        tf.textColor = textColor
        tf.keyboardType = keyboardType
        tf.borderStyle = borderStyle
        tf.isSecureTextEntry = isSecure
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }
    
    // MARK: - UITextView
    static func makeTextView(text: String? = nil,font: UIFont = .systemFont(ofSize: 14),textColor: UIColor = .black,
                             alignment: NSTextAlignment = .left,isEditable: Bool = true,isScrollEnabled: Bool = true,frame: CGRect? = nil) -> UITextView {
        
        let tv = UITextView(frame: frame ?? .zero)
        tv.text = text
        tv.font = font
        tv.textColor = textColor
        tv.textAlignment = alignment
        tv.isEditable = isEditable
        tv.isScrollEnabled = isScrollEnabled
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }
    
    // MARK: - UIScrollView
    static func makeScrollView(isPagingEnabled: Bool = false,showsHorizontalScrollIndicator: Bool = true,
                               showsVerticalScrollIndicator: Bool = true,frame: CGRect? = nil) -> UIScrollView {
        
        let scrollView = UIScrollView(frame: frame ?? .zero)
        scrollView.isPagingEnabled = isPagingEnabled
        scrollView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        scrollView.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }
    
    // MARK: - UITableView
    static func makeTableView(style: UITableView.Style = .plain,separatorStyle: UITableViewCell.SeparatorStyle = .singleLine,
                              backgroundColor: UIColor = .white,allowsSelection: Bool = true) -> UITableView {
        
        let tableView = UITableView(frame: .zero, style: style)
        tableView.separatorStyle = separatorStyle
        tableView.backgroundColor = backgroundColor
        tableView.allowsSelection = allowsSelection
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
    
    // MARK: - UICollectionView
    static func makeCollectionView(layout: UICollectionViewLayout,backgroundColor: UIColor = .white,allowsSelection: Bool = true) -> UICollectionView {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = backgroundColor
        collectionView.allowsSelection = allowsSelection
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    // MARK: - UIStackView
    static func makeStackView(axis: NSLayoutConstraint.Axis = .vertical,spacing: CGFloat = 0,
                              distribution: UIStackView.Distribution = .fill,alignment: UIStackView.Alignment = .fill,frame: CGRect? = nil) -> UIStackView {
        
        let stack = UIStackView(frame: frame ?? .zero)
        stack.axis = axis
        stack.spacing = spacing
        stack.distribution = distribution
        stack.alignment = alignment
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
   

}
