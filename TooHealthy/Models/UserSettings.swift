//
//  UserSettings.swift
//  TooHealthy
//
//  Created by Artem Belkov on 16.11.2019.
//  Copyright © 2019 Artem Belkov. All rights reserved.
//

import Foundation

struct UserSettings: Codable {
    let alergicIngredients: [String]
    let vegan: Bool
    let glutenFree: Bool
    let lactoseFree: Bool
    let sugarFree: Bool
}
