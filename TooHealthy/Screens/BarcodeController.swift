//
//  BarcodeController.swift
//  TooHealthy
//
//  Created by Artem Belkov on 15.11.2019.
//  Copyright © 2019 Artem Belkov. All rights reserved.
//

import UIKit

import swiftScan
import Rideau

final class BarcodeController: UIViewController {
    @IBOutlet weak var titleView: UIView!
    
    private var scanController: LBXScanViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendLocation()
        addBarcodeController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scanController?.didMove(toParent: self)
        scanController?.startScan()
        
        view.bringSubviewToFront(titleView)
    }
    
    private func addBarcodeController() {

        var style = LBXScanViewStyle()
        style.centerUpOffset = 44
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner
        style.photoframeLineW = 4
        style.photoframeAngleW = 28
        style.photoframeAngleH = 16
        style.isNeedShowRetangle = false
        style.anmiationStyle = LBXScanViewAnimationStyle.LineStill
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
        
        scanController = controller
    }
    
    private func sendLocation() {
        
        App.location.get(success: { location in
            App.network.getProductStore(location: location, success: { store in
                
                // Show alert
                let alert = UIAlertController(title: "Are you in \(store.name)", message: "Agree if you are in store named \(store.name) at \(store.address) now?", preferredStyle: .alert)
                
                alert.addAction(.init(title: "Yes", style: .default, handler: { _ in
                    
                    // Cache current store
                    App.cache.updateStoreID(store.id)
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                alert.addAction(.init(title: "No", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
            }) { error in
                // TODO: Handle error
                print("Error: \(error)")
            }
        }) { error in
            // TODO: Handle error
            print("Error: \(error)")
        }
    }
}

extension BarcodeController: LBXScanViewControllerDelegate {
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        
        let target = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InfoController") as! InfoController
        
        let controller = RideauViewController(
          bodyViewController: RideauMaskedCornerRoundedViewController(viewController: target),
          configuration: {
            var config = RideauView.Configuration()
            config.snapPoints = [.hidden, .autoPointsFromBottom, .fraction(0.6), .fraction(1)]
            return config
        }(),
          initialSnapPoint: .autoPointsFromBottom,
          resizingOption: .resizeToVisibleArea
        )
        
        controller.rideauView.delegate = target
        
        present(controller, animated: true, completion: nil)
        
        // Search info
        App.network.getProductInfo(ean: scanResult.strScanned!, storeID: App.cache.storeID)
    }
}
