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
    
    @IBInspectable
    var borderWidth : CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            layer.borderWidth
        }
    }
    
    @IBInspectable
    var borderColor : UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
    }
}
