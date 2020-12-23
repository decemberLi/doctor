import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    WXApi.registerApp("wxe4e9693e772d44fd", universalLink: "https://m.e-medclouds.com/app/");
    if let controlelr = window.rootViewController as? FlutterViewController {
        let channel = FlutterMethodChannel(name: "share", binaryMessenger: controlelr.binaryMessenger);
        channel.setMethodCallHandler { (call, result) in
            if call.method == "show"{
                self.share();
            }
            result("done");
        }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return  WXApi.handleOpen(url, delegate: self)
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
    func share(){
        let sharevc = ShareVC()
        sharevc.modalPresentationStyle = .overFullScreen
        window.rootViewController?.present(sharevc, animated: false, completion: nil)
    }
    
}
