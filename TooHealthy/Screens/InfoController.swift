//
//  InfoController.swift
//  TooHealthy
//
//  Created by Artem Belkov on 16.11.2019.
//  Copyright © 2019 Artem Belkov. All rights reserved.
//

import UIKit
import Rideau

final class InfoController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
      
    private let models: [String] = [
        "😀",
        "😁",
        "😂",
        "🤣",
        "😃",
        "😄",
        "😅",
        "😆",
        "😉",
        "😊",
        "😋",
        "😎",
        "😍",
        "😘",
        "🥰",
        "😗",
        "😙",
        "😚",
        "☺️",
        "🙂",
        "🤗",
        "🤩",
        "🤔"
     ]
      
    override func awakeFromNib() {
        super.awakeFromNib()
    }
      
    override func viewDidLoad() {
        super.viewDidLoad()
    }
      
}

extension InfoController: RideauViewDelegate {
    
    func rideauView(_ rideauView: RideauView, willMoveTo snapPoint: RideauSnapPoint) {
    
        if snapPoint == .autoPointsFromBottom {
            collectionView.alpha = 0.8
        } else {
            collectionView.alpha = 1
        }
    }
      
    func rideauView(_ rideauView: RideauView, didMoveTo snapPoint: RideauSnapPoint) {
    
    }
    
    func rideauView(_ rideauView: RideauView, animatorsAlongsideMovingIn range: ResolvedSnapPointRange) -> [UIViewPropertyAnimator] {
        return []
    }
}

extension InfoController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
      
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
        let model = models[indexPath.item]
        
        cell.label.text = model
        
        return cell
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
}

