import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    WXApi.registerApp("", universalLink: "");
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let urlKey: String = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String
        if urlKey == "com.tencent.xin" {
            return  WXApi.handleOpen(url, delegate: self)
        }
        return true
    }
    
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return WXApi.handleOpenUniversalLink(userActivity, delegate: self)
    }
    
}

extension AppDelegate : WXApiDelegate {
    func onReq(_ req: BaseReq) {
        
    }
    
    func onResp(_ resp: BaseResp) {
        
    }
    
}
