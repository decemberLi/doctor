//
//  UIViewCorner.swift
//  Runner
//
//  Created by tristan on 2021/1/8.
//

import Foundation

extension UIView {
    @IBInspectable
    var corner : CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            layer.cornerRadius
        }
    }
}
