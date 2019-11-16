//
//  ProfileViewController.swift
//  TooHealthy
//
//  Created by Artem Belkov on 15.11.2019.
//  Copyright © 2019 Artem Belkov. All rights reserved.
//

import UIKit
import WSTagsField

final class ProfileViewController: UITableViewController {
    
    @IBOutlet weak var alergicsView: WSTagsField!
    
    @IBOutlet weak var veganSwitch: UISwitch!
    @IBOutlet weak var glutenFreeSwitch: UISwitch!
    @IBOutlet weak var lactoseFreeSwitch: UISwitch!
    @IBOutlet weak var sugarFreeSwitch: UISwitch!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = .init()
        tableView.backgroundColor = .white
        
        setupAlergicView()
        showSettings()
    }

    func showSettings() {
        guard let settings = App.cache.userSettings else { return }
        
        alergicsView.removeTags()
        alergicsView.addTags(settings.alergicIngredients.map { WSTag($0) })
        
        veganSwitch.isOn = settings.vegan
        glutenFreeSwitch.isOn = settings.glutenFree
        lactoseFreeSwitch.isOn = settings.lactoseFree
        sugarFreeSwitch.isOn = settings.sugarFree
    }
    
    func setupAlergicView() {
        
        alergicsView.layoutMargins = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        alergicsView.contentInset = UIEdgeInsets(top: 24, left: 10, bottom: 24, right: 10)
        alergicsView.spaceBetweenLines = 20.0
        alergicsView.spaceBetweenTags = 10.0
        alergicsView.font = .systemFont(ofSize: 18.0)
        alergicsView.cornerRadius = 12
        alergicsView.backgroundColor = R.color.violetBackground()
        alergicsView.tintColor = R.color.aquamarineTint()
        alergicsView.textColor = .white
        alergicsView.fieldTextColor = R.color.text()
        alergicsView.selectedColor = R.color.aquamarineTint()
        alergicsView.selectedTextColor = .white
        alergicsView.delimiter = ","
        alergicsView.isDelimiterVisible = false
        alergicsView.placeholderColor = R.color.violetTint()
        alergicsView.placeholderAlwaysVisible = true
        alergicsView.placeholder = "Enter product"
        alergicsView.keyboardAppearance = .dark
        alergicsView.returnKeyType = .next
        alergicsView.acceptTagOption = .space
        alergicsView.onDidChangeHeightTo = { _, height in
            self.tableView.reloadData()
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let inredients = alergicsView.tags.map { $0.text }
        let settings = UserSettings(
            alergicIngredients: inredients,
            vegan: veganSwitch.isOn,
            glutenFree: glutenFreeSwitch.isOn,
            lactoseFree: lactoseFreeSwitch.isOn,
            sugarFree: sugarFreeSwitch.isOn
        )
        
        App.cache.updateUserSettins(settings)
    }
}

