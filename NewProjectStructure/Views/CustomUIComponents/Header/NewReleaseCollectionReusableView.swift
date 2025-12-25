//
//  NewReleaseCollectionReusableView.swift
//  NewProjectStructure
//
//  Created by Swapnil on 24/12/25.
//

import UIKit

class NewReleaseCollectionReusableView: UICollectionReusableView, ReusableCell {
        


  var profileImage:UIImageView!
  var titleLbl:UILabel!
  var subtitleLbl:UILabel!
 private var profileLeadingConstraint: NSLayoutConstraint!

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = CellBgColor
    self.setUpUi()

  }
  func setLeading(_ value: CGFloat) {
        profileLeadingConstraint.constant = value
    }

  // MARK: - Reuse Safety
     override func prepareForReuse() {
         super.prepareForReuse()
         profileLeadingConstraint.constant = deviceMargin
         titleLbl.text = nil
         subtitleLbl.text = nil
         profileImage.image = nil
     }

  private func setUpUi() {

    profileImage = UIFactory.makeImageView(imageName: "Setting",cornerRadius: 25*DeviceMultiplier,clipsToBounds: true)
    self.addSubview(profileImage)
    profileLeadingConstraint = profileImage.leadingAnchor.constraint(equalTo: leadingAnchor,constant: deviceMargin)
    profileLeadingConstraint.isActive = true
    profileImage.addConstraints(constraintsDict: [.FixHeight:50,.FixWidth:50,.Top:28])


    titleLbl = UIFactory.makeLabel(text:"",textColor: WhiteTextColor,font: UIFont(name: fontNameBold, size: HeaderFontSize.scaled) ?? .boldSystemFont(ofSize: 19),alignment: .left)
    self.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Trailing:deviceMargin,.FixHeight:25,.Bottom:20])
    titleLbl.rightTo(view: profileImage, constant: 10)
    titleLbl.backgroundColor = .clear

    subtitleLbl = UIFactory.makeLabel(text:"NEW RELEASE FROM",textColor: WhiteTextColor,font: UIFont(name: fontNameRegular, size: (SmallFontSize-3).scaled) ?? .boldSystemFont(ofSize: 9),alignment: .left)
    self.addSubview(subtitleLbl)
    subtitleLbl.addConstraints(constraintsDict: [.Trailing:deviceMargin,.FixHeight:10])
    subtitleLbl.rightTo(view: profileImage, constant: 10)
    subtitleLbl.aboveTo(view: titleLbl, constant: 2)
    subtitleLbl.backgroundColor = .clear
  }

  func configure(obj: NewRelease) {

    self.profileImage.setImage(urlStr: obj.artist?.image ?? "")
    self.titleLbl.text = obj.artist?.name ?? ""
  }


  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
