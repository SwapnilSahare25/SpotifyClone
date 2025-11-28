//
//  IntroViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 27/11/25.
//

import UIKit
import CHIPageControl


class IntroViewController: UIViewController, UIScrollViewDelegate {


  var scrollView:UIScrollView!
  var pageControl: CHIPageControlAji!

  var leftBtn: UIButton!
  var rightBtn: UIButton!
  var getStartedBtn: UIButton!

  let onboardingArray: [(Image: String, title: String)] = [(Image: "introImg1", title: "Millions of songs"),(Image: "introImg2", title: "Listen to your favourite Podcast"),(Image: "introImg3", title: "Start listening")]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Appcolor
        self.setUpMainView()
       
    }
    
    func setUpMainView(){
      self.scrollView = UIFactory.makeScrollView(isPagingEnabled: true,showsHorizontalScrollIndicator: false)
      self.view.addSubview(self.scrollView)
      self.scrollView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Top:50,.Bottom:150],multiplyWithDevice: true)
      self.scrollView.delegate = self
      self.scrollView.backgroundColor = .clear
      self.scrollView.alwaysBounceVertical = false
      self.scrollView.contentInsetAdjustmentBehavior = .never

      var xAxis: CGFloat = 0.0

      for object in onboardingArray{
        let mainContaier = UIFactory.makeContinerView(backgroundColor: .clear,frame: CGRect(x: xAxis, y: 0, width: DeviceWidth, height: view.frame.height-265*DeviceMultiplier))
        self.scrollView.addSubview(mainContaier)


        let imageView = UIFactory.makeImageView(imageName: object.Image)
        mainContaier.addSubview(imageView)
        imageView.addConstraints(constraintsDict: [.FixHeight:250,.FixWidth:250,.CenterY:0,.CenterX:0],relativeTo: mainContaier,multiplyWithDevice: true)
        imageView.backgroundColor = .clear

        let titleLbl = UIFactory.makeLabel(text: object.title,textColor: WhiteTextColor,font: UIFont(name: fontNameSemiBold, size: BigTitleFontsize) ?? .boldSystemFont(ofSize: 12),alignment: .center)
        mainContaier.addSubview(titleLbl)
        titleLbl.addConstraints(constraintsDict: [.Leading:50,.Trailing:50,.HeightLessThanOrEqual:120],multiplyWithDevice: true)
        titleLbl.addConstraints(constraintsDict: [.BelowTo:15],relativeTo: imageView,multiplyWithDevice: true)
        titleLbl.backgroundColor = .clear


        xAxis += DeviceWidth
      }
      self.scrollView.contentSize.width = xAxis

      let btnView = UIFactory.makeContinerView(backgroundColor: .clear)
      self.view.addSubview(btnView)
      btnView.addConstraints(constraintsDict: [.Leading:15,.Trailing:15,.FixHeight:50],multiplyWithDevice: true)
      btnView.addConstraints(constraintsDict: [.BelowTo:5],relativeTo: self.scrollView,multiplyWithDevice: true)


      let pageControlView = UIFactory.makeContinerView(backgroundColor: .clear)
      btnView.addSubview(pageControlView)
      pageControlView.addConstraints(constraintsDict: [.FixWidth:100,.FixHeight:20,.CenterX:0,.CenterY:0],multiplyWithDevice: true)

      self.pageControl = CHIPageControlAji(frame: CGRect(x: 0, y: 0, width: 100*DeviceMultiplier, height: 20*DeviceMultiplier))
      pageControlView.addSubview(self.pageControl)
      self.pageControl.numberOfPages = self.onboardingArray.count
      self.pageControl.radius = 8
      self.pageControl.tintColor = .white
      self.pageControl.currentPageTintColor = BtnBGColor
      self.pageControl.padding = 6
      self.pageControl.set(progress: 0, animated: true)

      self.leftBtn = UIFactory.makeButton(backgroundColor: .clear,image: "introleftArrow")
      btnView.addSubview(self.leftBtn)
      self.leftBtn.addConstraints(constraintsDict: [.FixWidth:50,.FixHeight:50,.Leading:0,.CenterY:0],multiplyWithDevice: true)
      self.leftBtn.tag = 100
      self.leftBtn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
      self.leftBtn.isHidden = true

      self.rightBtn = UIFactory.makeButton(backgroundColor: .clear,image: "introRightArrow")
      btnView.addSubview(self.rightBtn)
      self.rightBtn.addConstraints(constraintsDict: [.FixWidth:50,.FixHeight:50,.Trailing:0,.CenterY:0],multiplyWithDevice: true)
      self.rightBtn.tag = 101
      self.rightBtn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
      self.rightBtn.isHidden = false

      self.getStartedBtn = UIFactory.makeButton(title: "Get Started",titleColor: PrimaryTextColor,font: UIFont(name: fontNameBtn, size: DetailTabFontSize) ?? .boldSystemFont(ofSize: 12),backgroundColor: BtnBGColor,cornerRadius: 15*DeviceMultiplier)
      btnView.addSubview(self.getStartedBtn)
      self.getStartedBtn.addConstraints(constraintsDict: [.FixWidth:80,.FixHeight:30,.Trailing:0,.CenterY:0],multiplyWithDevice: true)
      self.getStartedBtn.tag = 102
      self.getStartedBtn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
      self.getStartedBtn.isHidden = true

    }
//  @objc func getStartedClicked(_ sender: UIButton){
//
//  }

  func gotoLogin(){
    let loginVc = LoginViewController()
    WindowManager.shared.setRootController(loginVc, animated: true)
  }

  @objc func btnClicked(_ sender: UIButton){
    let currentPage = Int(round(scrollView.contentOffset.x / DeviceWidth))
        var newPage = currentPage

    switch sender.tag {
      case 100:
          if currentPage > 0 {
              newPage = currentPage - 1
          }
      break
      case 101:
          if currentPage < onboardingArray.count - 1 {
              newPage = currentPage + 1
          }
      break
      case 102:
      IsIntroHasSeen = true
      self.gotoLogin()
      default:
          break
      }
    self.scrollToPage(newPage)
  }

  func scrollToPage(_ page: Int) {

      self.scrollView.setContentOffset(CGPoint(x: CGFloat(page) * DeviceWidth, y: 0), animated: true)
      self.pageControl.set(progress: page, animated: true)
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let currentPage = Int((scrollView.contentOffset.x / DeviceWidth))
    print("Current Page",currentPage)
        self.pageControl.set(progress: currentPage, animated: true)

    UIView.animate(withDuration: 0.3) {
      switch currentPage {
         case 0:
             self.leftBtn.isHidden = true
             self.rightBtn.isHidden = false
             self.getStartedBtn.isHidden = true
      case (1..<(self.onboardingArray.count - 1)):
             self.leftBtn.isHidden = false
             self.rightBtn.isHidden = false
             self.getStartedBtn.isHidden = true
      case (self.onboardingArray.count - 1):
             self.leftBtn.isHidden = false
             self.rightBtn.isHidden = true
             self.getStartedBtn.isHidden = false
         default:
             break
         }
       }
  }
}
