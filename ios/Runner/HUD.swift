//
//  HUD.swift
//  Runner
//
//  Created by tristan on 2020/12/29.
//

import Foundation
import MBProgressHUD

extension MBProgressHUD {
    static func toast(msg : String) {
        guard let window = AppDelegate.shared?.window else {return}
        let hud = MBProgressHUD.showAdded(to: window, animated: true)
        hud.label.text = msg
        hud.label.textColor = .white
        hud.mode = .customView
        hud.customView = UIImageView(image: UIImage(named: "right"))
        hud.contentColor = .white
        hud.bezelView.backgroundColor = .black
        hud.bezelView.color = UIColor(white: 0, alpha: 0.7)
        hud.bezelView.style = .solidColor
        hud.hide(animated: true, afterDelay: 1)
    }
}
