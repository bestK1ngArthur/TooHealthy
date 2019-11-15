//
//  BarcodeController.swift
//  TooHealthy
//
//  Created by Artem Belkov on 15.11.2019.
//  Copyright © 2019 Artem Belkov. All rights reserved.
//

import UIKit
import swiftScan

class BarcodeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBarcodeController()
    }
    
    func addBarcodeController() {

        var style = LBXScanViewStyle()
        style.centerUpOffset = 44
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner
        style.photoframeLineW = 4
        style.photoframeAngleW = 28
        style.photoframeAngleH = 16
        style.isNeedShowRetangle = false
        style.anmiationStyle = LBXScanViewAnimationStyle.LineStill
//        style.animationImage = createImageWithColor(color: UIColor.red)
        style.whRatio = 4.3/2.18
        style.xScanRetangleOffset = 30
        
        let controller = LBXScanViewController()
        controller.scanStyle = style
        controller.scanResultDelegate = self
        
        view.addSubview(controller.view)
        
        let constraints = [
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            controller.view.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        controller.didMove(toParent: self)
    }
}

extension BarcodeController: LBXScanViewControllerDelegate {
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        // TODO: Handle result
    }
}
