//
//  BaseNavigationController.swift
//  Runner
//
//  Created by tristan on 2021/5/12.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override var shouldAutorotate: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let vc = viewControllers.last {
            return vc.supportedInterfaceOrientations
        }
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let vc = viewControllers.last {
            return vc.preferredInterfaceOrientationForPresentation
        }
        return .portrait
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

}
