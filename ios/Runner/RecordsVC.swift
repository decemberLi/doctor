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

class RecordsVC: UIViewController {
    @IBOutlet var firstBTN : UIButton!
    @IBOutlet var secondBTN : UIButton!
    @IBOutlet var recourdBG : UIView!
    @IBOutlet var infoBG : UIView!
    @IBOutlet var pdfView : UIView!
    var pdfContent : PDFView!
    
    private var session : AVCaptureSession = AVCaptureSession()
    private var assetWriter:AVAssetWriter?
    private var videoInput:AVAssetWriterInput!
    private var audioInput:AVAssetWriterInput!
    
    private var playerLayer : AVCaptureVideoPreviewLayer?
    
    private var paths : [URL] = []
    private var recordTime : Int = 0
    
    override var shouldAutorotate: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscapeRight
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        .landscapeRight
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCaputre()
        try? AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        try? AVAudioSession.sharedInstance().setActive(true)
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: AVAudioSession.interruptionNotification, object: nil)
        changeToIdle()
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
    
    func initCaputre() {
        let ds = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front)
        guard let device = ds.devices.first  else {
            return
        }
        guard let cinput = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        session.addInput(cinput)
        let out = AVCapturePhotoOutput()
        session.addOutput(out)
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.connection?.videoOrientation = .landscapeRight
        layer.frame = CGRect(origin: .zero, size: recourdBG.frame.size)
        recourdBG.layer.addSublayer(layer)
        session.startRunning()
        playerLayer = layer
        playerLayer?.isHidden = true
    }
    
    private func initRecord(){
        let path = NSHomeDirectory() + "/Documents/record_\(paths.count).mp4"
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
        initRecord()
        RPScreenRecorder.shared().isMicrophoneEnabled = true
        RPScreenRecorder.shared().cameraPosition = .front
        RPScreenRecorder.shared().isCameraEnabled = true
        RPScreenRecorder.shared().startCapture { (cmSampleBuffer, rpSampleBufferType, err) in
            if err != nil { return }
            guard let writer = self.assetWriter else {return}
            
            if CMSampleBufferDataIsReady(cmSampleBuffer) {
                print("the mic is enable \(RPScreenRecorder.shared().isMicrophoneEnabled)")
                DispatchQueue.main.async {
                    
                    switch rpSampleBufferType {
                    case .video:
                        
                        if self.assetWriter?.status == AVAssetWriter.Status.unknown {
                            
                            print("Started writing")
                            writer.startWriting()
                            writer.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(cmSampleBuffer))
                        }
                        
                        if writer.status == AVAssetWriter.Status.failed {
                            print("StartCapture Error Occurred, Status = \(writer.status.rawValue), \(writer.error?.localizedDescription ?? "error")")
                            return
                        }
                        
                        if writer.status == AVAssetWriter.Status.writing {
                            if self.videoInput.isReadyForMoreMediaData {
                                if self.videoInput.append(cmSampleBuffer) == false {
                                    print("problem writing video")
                                }
                            }
                        }
                        
                    case .audioMic:
                        if self.audioInput.isReadyForMoreMediaData {
                            self.audioInput.append(cmSampleBuffer)
                        }
                    default:
                        break
                    }
                }
            }
        } completionHandler: { (error) in
            
        }
    }
    
    
    private func startRecord(){
        changeToRecording()
        paths.removeAll()
        beginRecord()
    }
    
    private func stopRecords(){
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
        
        let path = NSHomeDirectory() + "/Documents/allRecord.mp4"
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
        }
        
    }
    
    private func submit(){
        let path = NSHomeDirectory() + "/Documents/allRecord.mp4"
        let fileURL = URL(fileURLWithPath: path)
    }
    
    @IBAction func onNext() {
        pdfContent.goToNextPage(nil)
        
    }
    
    @IBAction func onPre() {
        pdfContent.goToPreviousPage(nil)
    }
    
    //MARK: - UI
    private func changeToIdle(){
        firstBTN.isHidden = true
        secondBTN.setImage(UIImage(named: "播放"), for: .normal)
        playerLayer?.isHidden = true
        secondBTN.tag = 1001
    }
    
    private func changeToRecording() {
        firstBTN.isHidden = true
        secondBTN.setImage(UIImage(named: "录制中"), for: .normal)
        playerLayer?.isHidden = false
        secondBTN.tag = 1002
    }
    
    private func changeToPause(){
        firstBTN.isHidden = false
        secondBTN.setImage(UIImage(named: "结束"), for: .normal)
        playerLayer?.isHidden = true
        secondBTN.tag = 1003
    }
}

//extension RecordsVC : RPPreviewViewControllerDelegate {
//    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
//        previewController.dismiss(animated: true, completion: nil)
//    }
//}

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
