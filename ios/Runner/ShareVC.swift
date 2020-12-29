//
//  ShareVC.swift
//  Runner
//
//  Created by tristan on 2020/12/23.
//

import UIKit
import SnapKit
import MBProgressHUD

class ShareVC: UIViewController {
    @IBOutlet var bgView : UIView!
    @IBOutlet var imgContent : UIImageView!
    @IBOutlet var sheetBG : UIView!
    @IBOutlet var sheetCorner : UIView!
    @IBOutlet var buttonBG : UIStackView!
    var data : [String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetCorner.clipsToBounds = true
        sheetCorner.layer.cornerRadius = 24
        guard let path = data["path"] as? String else {return}
        let img = UIImage(contentsOfFile: path)
        imgContent.image = img
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let names = ["微信","朋友圈","复制链接","保存图片"]
        for (index,name) in names.enumerated() {
            let bg = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 60))
            bg.snp.makeConstraints { (maker) in
                maker.width.equalTo(50)
            }
            let content = UIView()
            let btn = UIButton()
            btn.tag = index
            btn.addTarget(self, action: #selector(onBTN(sender:)), for: .touchUpInside)
            btn.setImage(UIImage(named: name), for: .normal)
            content.addSubview(btn)
            let lbl = UILabel()
            lbl.text = name
            lbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            lbl.textColor = UIColor(rgb: 0x444444)
            content.addSubview(lbl)
            btn.snp.makeConstraints { (maker) in
                maker.left.right.top.equalToSuperview()
                maker.bottom.equalTo(lbl.snp.top).offset(-5)
            }
            lbl.snp.makeConstraints { (maker) in
                maker.centerX.equalToSuperview()
                maker.bottom.equalToSuperview()
            }
            bg.addSubview(content)
            content.snp.makeConstraints { (maker) in
                maker.center.equalToSuperview()
            }
            buttonBG.addArrangedSubview(bg)
        }
        let first = UIView()
        first.snp.makeConstraints { (maker) in
            maker.width.equalTo(1)
        }
        buttonBG.insertArrangedSubview(first, at: 0)
        let end = UIView()
        end.snp.makeConstraints { (maker) in
            maker.width.equalTo(1)
        }
        buttonBG.addArrangedSubview(end)
        self.view.layoutIfNeeded()
        sheetBG.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: 0.22) {
            self.bgView.alpha = 1
            self.imgContent.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func onDismiss(){
        sheetBG.snp.removeConstraints()
        sheetBG.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.bottom)
        }
        UIView.animate(withDuration: 0.22) {
            self.bgView.alpha = 0
            self.imgContent.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func onBTN(sender : UIButton){
        if sender.tag == 0{
            shareToWx()
        }else if sender.tag == 1 {
            shareToPYQ()
        }else if sender.tag == 2 {
            copyToPasboard()
        }else if sender.tag == 3 {
            download()
        }
    }
    
    func shareToWx(){
        guard let path = data["path"] as? String else {return}
        let url = URL(fileURLWithPath: path)
        guard let img = try? Data(contentsOf: url) else {
            return
        }
        let imgObj = WXImageObject()
        imgObj.imageData = img
        let message = WXMediaMessage();
        message.mediaObject = imgObj
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        WXApi.send(req) { (result) in
            if result {
                MBProgressHUD.toast(msg: "分享成功")
            }else{
                MBProgressHUD.toast(msg: "分享失败")
            }
        }
        onDismiss()
    }
    
    func shareToPYQ(){
        guard let path = data["path"] as? String else {return}
        let url = URL(fileURLWithPath: path)
        guard let img = try? Data(contentsOf: url) else {
            return
        }
        let imgObj = WXImageObject()
        imgObj.imageData = img
        let message = WXMediaMessage();
        message.mediaObject = imgObj
        let req = SendMessageToWXReq()
        req.scene = Int32(WXSceneTimeline.rawValue)
        req.bText = false
        req.message = message
        WXApi.send(req) { (result) in
            if result {
                MBProgressHUD.toast(msg: "分享成功")
            }else{
                MBProgressHUD.toast(msg: "分享失败")
            }
        }
        onDismiss()
    }
    
    func copyToPasboard(){
        let value = data["url"] as? String
        UIPasteboard.general.string = value
        MBProgressHUD.toast(msg: "复制成功")
    }
    
    func download(){
        guard let path = data["path"] as? String else {return}
        let img = UIImage(contentsOfFile: path)
        guard let save = img else{
            return
        }
        UIImageWriteToSavedPhotosAlbum(save, nil, nil, nil)
        MBProgressHUD.toast(msg: "保存成功")
    }
}
