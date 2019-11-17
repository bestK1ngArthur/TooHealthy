//
//  ProductInfoController.swift
//  TooHealthy
//
//  Created by Artem Belkov on 16.11.2019.
//  Copyright © 2019 Artem Belkov. All rights reserved.
//

import UIKit

import Rideau
import swiftScan

final class ProductAnalogueCell: UICollectionViewCell {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
}

protocol ProductInfoControllerDelegate: AnyObject {
    func controllerWillDismissed(_ controller: ProductInfoController)
}

final class ProductInfoController: UITableViewController {
    weak var delegate: ProductInfoControllerDelegate?
    
    var product: Product? {
        didSet {
            updateProduct()
        }
    }
    
    @IBOutlet weak var productBarcodeView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productRatingView: UIView!
    @IBOutlet weak var productRatingLabel: UILabel!
    @IBOutlet weak var productMessagesLabel: UILabel!
    
    @IBOutlet weak var productEcologyView: UIView!
    @IBOutlet weak var productEcologyLabel: UILabel!
    @IBOutlet weak var productEcologyMessage: UILabel!
    
    @IBOutlet weak var analoguesCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = .init()
        
        analoguesCollectionView.delegate = self
        analoguesCollectionView.dataSource = self
    }
      
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.controllerWillDismissed(self)
    }
    
    private func updateProduct() {
        guard let product = product else { return }
        
        productNameLabel.text = product.name
        
        let barcodeImage = LBXScanWrapper.createCode128(codeString: product.ean, size: productBarcodeView.bounds.size, qrColor: UIColor.black, bkColor: UIColor.white)
        productBarcodeView.image = barcodeImage
        
        productRatingView.backgroundColor = product.ratingColor
        productRatingLabel.text = product.ratingString
    
        if !product.messages.isEmpty {
            var messages = ""
            product.messages.forEach { message in
                messages.append(contentsOf: "\(message)\n")
            }
            productMessagesLabel.text = messages
            productMessagesLabel.textColor = product.ratingColor
        } else {
            productMessagesLabel.text = nil
        }
        
        if let package = product.package {
            productEcologyView.backgroundColor = R.color.yellowTint()
            productEcologyLabel.text = "🙂 \(package)"
            productEcologyMessage.textColor = R.color.yellowTint()
        }

        productEcologyMessage.text = "Do not forget to dispose of packaging and waste properly."
        
        tableView.reloadData()
    }
}

extension ProductInfoController: RideauViewDelegate {
    
    func rideauView(_ rideauView: RideauView, willMoveTo snapPoint: RideauSnapPoint) {
    
        if snapPoint == .autoPointsFromBottom {
            tableView.alpha = 0.8
        } else {
            tableView.alpha = 1
        }
    }
      
    func rideauView(_ rideauView: RideauView, didMoveTo snapPoint: RideauSnapPoint) {

    }
    
    func rideauView(_ rideauView: RideauView, animatorsAlongsideMovingIn range: ResolvedSnapPointRange) -> [UIViewPropertyAnimator] {
        return []
    }
}

extension ProductInfoController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.analogues.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductAnalogueCell", for: indexPath) as? ProductAnalogueCell, let analogue = product?.analogues[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        cell.colorView.backgroundColor = analogue.ratingColor
        cell.nameLabel.text = analogue.name
        cell.nameLabel.textColor = analogue.ratingColor
        cell.emojiLabel.text = analogue.ratingString
        
        return cell
    }
}
