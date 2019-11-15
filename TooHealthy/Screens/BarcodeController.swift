//
//  BarcodeController.swift
//  TooHealthy
//
//  Created by Artem Belkov on 15.11.2019.
//  Copyright © 2019 Artem Belkov. All rights reserved.
//

import UIKit
import BarcodeScanner

class BarcodeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func scanTapped(_ sender: Any) {
        
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self

        present(viewController, animated: true, completion: nil)
    }
}

extension BarcodeController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print("error: \(error)")
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        // TODO: Handle
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("code: \(code), type: \(type)")
    }
}
