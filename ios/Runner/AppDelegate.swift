import UIKit
import Flutter
import UserNotificationsUI

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    static var shared : AppDelegate?
    var naviChannel : FlutterMethodChannel!
    var gotoURL : String?
    var isLoaded  = false
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    UMConfigure.initWithAppkey("5ff2a5b4adb42d58269a165e", channel: "App Store")
    Bugly.start(withAppId: "463f24e2f9")
    WXApi.registerApp("wxe4e9693e772d44fd", universalLink: "https://site-dev.e-medclouds.com/");
//    let entity = JPUSHRegisterEntity()
//    entity.types = Int(UNAuthorizationOptions.alert.rawValue |
//                        UNAuthorizationOptions.badge.rawValue |
//                        UNAuthorizationOptions.sound.rawValue)
//    JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
//    JPUSHService.setup(withOption: launchOptions, appKey: "a7547476f7255646ea8646fd", channel: "App Store", apsForProduction: false)
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
        } else if call.method == "record" {
            guard let value = call.arguments as? String else {return}
            guard let data = value.data(using: .utf8) else {return}
            guard let obj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else {return}
            self.record(map: obj)
        }
    }
    vc.setFlutterViewDidRenderCallback {
        self.isLoaded = true
        if let url = self.gotoURL {
            self.naviChannel?.invokeMethod("commonWeb", arguments: url)
            self.gotoURL = nil
        }else if let url = launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL {
            if url.absoluteString.hasPrefix("https://site-dev.e-medclouds.com")
                || url.scheme == "com.emedclouds.doctor" {
                self.naviChannel?.invokeMethod("commonWeb", arguments: url.absoluteString)
            }
        }
    }
    if let url = launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL {
        if url.absoluteString.hasPrefix("https://site-dev.e-medclouds.com")
            || url.scheme == "com.emedclouds.doctor" {
            
        }else{
            WXApi.handleOpen(url, delegate: self)
        }
        
    }
    
    GeneratedPluginRegistrant.register(with: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(.newData)
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
    
    override func applicationDidEnterBackground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
}

extension AppDelegate {
    func share(map : [String:Any]){
        let sharevc = ShareVC()
        sharevc.data = map
        sharevc.modalPresentationStyle = .overFullScreen
        window.rootViewController?.present(sharevc, animated: false, completion: nil)
    }
    
    func record(map : [String:Any]) {
        let vc = RecordsVC()
        vc.data = map
        vc.modalPresentationStyle = .fullScreen
        window.rootViewController?.present(vc, animated: false, completion: nil)
    }
}

extension AppDelegate : WXApiDelegate {
    func onReq(_ req: BaseReq) {
        print("\(req)");
        if let real = req as? LaunchFromWXReq {
            let msg = real.message.messageExt
            if isLoaded {
                naviChannel.invokeMethod("commonWeb", arguments: msg)
            }else{
                gotoURL = msg
            }
        }
        
    }
    
    func onResp(_ resp: BaseResp) {
        print("\(resp)");
    }
}

extension AppDelegate : JPUSHRegisterDelegate {
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let info = notification.request.content.userInfo
        JPUSHService.handleRemoteNotification(info)
        let type =  Int(UNAuthorizationOptions.alert.rawValue |
                            UNAuthorizationOptions.badge.rawValue |
                            UNAuthorizationOptions.sound.rawValue)
        completionHandler(type)
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let info = response.notification.request.content.userInfo
        JPUSHService.handleRemoteNotification(info)
        completionHandler()
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        
    }
    
    
}
