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

class RecordsVC: UIViewController {
    @IBOutlet var firstBTN : UIButton!
    @IBOutlet var secondBTN : UIButton!
    @IBOutlet var recourdBG : UIView!
    @IBOutlet var infoBG : UIView!
    @IBOutlet var pdfView : UIView!
    @IBOutlet var timeLbl : UILabel!
    @IBOutlet var alertBG : UIView!
    @IBOutlet var titleTextField : UITextField!
    @IBOutlet var introImage: UIImageView!
    @IBOutlet var introBG : UIView!
    
    var pdfContent : PDFView!
    
    private var assetWriter:AVAssetWriter?
    private var videoInput:AVAssetWriterInput!
    private var audioInput:AVAssetWriterInput!
    
    
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
        initRecord()
        try? AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        try? AVAudioSession.sharedInstance().setActive(true)
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: AVAudioSession.interruptionNotification, object: nil)
        changeToIdle()
        let hasIntro = UserDefaults.standard.bool(forKey: "recordIntro")
        introBG.isHidden = hasIntro
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showPDF()
    }
    
    @objc func enterBackground(){
        print("enter background -----   ")
        stopRecords()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    private func showPDF(){
        guard let url = Bundle.main.url(forResource: "1", withExtension: "pdf") else {return}
        let doc = PDFDocument(url: url)
        pdfContent = PDFView(frame: pdfView.bounds)
        pdfView.addSubview(pdfContent)
        pdfContent.autoScales = true
        pdfContent.displayMode = .singlePage
        pdfContent.document = doc
    }
    
    private func initRecord(){
        let dir = NSHomeDirectory() + "/Documents/records"
        try? FileManager.default.removeItem(atPath: dir)
        try? FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
        let path = dir + "/record_\(paths.count).mp4"
        let fileURL = URL(fileURLWithPath: path)
        paths.append(fileURL)
        try? FileManager.default.removeItem(at: fileURL)
        assetWriter = try! AVAssetWriter(outputURL: fileURL, fileType:
                                            AVFileType.mp4)
        let videoOutputSettings: Dictionary<String, Any> = [
            AVVideoCodecKey : AVVideoCodecType.h264,
            AVVideoWidthKey : UIScreen.main.bounds.size.width,
            AVVideoHeightKey : UIScreen.main.bounds.size.height
        ];
        
        videoInput  = AVAssetWriterInput (mediaType: AVMediaType.video, outputSettings: videoOutputSettings)
        videoInput.expectsMediaDataInRealTime = true
        assetWriter?.add(videoInput)
        
        let audioSettings: [String:Any] = [AVFormatIDKey : kAudioFormatMPEG4AAC,
                                           AVNumberOfChannelsKey : 2,
                                           AVSampleRateKey : 44100.0,
                                           AVEncoderBitRateKey: 192000
        ]
        
        audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings)
        audioInput.expectsMediaDataInRealTime = true
        assetWriter?.add(audioInput)
    }
    
    private func beginRecord(){
        RPScreenRecorder.shared().isMicrophoneEnabled = true
        RPScreenRecorder.shared().cameraPosition = .front
        RPScreenRecorder.shared().isCameraEnabled = true
        RPScreenRecorder.shared().startCapture {[weak self] (cmSampleBuffer, rpSampleBufferType, err) in
            if err != nil { return }
            guard let writer = self?.assetWriter else {return}
            guard RPScreenRecorder.shared().isMicrophoneEnabled else {
                MBProgressHUD.toastText(msg: "请开启麦克风权限")
                self?.recordTime = 0
                self?.changeToIdle()
                self?.stopRecords()
                return
            }
            
            if CMSampleBufferDataIsReady(cmSampleBuffer) {
                print("the mic is enable \(RPScreenRecorder.shared().isMicrophoneEnabled)")
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
                            if self?.videoInput.isReadyForMoreMediaData == true {
                                if self?.videoInput.append(cmSampleBuffer) == false {
                                    print("problem writing video")
                                }
                            }
                        }
                        
                    case .audioMic:
                        if self?.audioInput.isReadyForMoreMediaData == true {
                            self?.audioInput.append(cmSampleBuffer)
                        }
                    default:
                        break
                    }
                }
            }
        } completionHandler: {[weak self] (error) in
            if error != nil {
                MBProgressHUD.toastText(msg: "请打开录屏权限")
                self?.recordTime = 0
                self?.changeToIdle()
                self?.stopRecords()
            }else {
                if let one = RPScreenRecorder.shared().cameraPreviewView {
                    self?.recourdBG.addSubview(one)
                    one.snp.makeConstraints { (maker) in
                        maker.edges.equalToSuperview()
                    }
                }
                
            }
        }
    }
    
    
    private func startRecord(){
        changeToRecording()
        paths.removeAll()
        beginRecord()
    }
    
    private func stopRecords(){
        timer?.invalidate()
        timer = nil
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
    
    private func resumRecords(){
        beginRecord()
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
            print("export finished \(export?.error?.localizedDescription ?? "no error ")")
            DispatchQueue.main.async {
                finished?()
            }
        }
    }
    
    @IBAction func onChangeRecordState(_ sender : UIButton){
        if sender.tag == 1001 {
            startRecord()
        }else if sender.tag == 1002 {
            changeToPause()
            stopRecords()
        }else {
            changeToIdle()
            stopRecords()
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
        changeToRecording()
        beginRecord()
    }
    
    @IBAction func onSubmint(){
//        let path = NSHomeDirectory() + "/Documents/allRecord.mp4"
//        let fileURL = URL(fileURLWithPath: path)
    }
    
    @IBAction func onPreImage() {
        var tag = introImage.tag - 1
        if tag < 1 {
            tag = 1
        }
        introImage.tag = tag
        introImage.image = UIImage(named: "record_\(tag)")
    }
    
    @IBAction func onNextImage(){
        var tag = introImage.tag + 1
        if tag > 3 {
            tag = 3
        }
        introImage.tag = tag
        introImage.image = UIImage(named: "record_\(tag)")
    }
    
    @IBAction func hidenIntro(){
        UserDefaults.standard.setValue(true, forKey: "recordIntro")
        introBG.isHidden = true
    }
    
    //MARK: - Status
    private func changeToIdle(){
        firstBTN.isHidden = true
        secondBTN.setImage(UIImage(named: "播放"), for: .normal)
        secondBTN.tag = 1001
        if let s = startDate {
            recordTime += Date().timeIntervalSince(s)
        }
        startDate = nil
        timer?.invalidate()
        timer = nil
        timeLbl.text = ""
    }
    
    private func changeToRecording() {
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
                //"\(second/60):\(Int(second)%60)"
                weakSelf.timeLbl.text = String(format: "%02d:%02d", Int(second/60),Int(second)%60)
            }
        }
    }
    
    private func changeToPause(){
        firstBTN.isHidden = false
        secondBTN.setImage(UIImage(named: "结束"), for: .normal)
        secondBTN.tag = 1003
        if let s = startDate {
            recordTime += Date().timeIntervalSince(s)
        }
        startDate = nil
        timer?.invalidate()
        timer = nil
    }
}


func drawPDFfromURL(url: URL) -> UIImage? {
    guard let document = CGPDFDocument(url as CFURL) else { return nil }
    guard let page = document.page(at: 1) else { return nil }

    let pageRect = page.getBoxRect(.mediaBox)
    let renderer = UIGraphicsImageRenderer(size: pageRect.size)
    let img = renderer.image { ctx in
        UIColor.white.set()
        ctx.fill(pageRect)

        ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
        ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

        ctx.cgContext.drawPDFPage(page)
    }

    return img
}
