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
            params["user"] = [
                "ingredients": settings.alergicIngredients,
                "vegan": settings.vegan,
                "lacto": settings.lactoseFree,
                "gluten_free": settings.glutenFree,
                "sugar_free": settings.sugarFree
            ]
        }
        
        print("Send EAN: \(ean)")
        
        Alamofire.request(url, method: .post, parameters: params).responseJSON { response in
            guard response.result.isSuccess else {
                fail?(nil)
                return
            }
            
            guard let json = response.result.value as? [String: Any],
                let productName = json["name"] as? String,
                let productEan = json["ean"] as? String else {
                fail?(nil)
                return
            }
            
            let product = Product(name: productName, ean: productEan)
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
