//
//  CacheService.swift
//  TooHealthy
//
//  Created by Artem Belkov on 16.11.2019.
//  Copyright © 2019 Artem Belkov. All rights reserved.
//

import Foundation

final class CacheService {
    
    private let storeIDKey = "storeID"
    
    private var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    var storeID: String? {
        return defaults.string(forKey: storeIDKey)
    }
    
    func updateStoreID(_ storeID: String) {
        defaults.set(storeID, forKey: storeIDKey)
    }
}
