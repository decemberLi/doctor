//
//  OCRCoverView.swift
//  Runner
//
//  Created by tristan on 2021/2/25.
//

import UIKit

class OCRCoverView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let bgColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        bgColor.setFill()
        context.fill(rect)
        guard let img = UIImage(named: "idFront") else {return}
        let size = img.size
        let point = CGPoint(x: (rect.size.width - size.width)/2, y: 126)
        context.clear(CGRect(origin: point, size: size))
        img.draw(at: point)
    }
    

}
