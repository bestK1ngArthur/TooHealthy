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
        
    func getProductInfo(ean: String, storeID: String? = nil, success: ((String) ->())? = nil, failure: ((Error) -> ())? = nil) {
        let url = serverURL.appendingPathComponent("productInfo")
        var params: [String: Any] = [
            "ean": ean
        ]
        
        if let storeID = storeID {
            params["storeId"] = storeID
        }
        
        print("Send EAN: \(ean)")
        
        Alamofire.request(url, method: .get, parameters: params).responseJSON { response in
            print(response)
            success?("SUCCESS")
        }
        
//        Alamofire.request(url, method: .get, parameters: params).response { response in
//            print(response)
//        }
    }
    
    func getProductStores(location: CLLocation, success: (([ProductStore]) -> Void)? = nil, fail: ((Error) -> Void)? = nil) {
        print("Send location: \(location.coordinate.longitude), \(location.coordinate.latitude)")
    }
}
