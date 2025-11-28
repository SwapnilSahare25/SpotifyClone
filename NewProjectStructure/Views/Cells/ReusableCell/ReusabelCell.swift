//
//  ReusabelCell.swift
//  NewProjectStructure
//
//  Created by Swapnil on 27/11/25.
//

import Foundation
import UIKit

protocol ReusableCell {
    static var identifier: String { get }
}

extension ReusableCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
