//
//  OCRVC.swift
//  Runner
//
//  Created by tristan on 2021/2/25.
//

import UIKit
import AVFoundation

class OCRVC: UIViewController {
    
    var ocrType : OCRType = .idcardFront
    
    private var playerLayer : AVCaptureVideoPreviewLayer?
    private var session : AVCaptureSession = AVCaptureSession()
    @IBOutlet private var recourdBG : UIView!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initCaputre()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func initCaputre() {
        guard playerLayer == nil else {return}
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .restricted {
            return
        }else{
            AVCaptureDevice.requestAccess(for: .video) { (result) in
                if result {
                    DispatchQueue.main.async {
                        self.openCaputre()
                    }
                }
            }
        }
    }
    
    private func openCaputre(){
        let ds = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
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
        layer.connection?.videoOrientation = .portrait
        layer.videoGravity = .resizeAspectFill
        layer.frame = CGRect(origin: .zero, size: recourdBG.frame.size)
        recourdBG.layer.addSublayer(layer)
        session.startRunning()
        playerLayer = layer
    }
    
    @IBAction func onback(){
        navigationController?.popViewController(animated: true)
    }

}

extension OCRVC {
    enum OCRType {
        case idcardFront
        case idcardBack
        case bankCard
    }
}
