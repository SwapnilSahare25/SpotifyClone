//
//  ConfigFile.swift
//  NewProjectStructure
//
//  Created by Swapnil on 25/11/25.
//

import Foundation
import UIKit



let appDelegate = UIApplication.shared.delegate as! AppDelegate
let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate


let AppVersion:String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? ""
let OSVersion:String = UIDevice.current.systemVersion
let DeviceModel:String = DeviceHelper.getCurrentDeviceModel()
let DeviceType:String = "iOS"
let DeviceName:String = UIDevice.current.name
let DeviceUDID:String = UIDevice.current.identifierForVendor?.uuidString ?? ""
let DeviceWidth:CGFloat = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height
let ScreenWidth = UIScreen.main.bounds.width
let ScreenScale:CGFloat = UIScreen.main.scale
let isPortrait:Bool = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isPortrait ?? true
let isLandscape:Bool = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? false

// MARK: - App Flags
let isDebugMode:Bool = _isDebug()
let isSimulator:Bool = TARGET_OS_SIMULATOR != 0

// MARK: - Safe Area
let TopSafeArea:CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
let BottomSafeArea:CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0

private func _isDebug() -> Bool {
#if DEBUG
    return true
#else
    return false
#endif
}
let baseWidth: CGFloat = 375.0
let DeviceMultiplier: CGFloat = UIScreen.main.bounds.width / baseWidth
var statusBarFrame:CGRect{
    get {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let mainWindow = windowScene.windows.first else { return CGRect.zero}
        return mainWindow.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
    }
}
let topBarHeight = statusBarFrame.size.height + (UINavigationController().navigationBar.frame.height)

let PerPageItem: Int  = 20

var Host = "https://accounts.spotify.com/authorize"
var scopes = "user-read-private user-read-email playlist-read-private"

var spotifyClientID: String = "262b23b768d84dafb4129b71109f66e4"
var spotifyClientSecret: String = "8b08ca74b389477cb40b8470b314234d"
var redirectUrl: String = "myspotifyclone://callback"


var isAppLoad:Bool{
    get{
        return UserDefaults.standard.bool(forKey: "isAppLoad")
    }set{
        UserDefaults.standard.set(newValue, forKey: "isAppLoad")
    }
}

//var isEnglishLang:Bool{
//    get{
//        return UserDefaults.standard.bool(forKey: "isEnglishLang")
//    }set{
//        UserDefaults.standard.set(newValue, forKey: "isEnglishLang")
//    }
//}
var IsIntroHasSeen:Bool{
    get{
        return UserDefaults.standard.bool(forKey: "IsIntroHasSeen")
    }set{
        UserDefaults.standard.set(newValue, forKey: "IsIntroHasSeen")
    }
}
var isUserLoggedIn:Bool{
    get{
        return UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    }set{
        UserDefaults.standard.set(newValue, forKey: "isUserLoggedIn")
    }
}
