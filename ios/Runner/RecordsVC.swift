//
//  RecordsVC.swift
//  Runner
//
//  Created by tristan on 2021/1/5.
//

import UIKit
import AVFoundation
import ReplayKit
import PDFKit
import MBProgressHUD
import WebKit

class RecordsVC: UIViewController {
    @IBOutlet var backBTN : UIButton!
    @IBOutlet var firstBTN : UIButton!
    @IBOutlet var secondBTN : UIButton!
    @IBOutlet var recourdBG : UIView!
    @IBOutlet var infoBG : UIView!
    @IBOutlet var nameLbl : UILabel!
    @IBOutlet var hospitalLbl : UILabel!
    @IBOutlet var pdfView : UIView!
    @IBOutlet var htmlView : WKWebView!
    @IBOutlet var timeLbl : UILabel!
    @IBOutlet var timeBG : UIView!
    @IBOutlet var timeDot : UIView!
    @IBOutlet var alertBG : UIView!
    @IBOutlet var alertContent : UIView!
    @IBOutlet var titleTextField : UITextField!
    @IBOutlet var uploadBTN : UIButton!
    @IBOutlet var introImage: UIImageView!
    @IBOutlet var introBG : UIView!
    @IBOutlet var introBTN : UIButton!
    @IBOutlet var introPreBTN : UIButton!
    @IBOutlet var introNextBTN : UIButton!

    
    var data : [String:Any] = [:]
    
    var pdfContent : PDFView!
    
    private var playerLayer : AVCaptureVideoPreviewLayer?
    private var session : AVCaptureSession = AVCaptureSession()
    private var assetWriter:AVAssetWriter?
    private var videoInput:AVAssetWriterInput?
    private var audioInput:AVAssetWriterInput?
    
    
    private var paths : [URL] = []
    private var recordTime : TimeInterval = 0
    private var startDate : Date?
    private var timer : Timer?
    
    override var shouldAutorotate: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscapeRight
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        .landscapeRight
    }
    
    deinit {
        print("records deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        let dir = NSHomeDirectory() + "/Documents/records"
        try? FileManager.default.removeItem(atPath: dir)
        try? FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: AVAudioSession.interruptionNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(_:)), name: UIApplication.keyboardDidChangeFrameNotification, object: nil)
        changeToIdle()
        let hasIntro = UserDefaults.standard.bool(forKey: "recordIntro_\(data["userID"] ?? "")")
        introBG.isHidden = hasIntro
        nameLbl.text = data["name"] as? String
        hospitalLbl.text = data["hospital"] as? String
        titleTextField.text = data["title"] as? String
        titleTextField.placeholder = "请输入视频标题"
    }
    
    @objc func keyboardChanged(_ notification:Notification){
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let rect = value.cgRectValue
        if rect.origin.y < view.frame.size.height {
            alertContent.snp.remakeConstraints { (maker) in
                maker.bottom.equalToSuperview().offset(-rect.size.height)
            }
        }else{
            alertContent.snp.removeConstraints()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let type = data["type"] as? String ?? ""
        if type  == "html" {
            showWeb()
        }else{
            showPDF()
        }
        
    }
    
    @objc func enterBackground(){
        print("enter background -----   ")
        DispatchQueue.main.async {[weak self] in
            if RPScreenRecorder.shared().isRecording {
                self?.changeToPause()
                self?.stopRecords()
            }
        }
    }
    
    // MARK: - functions
    
    private func showWeb(){
        htmlView.isHidden = false
        let html = data["html"] as? String ?? ""
        htmlView.loadHTMLString(html, baseURL: nil)
    }
    
    private func showPDF(){
        guard let path = data["path"] as? String else {
            MBProgressHUD.toastText(msg: "文件打开失败")
            return
        }
        let url = URL(fileURLWithPath: path)
        guard let doc = PDFDocument(url: url) else {
            MBProgressHUD.toastText(msg: "文件打开失败")
            return
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchPDF(_:)))
        pdfContent = PDFView(frame: pdfView.bounds)
        pdfContent.addGestureRecognizer(tap)
        pdfView.addSubview(pdfContent)
        pdfContent.autoScales = true
        pdfContent.displayMode = .singlePage
        pdfContent.document = doc
        for oneTap in pdfContent.gestureRecognizers ?? [] {
            if oneTap is UITapGestureRecognizer {
                tap.require(toFail: oneTap)
            }
        }
    }
    
    @objc func touchPDF(_ gesture : UITapGestureRecognizer){
        let location = gesture.location(in: pdfContent)
        if location.x < pdfContent.frame.size.width/2 {
            onPre()
        }else{
            onNext()
        }
    }
    
    func initCaputre() {
        let ds = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front)
        guard let device = ds.devices.first  else {
            return
        }
        guard let cinput = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        guard playerLayer == nil else {return}
        session.addInput(cinput)
        let out = AVCapturePhotoOutput()
        session.addOutput(out)
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.connection?.videoOrientation = .landscapeRight
        layer.videoGravity = .resizeAspectFill
        layer.frame = CGRect(origin: .zero, size: recourdBG.frame.size)
        recourdBG.layer.addSublayer(layer)
        session.startRunning()
        playerLayer = layer
        playerLayer?.isHidden = true
    }
    
    private func initRecord(){
        try? AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        try? AVAudioSession.sharedInstance().setActive(true)
        let dir = NSHomeDirectory() + "/Documents/records"
        let path = dir + "/record_\(paths.count).mp4"
        let fileURL = URL(fileURLWithPath: path)
        paths.append(fileURL)
        try? FileManager.default.removeItem(at: fileURL)
        assetWriter = try! AVAssetWriter(outputURL: fileURL, fileType:
                                            AVFileType.mp4)
        let width = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        let height = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        let videoOutputSettings: Dictionary<String, Any> = [
            AVVideoCodecKey : AVVideoCodecType.h264,
            AVVideoWidthKey : width,
            AVVideoHeightKey : height
        ];
        
        let vInput  = AVAssetWriterInput (mediaType: AVMediaType.video, outputSettings: videoOutputSettings)
        vInput.expectsMediaDataInRealTime = true
        assetWriter?.add(vInput)
        videoInput = vInput
        
        let audioSettings: [String:Any] = [AVFormatIDKey : kAudioFormatMPEG4AAC,
                                           AVNumberOfChannelsKey : 2,
                                           AVSampleRateKey : 44100.0,
                                           AVEncoderBitRateKey: 192000
        ]
        
        let aInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings)
        aInput.expectsMediaDataInRealTime = true
        assetWriter?.add(aInput)
        audioInput = aInput
    }
    
    private func beginRecord(){
        guard !RPScreenRecorder.shared().isRecording else {return}
        initRecord()
        RPScreenRecorder.shared().isMicrophoneEnabled = true
        RPScreenRecorder.shared().cameraPosition = .front
        RPScreenRecorder.shared().isCameraEnabled = true
        RPScreenRecorder.shared().startCapture {[weak self] (cmSampleBuffer, rpSampleBufferType, err) in
            if err != nil { return }
            guard let writer = self?.assetWriter else {return}
            guard RPScreenRecorder.shared().isMicrophoneEnabled else {
                DispatchQueue.main.async {
                    MBProgressHUD.toastText(msg: "需授权麦克风方可开启录制，请重试")
                    self?.recordTime = 0
                    self?.changeToIdle()
                    self?.stopRecords()
                }
                return
            }
            
            if CMSampleBufferDataIsReady(cmSampleBuffer) {
//                print("the mic is enable \(RPScreenRecorder.shared().isMicrophoneEnabled)")
                DispatchQueue.main.async {
                    
                    switch rpSampleBufferType {
                    case .video:
                        
                        if self?.assetWriter?.status == AVAssetWriter.Status.unknown {
                            
                            print("Started writing")
                            writer.startWriting()
                            writer.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(cmSampleBuffer))
                        }
                        
                        if writer.status == AVAssetWriter.Status.failed {
                            print("StartCapture Error Occurred, Status = \(writer.status.rawValue), \(writer.error?.localizedDescription ?? "error")")
                            return
                        }
                        
                        if writer.status == AVAssetWriter.Status.writing {
                            if self?.videoInput?.isReadyForMoreMediaData == true {
                                if self?.videoInput?.append(cmSampleBuffer) == false {
                                    print("problem writing video")
                                }
                            }
                        }
                        
                    case .audioMic:
                        if self?.audioInput?.isReadyForMoreMediaData == true {
                            self?.audioInput?.append(cmSampleBuffer)
                        }
                    default:
                        break
                    }
                }
            }
        } completionHandler: {[weak self] (error) in
            DispatchQueue.main.async {
                if error != nil {
                    MBProgressHUD.toastText(msg: "需开启系统录屏方可开启录制，请重试")
                    self?.recordTime = 0
                    self?.changeToIdle()
                    self?.stopRecords()
                }else {
    //                self?.initCaputre()
    //                self?.playerLayer?.isHidden = false
                    if let one = RPScreenRecorder.shared().cameraPreviewView {
                        let width = self?.recourdBG.bounds.size.width ?? 0
                        let height = self?.recourdBG.bounds.size.height ?? 0
                        if #available(iOS 13.0, *) {
                            one.transform = one.transform.rotated(by: -CGFloat.pi / 2)
                        }
                        self?.recourdBG.addSubview(one)
                        one.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
                        one.isHidden = false
    //                    one.snp.remakeConstraints { (maker) in
    //                        maker.edges.equalToSuperview()
    //                    }
                    }
                    self?.changeToRecording()
                    
                }
            }
        }
    }
    
    
    private func startRecord(){
        paths.removeAll()
        beginRecord()
    }
    
    private func stopRecords(){
        timer?.invalidate()
        timer = nil
        playerLayer?.isHidden = true
        guard RPScreenRecorder.shared().isRecording else {
            return
        }
        
        RPScreenRecorder.shared().stopCapture { (error) in
            guard let writer = self.assetWriter else {return}
            writer.finishWriting {
                print("recourd finished --- ")
                self.assetWriter = nil
            }
        }
    }
    
    private func merge(finished:(()->Void)?){
        let mixComposition = AVMutableComposition()
        let audioTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))
        let videoTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))
        var totalDuration : CMTime = .zero
        for url in paths {
            let asset = AVURLAsset(url: url)
            if let assetAudioTrack = asset.tracks(withMediaType: .audio).first {
                try? audioTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: assetAudioTrack, at: totalDuration)
            }
            
            if let assetVideoTrack = asset.tracks(withMediaType: .video).first {
                try? videoTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: assetVideoTrack, at: totalDuration)
            }
            totalDuration = CMTimeAdd(totalDuration, asset.duration)
        }
        let dir = NSHomeDirectory() + "/Documents/records"
        let path = dir + "/allRecord.mp4"
        let fileURL = URL(fileURLWithPath: path)
        try? FileManager.default.removeItem(at: fileURL)
        let export = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPreset1920x1080)
        print("the export is \(export?.description ?? "error")")
        export?.outputURL = fileURL
        export?.outputFileType = .mp4
        export?.shouldOptimizeForNetworkUse = true
        export?.exportAsynchronously {
            print("export finished \(export?.error)")
            DispatchQueue.main.async {
                finished?()
            }
        }
    }
    
    private func submitFile(_ title : String){
        let dir = NSHomeDirectory() + "/Documents/records"
        let path = dir + "/allRecord.mp4"
        let vc = AppDelegate.shared?.window.rootViewController
        let naviChannel = FlutterMethodChannel(name: "com.emedclouds-channel/navigation", binaryMessenger: vc as! FlutterBinaryMessenger)
        naviChannel.invokeMethod("uploadLearnVideo", arguments: "{\"path\":\"\(path)\",\"title\":\"\(title)\",\"duration\":\"\(Int(recordTime))\"}") { (error) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if error == nil {
                self.dismiss(animated: true, completion: nil)
                MBProgressHUD.toast(msg: "上传成功")
            }else{
                MBProgressHUD.toast(img:"错误",msg: error as? String ?? "error")
            }
            
        }
    }
    
    //MARK:- IBAction
    @IBAction func onChangeRecordState(_ sender : UIButton){
        sender.isEnabled = false
        Timer.scheduledTimer(withTimeInterval: 0.33, repeats: false) { (_) in
            sender.isEnabled = true
        }
        if sender.tag == 1001 {
            startRecord()
        }else if sender.tag == 1002 {
            Timer.scheduledTimer(withTimeInterval: 0.33, repeats: false) {[weak self] (_) in
                self?.changeToPause()
            }
            stopRecords()
        }else if sender.tag == 1000 {
            beginRecord()
        }else if sender.tag == 999 {
            introBG.isHidden = false
            introImage.tag = 1
            introImage.image = UIImage(named: "record_1")
            introPreBTN.isHidden = true
        }else {
//            changeToIdle()
//            stopRecords()
            alertBG.isHidden = false
        }
        
    }
    
    @IBAction func onNext() {
        pdfContent.goToNextPage(nil)
        
    }
    
    @IBAction func onPre() {
        pdfContent.goToPreviousPage(nil)
    }
    
    @IBAction func onBack() {
        stopRecords()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onReStart(){
        alertBG.isHidden = true
        view.endEditing(true)
        paths.removeAll()
        let dir = NSHomeDirectory() + "/Documents/records"
        try? FileManager.default.removeItem(atPath: dir)
        try? FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
        changeToIdle()
    }
    
    @IBAction func onSubmint(){
        guard let title = titleTextField.text , title.count > 0 else {
            MBProgressHUD.toastText(msg: "请输入视频标题")
            return
        }
        view.endEditing(true)
        MBProgressHUD.showWhiteAdded(to: view, animated: true)
        merge {
            self.submitFile(title)
        }
    }
    
    @IBAction func onPreImage() {
        var tag = introImage.tag - 1
        if tag < 1 {
            tag = 1
        }
        introImage.tag = tag
        introImage.image = UIImage(named: "record_\(tag)")
        introBTN.isHidden = tag != 3
        introPreBTN.isHidden = tag == 1
        introNextBTN.isHidden = tag == 3
    }
    
    @IBAction func onNextImage(){
        var tag = introImage.tag + 1
        if tag > 3 {
            tag = 3
        }
        introImage.tag = tag
        introImage.image = UIImage(named: "record_\(tag)")
        introBTN.isHidden = tag != 3
        introPreBTN.isHidden = tag == 1
        introNextBTN.isHidden = tag == 3
    }
    
    @IBAction func hidenIntro(){
        UserDefaults.standard.setValue(true, forKey: "recordIntro_\(data["userID"] ?? "")")
        introBG.isHidden = true
    }
    
    @IBAction func hidenKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func textFielddidChanged(_ field : UITextField){
        let text = field.text ?? ""
//        field.clearButtonMode = text.count > 0 ? .always : .never
        guard text.count > 50 else {return}
        let sub = text.prefix(50)
        field.text = String(sub)
    }
    
    @IBAction func closeAlert(){
        alertBG.isHidden = true
    }
    
    //MARK: - Status
    private func changeToIdle(){
        firstBTN.tag = 999
        firstBTN.isHidden = false
        firstBTN.setImage(UIImage(named: "帮助"), for: .normal)
        secondBTN.setImage(UIImage(named: "播放"), for: .normal)
        secondBTN.tag = 1001
        if let s = startDate {
            recordTime += Date().timeIntervalSince(s)
        }
        recordTime = 0
        startDate = nil
        timer?.invalidate()
        timer = nil
        timeLbl.text = "00:00"
        backBTN.isHidden = false
        RPScreenRecorder.shared().cameraPreviewView?.isHidden = true
    }
    
    private func changeToRecording() {
        backBTN.isHidden = true
        firstBTN.isHidden = true
        secondBTN.setImage(UIImage(named: "录制中"), for: .normal)
        secondBTN.tag = 1002
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true)  {[weak self] (t) in
            guard let weakSelf = self else {
                t.invalidate()
                self?.timer = nil
                return
            }
            if let s = self?.startDate {
                let second = weakSelf.recordTime + Date().timeIntervalSince(s)
                weakSelf.timeLbl.text = String(format: "%02d:%02d", Int(second/60),Int(second)%60)
                UIView.animate(withDuration: 0.4) {
                    weakSelf.timeDot.alpha = 0.3
                } completion: { (_) in
                    UIView.animate(withDuration: 0.4) {
                        weakSelf.timeDot.alpha = 1
                    }
                }
            }
        }
    }
    
    private func changeToPause(){
        firstBTN.isHidden = false
        firstBTN.setImage(UIImage(named: "播放"), for: .normal)
        firstBTN.tag = 1000
        secondBTN.setImage(UIImage(named: "结束"), for: .normal)
        secondBTN.tag = 1003
        if let s = startDate {
            recordTime += Date().timeIntervalSince(s)
        }
        startDate = nil
        timer?.invalidate()
        timer = nil
        RPScreenRecorder.shared().cameraPreviewView?.isHidden = true
    }
}
