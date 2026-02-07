//
//  PlayListDetailsViewController.swift
//  NewProjectStructure
//
//  Created by Swapnil on 04/02/26.
//

import UIKit

class PlayListDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  


  private var tableView: UITableView!
  var playListId: Int = 0
  var playListObj: PlayListObject?

    override func viewDidLoad() {
        super.viewDidLoad()
      self.view.backgroundColor = .black
      self.navigationController?.setNavigationBarHidden(false, animated: false)
      navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
      navigationController?.navigationBar.shadowImage = UIImage()
      navigationController?.navigationBar.isTranslucent = true
      navigationController?.navigationBar.backgroundColor = .clear
      self.setupBackButton()
      self.setUpMainView()
      self.setupHeader()
      self.callPlayListDetailsApi()

      
    }

  private func setupHeader(){

    let headerView = UIFactory.makeContinerView(backgroundColor: .black,frame: CGRect(x: 0, y: 0, width: DeviceWidth, height: 450*DeviceMultiplier))
    headerView.setGradientBackground(colors: [UIColor(hex: "#2E4E8C"),UIColor(hex: "#050708")], locations: [0.0,1.0],startPoint: CGPoint(x: 0.5, y: 0.0),endPoint: CGPoint(x: 0.5, y: 1.0))

    let imgView = UIFactory.makeImageView(imageName: self.playListObj?.image ?? "",contentMode: .scaleAspectFit,cornerRadius: 0,clipsToBounds: true)
    headerView.addSubview(imgView)
    imgView.addConstraints(constraintsDict: [.Trailing:60,.FixHeight:245,.Top:statusBarHeight+10,.Leading:60])

    let titleLbl = UIFactory.makeLabel(text: self.playListObj?.title ?? "",textColor: WhiteTextColor,font: UIFont(name: fontNameBlack, size: (HugeTitleFontSize+4)) ?? .boldSystemFont(ofSize: BigTitleFontsize),alignment: .left)
    headerView.addSubview(titleLbl)
    titleLbl.addConstraints(constraintsDict: [.Trailing:deviceMargin,.HeightLessThanOrEqual:50,.Leading:deviceMargin])
    titleLbl.addConstraints(constraintsDict: [.BelowTo: 25],relativeTo: imgView)
    titleLbl.backgroundColor = .clear


    let descTitle = UIFactory.makeLabel(text:self.playListObj?.description ?? "",textColor: SecondaryTextColor,font: UIFont(name: fontNameRegular, size: (DetailTabFontSize)) ?? .boldSystemFont(ofSize: DetailTabFontSize),alignment: .left)
    headerView.addSubview(descTitle)
    descTitle.addConstraints(constraintsDict: [.Trailing:deviceMargin,.FixHeight:15,.Leading:deviceMargin])
    descTitle.addConstraints(constraintsDict: [.BelowTo: 5],relativeTo: titleLbl)
    descTitle.backgroundColor = .clear


    let songsCount = self.playListObj?.songCount ?? 0
    let totalDuration = self.playListObj?.totalDuration ?? ""
    let likeCount = self.playListObj?.likesCount ?? ""

    let songsCountAndDuretionTitleText = "\(songsCount) songs - \(totalDuration) - \(likeCount)"


    let subTitle = UIFactory.makeLabel(text:songsCountAndDuretionTitleText,textColor: SecondaryTextColor,font: UIFont(name: fontNameRegular, size: (DetailTabFontSize)) ?? .boldSystemFont(ofSize: DetailTabFontSize),alignment: .left)
    headerView.addSubview(subTitle)
    subTitle.addConstraints(constraintsDict: [.Trailing:deviceMargin,.FixHeight:15,.Leading:deviceMargin])
    subTitle.addConstraints(constraintsDict: [.BelowTo: 5],relativeTo: descTitle)
    subTitle.backgroundColor = .clear


    let playBtn = UIFactory.makeButton(backgroundColor: .clear,cornerRadius: 25*DeviceMultiplier,image: "playSong")
    headerView.addSubview(playBtn)
    playBtn.addConstraints(constraintsDict: [.FixWidth:60,.FixHeight:60,.Trailing:deviceMargin,.Bottom:5])
    //playBtn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)

    let shuffleBtn = UIFactory.makeButton(backgroundColor: .clear,image: "shuffleOff")
    headerView.addSubview(shuffleBtn)
    shuffleBtn.addConstraints(constraintsDict: [.FixWidth:25,.FixHeight:25,.Bottom:15])
    shuffleBtn.addConstraints(constraintsDict: [.LeftTo: 15],relativeTo: playBtn)


    let likeBtn = UIFactory.makeButton(backgroundColor: .clear,image: "unlike")
    headerView.addSubview(likeBtn)
    likeBtn.addConstraints(constraintsDict: [.FixWidth:25,.FixHeight:25,.Leading:deviceMargin,.Bottom:5])
    //likeBtn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)

    let moreOptsBtn = UIFactory.makeButton(backgroundColor: .clear,image: "moreOptsHori")
    headerView.addSubview(moreOptsBtn)
    moreOptsBtn.addConstraints(constraintsDict: [.FixWidth:15,.FixHeight:15,.Bottom:10])
    moreOptsBtn.addConstraints(constraintsDict: [.RightTo:15],relativeTo: likeBtn)


    self.tableView.tableHeaderView = headerView

  }

  private func setUpMainView(){

    self.tableView = UIFactory.makeTableView(separatorStyle: .none)
    self.view.addSubview(self.tableView)
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.backgroundColor = .clear
    self.tableView.contentInsetAdjustmentBehavior = .never
    self.tableView.register(PlayListDetailsTableViewCell.self, forCellReuseIdentifier: PlayListDetailsTableViewCell.identifier)
    self.tableView.addConstraints(constraintsDict: [.Leading:0,.Trailing:0,.Bottom:0,.Top:0])


  }




  private func callPlayListDetailsApi() {
    let endPoint = Endpoints.getPlayListDetails(playListId: self.playListId)

     APIManager.shared.request(endpoint: endPoint) { [weak self] (object: PlayListObject) in

       if let self = self {
           self.playListObj = object
         self.setupHeader()

         self.tableView.reloadData()

       }else{
         print("No Data Found")
       }
     } onFailure: { error in
       print(error)
     }

   }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let triggerOffset = 300*DeviceMultiplier

    if offsetY >= triggerOffset {
      navigationItem.title = self.playListObj?.title ?? ""
      self.setNavBarGradient(colors: [UIColor(hex: "#2E4E8C"),UIColor(hex: "#050708")])
    } else {
      navigationItem.title = ""
      setNavBarColor(.clear)
    }
  }


  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.playListObj?.tracks?.items?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: PlayListDetailsTableViewCell.identifier, for: indexPath) as! PlayListDetailsTableViewCell

    if let items = self.playListObj?.tracks?.items{
      cell.configure(obj: items[indexPath.row], index: indexPath.row)
    }

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 58*DeviceMultiplier
  }

}

