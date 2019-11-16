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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = .init()
        
        setupAlergicView()
    }

    func setupAlergicView() {
        
        alergicsView.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        alergicsView.contentInset = UIEdgeInsets(top: 24, left: 10, bottom: 24, right: 10)
        alergicsView.spaceBetweenLines = 5.0
        alergicsView.spaceBetweenTags = 10.0
        alergicsView.font = .systemFont(ofSize: 24.0)
        alergicsView.backgroundColor = R.color.backgroundGreen()
        alergicsView.tintColor = .green
        alergicsView.textColor = .black
        alergicsView.fieldTextColor = .blue
        alergicsView.selectedColor = .black
        alergicsView.selectedTextColor = .red
        alergicsView.delimiter = ","
        alergicsView.isDelimiterVisible = false
        alergicsView.placeholderColor = .green
        alergicsView.placeholderAlwaysVisible = true
        alergicsView.keyboardAppearance = .dark
        alergicsView.returnKeyType = .next
        alergicsView.acceptTagOption = .space

        // Events
        alergicsView.onDidAddTag = { field, tag in
            print("DidAddTag", tag.text)
        }

        alergicsView.onDidRemoveTag = { field, tag in
            print("DidRemoveTag", tag.text)
        }

        alergicsView.onDidChangeText = { _, text in
            print("DidChangeText")
        }

        alergicsView.onDidChangeHeightTo = { _, height in
            self.tableView.reloadData()
        }

        alergicsView.onValidateTag = { tag, tags in
            // custom validations, called before tag is added to tags list
            return tag.text != "#" && !tags.contains(where: { $0.text.uppercased() == tag.text.uppercased() })
        }
    }
}

