//
//  NetworkService.swift
//  TooHealthy
//
//  Created by Artem Belkov on 16.11.2019.
//  Copyright © 2019 Artem Belkov. All rights reserved.
//

import Alamofire
import CoreLocation

final class NetworkService {
    private let serverURL = URL(string: "https://healthyappjunction.herokuapp.com/")!
        
    func getProductInfo(ean: String, storeID: String? = nil, userSettings: UserSettings? = nil, success: ((Product) ->())? = nil, fail: ((Error?) -> ())? = nil) {
        let url = serverURL.appendingPathComponent("productInfo")
        var params: [String: Any] = [
            "ean": ean
        ]
        
        if let storeID = storeID {
            params["storeId"] = storeID
        }
        
        if let settings = userSettings {
//            let user: [String: Any] = [
//                "ingredients": settings.alergicIngredients,
//                "vegan": settings.vegan,
//                "lacto": settings.lactoseFree,
//                "gluten_free": settings.glutenFree,
//                "sugar_free": settings.sugarFree
//            ]
            
            let userJson =
"""
    {
        \"ingredients\": \(settings.alergicIngredients),
        \"vegan\": \(settings.vegan ? "true" : "false"),
        \"lacto\": \(settings.lactoseFree ? "true" : "false"),
        \"gluten_free\": \(settings.glutenFree ? "true" : "false"),
        \"sugar_free\": \(settings.sugarFree ? "true" : "false")
    }
"""
    
            params["user"] = userJson
        }
        
        print("Send EAN: \(ean)")
   
        Alamofire.request(url, method: .post, parameters: params).responseJSON { response in
            guard response.result.isSuccess else {
                fail?(nil)
                return
            }
            
            guard let json = response.result.value as? [String: Any],
                let productApi = json["product_api"] as? [String: Any],
                let productName = productApi["name"] as? String,
                let productEan = productApi["ean"] as? String,
                let productRating = json["rating"] as? Int,
                let rawMessages = json["warning_message"] as? [String: Any] else {
                fail?(nil)
                return
            }
            
            var messages: [String] = []
            rawMessages.keys.forEach { key in
                if let message = rawMessages[key] as? String, !message.isEmpty {
                    messages.append(message)
                }
            }
            
            let product = Product(name: productName, ean: productEan, rating: productRating, messages: messages)
            success?(product)
        }
    }
    
    func getProductStore(location: CLLocation, success: ((ProductStore) -> Void)? = nil, fail: ((Error?) -> Void)? = nil) {
        let url = serverURL.appendingPathComponent("getShops")
        let params: [String: Any] = [
            "lon": location.coordinate.longitude,
            "lan": location.coordinate.latitude
        ]

        print("Sending location: \(location.coordinate.longitude), \(location.coordinate.latitude)")
        
        Alamofire.request(url, method: .get, parameters: params).responseJSON { response in
            guard response.result.isSuccess else {
                fail?(nil)
                return
            }
            
            guard let array = response.result.value as? [Any],
                let json = array.first as? [String: Any],
                let raw = json["Message"] as? [String: Any],
                let storeID = raw["id"] as? String,
                let storeName = raw["name"] as? String,
                let storeAddress = raw["address"] as? String else {
                fail?(nil)
                return
            }
            
            let store = ProductStore(id: storeID, name: storeName, address: storeAddress)
            success?(store)
        }
    }
}
