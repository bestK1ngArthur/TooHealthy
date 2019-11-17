//
//  Product.swift
//  TooHealthy
//
//  Created by Artem Belkov on 16.11.2019.
//  Copyright © 2019 Artem Belkov. All rights reserved.
//

import UIKit

struct Product {
    struct ProductAnalogue {
        let name: String
        let ean: String
        let rating: Int
        
        var ratingColor: UIColor? {
            if rating >= 5 {
                return R.color.greenTint()
            } else if rating == 4 {
                return R.color.aquamarineTint()
            } else if rating == 3 {
                return R.color.yellowTint()
            } else if rating == 2 {
                return R.color.orangeTint()
            } else {
                return R.color.roseTint()
            }
        }
        
        var ratingString: String {
            if rating >= 5 {
                return "😋"
            } else if rating == 4 {
                return "😀"
            } else if rating == 3 {
                return "🙂"
            } else if rating == 2 {
                return "😐"
            } else {
                return "☹️"
            }
        }
    }
    
    let name: String
    let ean: String
    let rating: Int
    let messages: [String]
    let price: Double?
    let package: String?
    let analogues: [ProductAnalogue]
    
    var ratingColor: UIColor? {
        if rating >= 5 {
            return R.color.greenTint()
        } else if rating == 4 {
            return R.color.aquamarineTint()
        } else if rating == 3 {
            return R.color.yellowTint()
        } else if rating == 2 {
            return R.color.orangeTint()
        } else {
            return R.color.roseTint()
        }
    }
    
    var ratingString: String {
        if rating >= 5 {
            return "😋 Healthy"
        } else if rating == 4 {
            return "😀 Quite healthy"
        } else if rating == 3 {
            return "🙂 Still healthy"
        } else if rating == 2 {
            return "😐 Normal"
        } else {
            return "☹️ Unhealthy"
        }
    }
}
