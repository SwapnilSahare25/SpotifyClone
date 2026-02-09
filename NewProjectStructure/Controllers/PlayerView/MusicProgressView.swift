//
//  MusicProgressView.swift
//  NewProjectStructure
//
//  Created by Swapnil on 09/02/26.
//

import UIKit

class MusicProgressView: UIView {

  private let progressBar = UIProgressView(progressViewStyle: .bar)
  private var currentSecLabel: UILabel!
  private var duretionLabel: UILabel!

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = .clear
    self.setupUI()


  }

  private func setupUI() {

    self.progressBar.trackTintColor = .white
    self.progressBar.progressTintColor = CellBgColor
    self.progressBar.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(self.progressBar)
    self.progressBar.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:20,.FixHeight:2])
    self.progressBar.clipsToBounds = true
    self.progressBar.layer.cornerRadius = 1*DeviceMultiplier
    self.progressBar.isUserInteractionEnabled = true
    self.progressBar.addTarget(self, action: #selector(self.increaseDecreaseCurrentDuretion))


    self.currentSecLabel = UIFactory.makeLabel(text:"0:45",textColor: SecondaryTextColor,font: UIFont(name: fontNameMedium, size: (SmallFontSize+1).scaled) ?? .boldSystemFont(ofSize: SmallFontSize-1),alignment: .left)
    self.addSubview(currentSecLabel)
    currentSecLabel.addConstraints(constraintsDict: [.Leading:0,.HeightLessThanOrEqual:20,.FixWidth:30])
    currentSecLabel.addConstraints(constraintsDict: [.BelowTo: 7],relativeTo: self.progressBar)
    currentSecLabel.backgroundColor = .clear

    self.duretionLabel = UIFactory.makeLabel(text:"3:45",textColor: SecondaryTextColor,font: UIFont(name: fontNameMedium, size: (SmallFontSize+1).scaled) ?? .boldSystemFont(ofSize: SmallFontSize-1),alignment: .right)
    self.addSubview(duretionLabel)
    duretionLabel.addConstraints(constraintsDict: [.Trailing:0,.HeightLessThanOrEqual:20,.FixWidth:30])
    duretionLabel.addConstraints(constraintsDict: [.BelowTo: 7],relativeTo: self.progressBar)
    duretionLabel.backgroundColor = .clear



  }

  @objc func increaseDecreaseCurrentDuretion(){
    print("init(coder:) has not been implemented")
  }

  func setProgress(_ progress: Float) {
    progressBar.setProgress(50.0, animated: true)
  }



  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
