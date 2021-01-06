//
//  RecordsVC.swift
//  Runner
//
//  Created by tristan on 2021/1/5.
//

import UIKit
import AVFoundation
import ReplayKit

class RecordsVC: UIViewController {
    
    @IBOutlet var recourdBG : UIView!
    @IBOutlet var infoBG : UIView!
    
    private var session : AVCaptureSession = AVCaptureSession()
    private var assetWriter:AVAssetWriter!
    private var videoInput:AVAssetWriterInput!
    private var audioInput:AVAssetWriterInput!
    
    private var player : AVPlayer?
    
    private var paths : [URL] = []
    
    override var shouldAutorotate: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscapeLeft
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        .landscapeLeft
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCaputre()
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
        layer.connection?.videoOrientation = .landscapeLeft
        layer.frame = CGRect(origin: .zero, size: recourdBG.frame.size)
        recourdBG.layer.addSublayer(layer)
        session.startRunning()
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
        assetWriter.add(videoInput)
        
        let audioSettings: [String:Any] = [AVFormatIDKey : kAudioFormatMPEG4AAC,
                                           AVNumberOfChannelsKey : 2,
                                           AVSampleRateKey : 44100.0,
                                           AVEncoderBitRateKey: 192000
        ]
        
        audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings)
        audioInput.expectsMediaDataInRealTime = true
        assetWriter.add(audioInput)
    }
    
    
    private func startRecord(){
        initRecord()
        RPScreenRecorder.shared().isMicrophoneEnabled = true
        RPScreenRecorder.shared().cameraPosition = .front
        RPScreenRecorder.shared().isCameraEnabled = true
        RPScreenRecorder.shared().startCapture { (cmSampleBuffer, rpSampleBufferType, err) in
            if err != nil { return }
            
            if CMSampleBufferDataIsReady(cmSampleBuffer) {
                
                DispatchQueue.main.async {
                    
                    switch rpSampleBufferType {
                    case .video:
                        
                        if self.assetWriter?.status == AVAssetWriter.Status.unknown {
                            
                            print("Started writing")
                            self.assetWriter?.startWriting()
                            self.assetWriter?.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(cmSampleBuffer))
                        }
                        
                        if self.assetWriter.status == AVAssetWriter.Status.failed {
                            print("StartCapture Error Occurred, Status = \(self.assetWriter.status.rawValue), \(self.assetWriter.error!.localizedDescription) \(self.assetWriter.error.debugDescription)")
                            return
                        }
                        
                        if self.assetWriter.status == AVAssetWriter.Status.writing {
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
    
    private func stopRecords(){
        RPScreenRecorder.shared().stopCapture { (error) in
            self.assetWriter.finishWriting {
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
    
    @IBAction func onRecord(){
        startRecord()
    }
    
    @IBAction func onStopRecord(){
        stopRecords()
    }
    
    private var playerLayer : AVPlayerLayer?
    
    private func play(){
        playerLayer?.removeFromSuperlayer()
        let path = NSHomeDirectory() + "/Documents/allRecord.mp4"
        let fileURL = URL(fileURLWithPath: path)
        player = AVPlayer(url: fileURL)
        let layer = AVPlayerLayer(player: player)
        layer.frame = CGRect(origin: .zero, size: infoBG.frame.size)
        infoBG.layer.addSublayer(layer)
        playerLayer = layer
        player?.play()
    }
    
    @IBAction func onNext() {
        print("on next")
        merge {
            self.play()
        }
        
    }
    
    @IBAction func onPre() {
        if self.assetWriter == nil {
            startRecord()
        }else{
            stopRecords()
        }
    }
}

//extension RecordsVC : RPPreviewViewControllerDelegate {
//    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
//        previewController.dismiss(animated: true, completion: nil)
//    }
//}
