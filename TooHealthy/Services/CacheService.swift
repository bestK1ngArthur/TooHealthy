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
    
    private let userSettingsAlergicKey = "userSettingsAlergic"
    private let userSettingsVeganKey = "userSettingsVegan"
    private let userSettingsGlutenFreeKey = "userSettingsGlutenFree"
    private let userSettingsLactoseFreeKey = "userSettingsLactoseFree"
    private let userSettingsSugarFreeKey = "userSettingsSugarFree"

    private var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    var storeID: String? {
        return defaults.string(forKey: storeIDKey)
    }
    
    func updateStoreID(_ storeID: String) {
        defaults.set(storeID, forKey: storeIDKey)
    }
    
    var userSettings: UserSettings? {
        guard let alergic = defaults.array(forKey: userSettingsAlergicKey) as? [String] else {
            return nil
        }
        
        return UserSettings(
            alergicIngredients: alergic,
            vegan: defaults.bool(forKey: userSettingsVeganKey),
            glutenFree: defaults.bool(forKey: userSettingsGlutenFreeKey),
            lactoseFree: defaults.bool(forKey: userSettingsLactoseFreeKey),
            sugarFree: defaults.bool(forKey: userSettingsSugarFreeKey)
        )
    }
    
    func updateUserSettins(_ userSettings: UserSettings) {
        defaults.setValue(userSettings.alergicIngredients, forKey: userSettingsAlergicKey)
        defaults.set(userSettings.vegan, forKey: userSettingsVeganKey)
        defaults.set(userSettings.glutenFree, forKey: userSettingsGlutenFreeKey)
        defaults.set(userSettings.lactoseFree, forKey: userSettingsLactoseFreeKey)
        defaults.set(userSettings.sugarFree, forKey: userSettingsSugarFreeKey)
    }
}
