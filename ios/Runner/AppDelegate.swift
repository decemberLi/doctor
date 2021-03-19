import UIKit
import Flutter
import UserNotificationsUI

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    static var shared : AppDelegate?
    var naviChannel : FlutterMethodChannel!
    var gotoURL : String?
    var isLoaded  = false
    var notiInfo : [AnyHashable:Any]? = nil
    var navi : UINavigationController?
    var rootVC : FlutterViewController?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        addCookie()
        initThird(launchOptions: launchOptions)
        Bugly.start(withAppId: "463f24e2f9")
        WXApi.registerApp("wxe4e9693e772d44fd", universalLink: "https://site-dev.e-medclouds.com/");
        AppDelegate.shared = self
        let vc = FlutterViewController()
        rootVC = vc
        navi = UINavigationController(rootViewController: vc)
        navi?.interactivePopGestureRecognizer?.delegate = self
        navi?.setNavigationBarHidden(true, animated: false)
        window = UIWindow()
        window.rootViewController = navi
        window.makeKeyAndVisible()
        naviChannel = FlutterMethodChannel(name: "com.emedclouds-channel/navigation", binaryMessenger: vc as! FlutterBinaryMessenger)
        naviChannel.setMethodCallHandler { (call, result) in
            if call.method == "share" {
                guard let value = call.arguments as? String else {return}
                guard let data = value.data(using: .utf8) else {return}
                guard let obj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else {return}
                self.share(map: obj)
                result(true)
            } else if call.method == "record" {
                guard let value = call.arguments as? String else {return}
                guard let data = value.data(using: .utf8) else {return}
                guard let obj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else {return}
                self.record(map: obj)
                result(true)
            }else if call.method == "checkNotification" {
                self.checkNotification { (isOpen) in
                    result(isOpen)
                }
            }else if call.method == "openSetting" {
                self.openSetting()
                result(true)
            }else if call.method == "openWebPage" {
                guard let value = call.arguments as? String else {return}
                guard let data = value.data(using: .utf8) else {return}
                guard let obj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else {return}
                self.openWebView(map: obj)
                result(true)
            }else if call.method == "eventTracker" {
                guard let value = call.arguments as? String else {return}
                guard let data = value.data(using: .utf8) else {return}
                guard let obj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else {return}
                guard let name = obj["eventName"] as? String else {return}
                var ext = ""
                if let temp = obj["ext"] as? String {
                    ext = temp
                }
                self.statistics(name: name, ext: ext)
                result(true)
            }else if call.method == "login" {
                guard let value = call.arguments as? String else {return}
                MobClick.profileSignIn(withPUID: value)
            }else if call.method == "logout" {
                MobClick.profileSignOff()
            }else if call.method == "ocrIdCardBackSide" {
                OCRManager.shared()?.startProcessOcrBack{ obj in
                    self.naviChannel.invokeMethod("ocrIdCardBackSide", arguments: obj)
                }
                result(true)
            }else if call.method == "ocrBankCard" {
                OCRManager.shared()?.startBankCardOcrProcess{ obj in
                    self.naviChannel.invokeMethod("ocrBankCard", arguments: obj)
                }
                result(true)
            }else if call.method == "ocrIdCardFaceSide" {
                OCRManager.shared()?.startProcessOcrFRONT{ obj in
                    self.naviChannel.invokeMethod("ocrIdCardFaceSide", arguments: obj)
                }
                result(true)
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
            JPUSHService.registrationIDCompletionHandler { (code, id) in
                let map = ["registerId":id ?? "error id"]
                guard let data = try? JSONSerialization.data(withJSONObject: map, options: .fragmentsAllowed) else { return }
                let upload = String(data: data, encoding: .utf8)
                self.naviChannel.invokeMethod("uploadDeviceInfo", arguments: upload)
            }
            if let info = self.notiInfo {
                self.doNoti(info: info)
                self.notiInfo = nil
            }
        }
        if let url = launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL {
            if url.absoluteString.hasPrefix("https://site-dev.e-medclouds.com")
                || url.scheme == "com.emedclouds.doctor" {
                launchEvent(type: 1)
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
            launchEvent(type: 1)
            return true
        }
        return WXApi.handleOpen(url, delegate: self)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.absoluteString.hasPrefix("https://site-dev.e-medclouds.com") ||
            url.scheme == "com.emedclouds.doctor"{
            self.naviChannel?.invokeMethod("commonWeb", arguments: url.absoluteString)
            launchEvent(type: 1)
            return true
        }
        return  WXApi.handleOpen(url, delegate: self)
    }
    
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return WXApi.handleOpenUniversalLink(userActivity, delegate: self)
    }
    
    override func applicationDidEnterBackground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0;
        JPUSHService.setBadge(0);
    }
    @objc var rootFlutterViewController : FlutterViewController {
        return rootVC!
    }

    //MARK - FlutterPluginRegistry methods. All delegating to the rootViewController

    override func registrar(forPlugin pluginKey: String) -> FlutterPluginRegistrar? {
        rootVC?.pluginRegistry().registrar(forPlugin: pluginKey)
    }

    override func hasPlugin(_ pluginKey: String) -> Bool {
        rootVC?.pluginRegistry().hasPlugin(pluginKey) ?? false
    }

    override func valuePublished(byPlugin pluginKey: String) -> NSObject? {
        rootVC?.pluginRegistry().valuePublished(byPlugin: pluginKey)
    }
    override func applicationWillEnterForeground(_ application: UIApplication) {
        launchEvent(type: -1)
    }

}

extension AppDelegate {
    
    func addCookie(){
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "2.4"
        var properties : [HTTPCookiePropertyKey:String] = [:]
        properties[HTTPCookiePropertyKey.name] = "appVersion"
        properties[HTTPCookiePropertyKey.value] = version
        properties[HTTPCookiePropertyKey.domain] = "m-dev.e-medclouds.com"
        properties[HTTPCookiePropertyKey.path] = "/"
        if let cookie = HTTPCookie(properties: properties) {
            HTTPCookieStorage.shared.setCookie(cookie)
        }
        properties[HTTPCookiePropertyKey.domain] = "m.e-medclouds.com"
        if let cookie = HTTPCookie(properties: properties) {
            HTTPCookieStorage.shared.setCookie(cookie)
        }
    }
    
    func initThird(launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        let entity = JPUSHRegisterEntity()
        entity.types = Int(UNAuthorizationOptions.alert.rawValue |
                            UNAuthorizationOptions.badge.rawValue |
                            UNAuthorizationOptions.sound.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        #if DEBUG
        UMConfigure.initWithAppkey("6007995f6a2a470e8f822118", channel: "App Store")
        JPUSHService.setup(withOption: launchOptions, appKey: "05de7d1b7c21f44388f972b6", channel: "App Store", apsForProduction: false)
        #else
        UMConfigure.initWithAppkey("60079989f1eb4f3f9b67973b", channel: "App Store")
        JPUSHService.setup(withOption: launchOptions, appKey: "602e4ea4245634138758a93c", channel: "App Store", apsForProduction: true)
        #endif
        OCRManager.shared()?.initSDK()
        
    }
    
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
    
    func checkNotification(result:((Bool)->Void)?){
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            var authorized = false
            switch settings.authorizationStatus {
            case .authorized:
                authorized = true
            case .denied:
                break
            case .ephemeral:
                break
            case .notDetermined:
                break
            case .provisional:
                break
            @unknown default:
                break
            }
            result?(authorized)
        }
        
    }
    
    func openSetting(){
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func openWebView(map : [String:Any]){
        let vc = WebVC()
        vc.initData = map
        navi?.pushViewController(vc, animated: true)
    }
}

extension AppDelegate : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if navi?.viewControllers.count == 1 {
            return false
        }
        return true
    }

    func statistics(name:String,ext:String){
        var attributes : [AnyHashable:Any] = [:]
        if let data = ext.data(using: .utf8) {
            let obj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            if let temp = obj as? [AnyHashable:Any] {
                attributes = temp
            }
        }
        MobClick.event(name, attributes: attributes)
    }

    func launchEvent(type:Int){
        print("----the type is --- \(type)")
        let isfirst = UserDefaults.standard.bool(forKey: "isFirst")
        MobClick.event("app_launch", attributes: ["launch_sourse":type,"is_first":!isfirst])
        UserDefaults.standard.setValue(true, forKey: "isFirst")
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
            launchEvent(type: 1)
        }
        
    }
    
    func onResp(_ resp: BaseResp) {
        print("\(resp)");
    }
}

extension AppDelegate : JPUSHRegisterDelegate {
    func doNoti(info:[AnyHashable:Any]){
        guard isLoaded else {
            notiInfo = info
            return
        }
        
        guard let value = info["extras"] as? String else {
            return
        }
        naviChannel.invokeMethod("receiveNotification", arguments: value)
        
    }
    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]!) {
        
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let info = notification.request.content.userInfo
        JPUSHService.handleRemoteNotification(info)
        let type =  Int(UNAuthorizationOptions.alert.rawValue |
                            UNAuthorizationOptions.badge.rawValue |
                            UNAuthorizationOptions.sound.rawValue)
        completionHandler(type)
        print("the willPresent notification is ---- \(info)")
//        doNoti(info: info)
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let info = response.notification.request.content.userInfo
        JPUSHService.handleRemoteNotification(info)
        completionHandler()
        print("the recevie notification is ---- \(info)")
        let application = UIApplication.shared
        if application.applicationState == .inactive || application.applicationState == .background {
            launchEvent(type: 2)
        }
        doNoti(info: info)
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        
    }
    
    
}
