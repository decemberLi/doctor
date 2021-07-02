//
//  WebVC.swift
//  Runner
//
//  Created by tristan on 2021/2/1.
//

import UIKit
import WebKit
import MBProgressHUD

class WebVC: UIViewController {
    var webview : WKWebView!
    @IBOutlet var progressView : UIProgressView!
    @IBOutlet var titleLbl : UILabel!
    @IBOutlet var commentLbl : UILabel!
    @IBOutlet var textView : UITextView!
    @IBOutlet var textNumLbl : UILabel!
    @IBOutlet var textBG : UIView!
    @IBOutlet var textColorBG : UIView!
    @IBOutlet var textAllBG : UIView!
    @IBOutlet var errorView : UIView!
    
    var initData : [String:Any]?
    
    fileprivate var commentData : [AnyHashable:Any]?
    fileprivate var needHook = 0
    fileprivate var bizType = ""
    @available(iOS 13.0 , *)
    override var overrideUserInterfaceStyle: UIUserInterfaceStyle {
        get{.light}
        set{
            super.overrideUserInterfaceStyle = newValue
        }
    }
    override var shouldAutorotate: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        .portrait
    }
    
    deinit {
        webview.removeObserver(self, forKeyPath: "estimatedProgress")
        NotificationCenter.default.removeObserver(self)
        print("--------- deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        titleLbl.text = initData?["title"] as? String ?? "title"
        let userConfig = initMessageHandler()
        let webConfig = WKWebViewConfiguration()
        webConfig.allowsInlineMediaPlayback = true
        webConfig.mediaTypesRequiringUserActionForPlayback = .all
        webConfig.userContentController = userConfig
        let array = HTTPCookieStorage.shared.cookies ?? []
        for cookie in array  {
            webConfig.websiteDataStore.httpCookieStore.setCookie(cookie, completionHandler: nil)
        }
        webview = WKWebView(frame: .zero, configuration: webConfig)
        webview.customUserAgent = "Medclouds-doctor"
        view.insertSubview(webview, belowSubview: progressView)
        webview.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(self.progressView.snp.top)
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webview.uiDelegate = self
        webview.navigationDelegate = self
        let urlString = initData?["url"] as? String ?? ""
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webview.load(request)
        }
        textView.textContainer.lineFragmentPadding = 0
    }
    
    
    
    @objc func keyboardChanged(_ notification:Notification){
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let rect = value.cgRectValue
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.33
        if rect.origin.y < view.frame.size.height {
            textAllBG.isHidden = false
            
            self.textBG.snp.remakeConstraints { (maker) in
                maker.bottom.equalToSuperview().offset(-rect.size.height)
            }
            UIView.animate(withDuration: duration) {
                self.textColorBG.alpha = 1
                self.textAllBG.layoutIfNeeded()
            }
        }else{
            NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
            self.textBG.snp.remakeConstraints { (maker) in
                maker.top.equalTo(self.textAllBG.snp.bottom)
            }
            UIView.animate(withDuration: duration) {
                self.textColorBG.alpha = 0
                self.textAllBG.layoutIfNeeded()
            } completion: { (_) in
                self.textAllBG.isHidden = true
            }
            
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func initMessageHandler() ->  WKUserContentController{
        let userConfig = WKUserContentController()
        let obj = MessageHander()
        obj.inVC = self
        userConfig.add(obj, name: "jsCall")
        let script = WKUserScript(source: "window.jsCall=webkit.messageHandlers.jsCall", injectionTime: .atDocumentStart, forMainFrameOnly: false)
        userConfig.addUserScript(script)
        return userConfig
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webview.estimatedProgress)
            if webview.estimatedProgress >= 1 {
                progressView.isHidden = true
            }
        }
    }
    
}

private extension WebVC {
    func showCommentBox(old:[AnyHashable:Any]) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(_:)), name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
        textView.becomeFirstResponder()
        guard let putData = commentData else {return}
        let putParam = putData["param"] as? [AnyHashable:Any] ?? [:]
        let text = putParam["replyContent"] as? String ?? ""
        commentLbl.text = text
        let commentText = putParam["commentContent"] as? String ?? ""
        textView.text = commentText
        updateText()
//        if let oldParams = old["param"] as? [AnyHashable:Any] {
//            let oldID = oldParams["id"] as? Int ?? -100
//            let newID = putParam["id"] as? Int ?? -101
//            if oldID != newID {
//                textView.text = ""
//                updateText()
//            }
//        }
        
    }
    
    @IBAction func onSend(){
        guard let putData = commentData else {return}
        if textView.text.count > 150 {
            MBProgressHUD.toastText(msg: "字数超过限制")
            return
        }else if textView.text.trimmingCharacters(in: CharacterSet.whitespaces).count == 0 {
            let putParam = putData["param"] as? [AnyHashable:Any] ?? [:]
            let message = putParam["requiredMessage"] as? String ?? "请输入内容"
            MBProgressHUD.toastText(msg: message)
            return
        }
        view.endEditing(true)
        
        let bizType = putData["bizType"] as? String ?? ""
        let putParam = putData["param"] as? [AnyHashable:Any] ?? [:]
        let id = putParam["id"] as? Int ?? -1
        var text = textView.text ?? ""
        text = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let params = #"{"bizType":"\#(bizType)","param":{"code":0,"content":{"id":\#(id),"text":"\#(text)","action":"publish"}}}"#
        webview.evaluateJavaScript("nativeCall('\(params)')", completionHandler: nil)
        textView.text = ""
        updateText()
        
    }
    @IBAction func onCancel(){
        view.endEditing(true)
        guard let putData = commentData else {return}
        let bizType = putData["bizType"] as? String ?? ""
        let putParam = putData["param"] as? [AnyHashable:Any] ?? [:]
        let id = putParam["id"] as? Int ?? -1
        let text = textView.text ?? ""
        let params = #"{"bizType":"\#(bizType)","param":{"code":0,"content":{"id":\#(id),"text":"\#(text)","action":"cancel"}}}"#
        webview.evaluateJavaScript("nativeCall('\(params)')", completionHandler: nil)
        
    }
    
    @IBAction func onBack(){
        if needHook == 1{
            let params = #"{"bizType":"\#(bizType)","param":{"code":0,"content":{}}}"#
            webview.evaluateJavaScript("nativeCall('\(params)')", completionHandler: nil)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func onRefreash() {
        errorView.isHidden = true
        let urlString = initData?["url"] as? String ?? ""
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webview.load(request)
        }
    }
}

private class MessageHander : NSObject,WKScriptMessageHandler {
    weak var inVC : WebVC?
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == "jsCall" else {return}
        guard let body = message.body as? String else {return}
        guard let data = body.data(using: .utf8) else {return}
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyHashable:Any] else {return}
        guard let dispatchType = json["dispatchType"] as? String else {return}
        print("json is \(json)")
        let vc = AppDelegate.shared?.rootVC
        let naviChannel = FlutterMethodChannel(name: "com.emedclouds-channel/navigation", binaryMessenger: vc as! FlutterBinaryMessenger)
        if dispatchType == "ticket" {
            naviChannel.invokeMethod("getTicket", arguments: nil) { (result) in
                guard let ticket = result as? String else {return}
                let bizType = json["bizType"] as? String ?? ""
                let params = #"{"bizType":"\#(bizType)","param":{"code":0,"content":"\#(ticket)"}}"#
                self.inVC?.webview.evaluateJavaScript("nativeCall('\(params)')", completionHandler: nil)
            }
            
        }else if dispatchType == "closeWindow" {
            inVC?.navigationController?.popViewController(animated: true)
        }else if dispatchType == "setTitle" {
            let param = json["param"] as? String
            inVC?.titleLbl.text = param
        }else if dispatchType == "showInputBar" {
            let old = inVC?.commentData ?? [:]
            inVC?.commentData = json
            inVC?.showCommentBox(old: old)
        }else if dispatchType == "getWifiStatus" {
            naviChannel.invokeMethod("wifiStatus", arguments: nil) {[weak self] (result) in
                guard let self = self else {return}
                let status = result ?? 0
                let bizType = json["bizType"] as? String ?? ""
                let params = #"{"bizType":"\#(bizType)","param":{"code":0,"content":\#(status)}}"#
                //                print("the params is -- \(params)")
                self.inVC?.webview.evaluateJavaScript("nativeCall('\(params)')", completionHandler: nil)
            }
        }else if dispatchType == "hookBackBtn" {
            let bizType = json["bizType"] as? String ?? ""
            if let params = json["param"] as? [AnyHashable:Any] {
                let need = params["needHook"] as? Int
                inVC?.needHook = need ?? 0
                inVC?.bizType = bizType
            }
            
        }else if dispatchType == "openGallery" {
            func callError(){
                let params = #"{"bizType":"\#(bizType)","param":{"code":-2,"content":"参数错误"}}"#
                inVC?.webview.evaluateJavaScript("nativeCall('\(params)')", completionHandler:nil)
            }
            
            let bizType = json["bizType"] as? String ?? ""
            guard let param = json["param"] as? [AnyHashable:Any] else{
                callError()
                return
            }
            
            guard let maxCount = param["maxCount"] as? Int,
                  let enableCapture = param["enableCapture"] as? Bool else {
                callError()
                return
            }
            guard maxCount <= 9 && maxCount >= 1 else {
                callError()
                return
            }
            AppDelegate.shared?.openAlbum(max: maxCount, allowTakePicture: enableCapture, finish: { result in
                let params = #"{"bizType":"\#(bizType)","param":{"code":0,"content":\#(result)}}"#
                self.inVC?.webview.evaluateJavaScript("nativeCall('\(params)')", completionHandler:nil)
            })
        }
    }
}

extension WebVC : WKUIDelegate {
    
}

extension WebVC : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
        progressView.progress = 0
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
        webview.evaluateJavaScript("document.title") {[weak self] (result, error) in
            guard let self = self else {return}
            self.titleLbl.text = result as? String ?? "详情"
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
        errorView.isHidden = false
    }
}

extension WebVC : UITextViewDelegate {
    
    func updateText(){
        let count = textView.text.count
        textNumLbl.text = "\(count)"
        if count <= 150 {
            textNumLbl.textColor = UIColor(rgb: 0x888888)
        } else {
            textNumLbl.textColor = UIColor(rgb: 0xF67777)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateText()
    }
}
