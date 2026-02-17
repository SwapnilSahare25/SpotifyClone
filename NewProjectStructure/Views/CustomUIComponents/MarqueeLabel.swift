//
//  MarqueeLabel.swift
//  NewProjectStructure
//
//  Created by Swapnil on 17/02/26.
//

import Foundation
import UIKit

class MarqueeLabel: UIView {

    private let label = UILabel()
    private var animationDuration: TimeInterval = 6.0
    private var pauseDuration: TimeInterval = 1.0

    var text: String? {
        didSet { setupLabel() }
    }

    var font: UIFont? {
        didSet { label.font = font }
    }

    var textColor: UIColor? {
        didSet { label.textColor = textColor }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        clipsToBounds = true
        label.lineBreakMode = .byClipping
        addSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLabel()
    }

    private func setupLabel() {
        label.layer.removeAllAnimations()
        label.sizeToFit()

        guard let textWidth = label.intrinsicContentSize.width as CGFloat? else { return }
        let containerWidth = bounds.width

        // Start label at x = 0, always show first part of text
        label.frame = CGRect(x: 0, y: 0, width: textWidth, height: bounds.height)

        if textWidth <= containerWidth {
            // Text fits → no animation
            label.frame.origin.x = 0
        } else {
            // Text overflow → animate after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + pauseDuration) {
                self.startScrolling(distance: textWidth - containerWidth)
            }
        }
    }

    private func startScrolling(distance: CGFloat) {
        guard distance > 0 else { return }

        func animateLeft() {
            UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveLinear], animations: {
                self.label.frame.origin.x = -distance
            }) { _ in
                animateRight()
            }
        }

        func animateRight() {
            UIView.animate(withDuration: animationDuration, delay: pauseDuration, options: [.curveLinear], animations: {
                self.label.frame.origin.x = 0
            }) { _ in
                animateLeft()
            }
        }

        animateLeft()
    }
}
