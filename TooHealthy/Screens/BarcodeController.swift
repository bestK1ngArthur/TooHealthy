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
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationTitle: UILabel!
    
    private var scanController: LBXScanViewController?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationView.isHidden = true
        
        sendLocation()
        addBarcodeController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scanController?.didMove(toParent: self)
        scanController?.startScan()
        
        view.bringSubviewToFront(titleView)
        view.bringSubviewToFront(locationView)
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
        style.colorAngle = .init(red: 148/255, green: 212/255, blue: 218/255, alpha: 1)
        
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
        locationView.isHidden = false
        
        App.location.get(success: { location in
            App.network.getProductStore(location: location, success: { store in
                self.locationTitle.text = "📍 \(store.name)"
                
                // Show alert
                let alert = UIAlertController(title: "Are you in \(store.name)", message: "Agree if you are in store named \(store.name) at \(store.address) now?", preferredStyle: .alert)
                
                alert.addAction(.init(title: "Yes", style: .default, handler: { _ in
                    
                    // Cache current store
                    App.cache.updateStoreID(store.id)
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                alert.addAction(.init(title: "No", style: .cancel, handler: { _ in
                    self.locationView.isHidden = true
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            }) { error in
                self.locationView.isHidden = true

                // TODO: Handle error
                print("Error: \(error)")
            }
        }) { error in
            self.locationView.isHidden = true

            // TODO: Handle error
            print("Error: \(error)")
        }
    }
}

extension BarcodeController: LBXScanViewControllerDelegate {
    
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        
        let target = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductInfoController") as! ProductInfoController
        target.delegate = self
        
        let controller = RideauViewController(
          bodyViewController: RideauMaskedCornerRoundedViewController(viewController: target),
          configuration: {
            var config = RideauView.Configuration()
            config.snapPoints = [.fraction(0.6), .fraction(1)]
            return config
        }(),
          initialSnapPoint: .fraction(0.6),
          resizingOption: .resizeToVisibleArea
        )
        
        controller.rideauView.delegate = target
                
        // Search info
        ActivityIndicator.shared.start()
        App.network.getProductInfo(ean: scanResult.strScanned!, storeID: App.cache.storeID, userSettings: App.cache.userSettings, success: { product in
            ActivityIndicator.shared.stop()

            target.product = product
            self.present(controller, animated: true, completion: nil)
            
        }) { error in
//            self.scanController?.startScan()
            ActivityIndicator.shared.stop()

            // TODO: Handle error
            print("Error: \(error)")
            
            // Show alert
            let alert = UIAlertController(title: "Error", message: "Product did not found", preferredStyle: .alert)
            alert.addAction(.init(title: "Cancel", style: .cancel, handler: { _ in
                self.scanController?.startScan()
            }))
        }
    }
}

extension BarcodeController: ProductInfoControllerDelegate {
    
    func controllerWillDismissed(_ controller: ProductInfoController) {
        scanController?.startScan()
    }
}
