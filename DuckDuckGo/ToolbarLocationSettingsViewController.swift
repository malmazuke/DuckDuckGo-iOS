//
//  ToolbarLocationSettingsViewController.swift
//  DuckDuckGo
//
//  Copyright © 2023 DuckDuckGo. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import Core

class ToolbarLocationSettingsViewController: UITableViewController {
    
    private lazy var appSettings = AppDependencyProvider.shared.appSettings
    
    private lazy var availableLocations = ToolbarLocation.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyTheme(ThemeManager.shared.currentTheme)
    }
    
}

// MARK: - UITableViewDataSource
extension ToolbarLocationSettingsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableLocations.count
    }
    
}

// MARK: - UITableViewDelegate
extension ToolbarLocationSettingsViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "ToolbarLocationCell", for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ToolbarLocationCell else {
            fatalError("Expected ToolbarLocationCell")
        }
        
        let theme = ThemeManager.shared.currentTheme
        cell.backgroundColor = theme.tableCellBackgroundColor
        cell.setHighlightedStateBackgroundColor(theme.tableCellHighlightedBackgroundColor)
        
        // Checkmark color
        cell.tintColor = theme.buttonTintColor
        cell.nameLabel.textColor = theme.tableCellTextColor
        
        let locationType = availableLocations[indexPath.row]
        cell.name = locationType.descriptionText

        cell.accessoryType = locationType == appSettings.currentToolbarLocation ? .checkmark : .none
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let type = availableLocations[indexPath.row]
        appSettings.currentToolbarLocation = type

        tableView.reloadData()
    }
    
}

// MARK: - Themable
extension ToolbarLocationSettingsViewController: Themable {

    func decorate(with theme: Theme) {
        
        tableView.backgroundColor = theme.backgroundColor
        tableView.separatorColor = theme.tableCellSeparatorColor
        
        tableView.reloadData()
    }
}

// MARK: - ToolbarLocationCell
class ToolbarLocationCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var name: String? {
        get {
            return nameLabel.text
        }
        set {
            nameLabel.text = newValue
        }
    }
    
}
