import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    static var shared : AppDelegate?
    var naviChannel : FlutterMethodChannel!
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    AppDelegate.shared = self
    let vc = FlutterViewController(project: nil, initialRoute: nil, nibName: nil, bundle: nil)
    window = UIWindow()
    window.rootViewController = vc
    window.makeKeyAndVisible()
    naviChannel = FlutterMethodChannel(name: "com.emedclouds-channel/navigation", binaryMessenger: vc as! FlutterBinaryMessenger)
    naviChannel.setMethodCallHandler { (call, result) in
        if call.method == "share" {
            guard let value = call.arguments as? String else {return}
            guard let data = value.data(using: .utf8) else {return}
            guard let obj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else {return}
            self.share(map: obj)
        }
    }
    vc.setFlutterViewDidRenderCallback {
        if let url = launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL {
            if url.absoluteString.hasPrefix("https://site-dev.e-medclouds.com")
                || url.scheme == "com.emedclouds.doctor" {
                self.naviChannel?.invokeMethod("commonWeb", arguments: url.absoluteString)
            }else{
                WXApi.handleOpen(url, delegate: self)
            }
            
        }
    }
    WXApi.registerApp("wxe4e9693e772d44fd", universalLink: "https://site-dev.e-medclouds.com/");
    
    GeneratedPluginRegistrant.register(with: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        if url.absoluteString.hasPrefix("https://site-dev.e-medclouds.com")
            || url.scheme == "com.emedclouds.doctor" {
            self.naviChannel?.invokeMethod("commonWeb", arguments: url.absoluteString)
            return true
        }
        return WXApi.handleOpen(url, delegate: self)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.absoluteString.hasPrefix("https://site-dev.e-medclouds.com") ||
            url.scheme == "com.emedclouds.doctor"{
            self.naviChannel?.invokeMethod("commonWeb", arguments: url.absoluteString)
            return true
        }
        return  WXApi.handleOpen(url, delegate: self)
    }
    
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return WXApi.handleOpenUniversalLink(userActivity, delegate: self)
    }
    
}

extension AppDelegate {
    func share(map : [String:Any]){
        let sharevc = ShareVC()
        sharevc.data = map
        sharevc.modalPresentationStyle = .overFullScreen
        window.rootViewController?.present(sharevc, animated: false, completion: nil)
    }
}

extension AppDelegate : WXApiDelegate {
    func onReq(_ req: BaseReq) {
        print("\(req)");
        if let real = req as? LaunchFromWXReq {
            let msg = real.message.messageExt
            naviChannel.invokeMethod("commonWeb", arguments: msg)
            
        }
    }
    
    func onResp(_ resp: BaseResp) {
        print("\(resp)");
    }
}
