//
//  NetworkService.swift
//  TooHealthy
//
//  Created by Artem Belkov on 16.11.2019.
//  Copyright © 2019 Artem Belkov. All rights reserved.
//

import Alamofire

class NetworkService {
    private let serverURL = URL(string: "https://healthyappjunction.herokuapp.com/")!
    
    func productInfo(code: String, success: ((String) ->())? = nil, failure: ((Error) -> ())? = nil) {
        let url = serverURL.appendingPathComponent("productInfo")
        let params: [String: Any] = [
            "ean": code
        ]
        
        Alamofire.request(url, method: .get, parameters: params).responseJSON { response in
            print(response)
        }
    }
}
