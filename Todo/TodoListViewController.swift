//
//  ViewController.swift
//  Todo
//
//  Created by Arie van Boxel on 10/10/2018.
//  Copyright © 2018 Arie van Boxel. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Een", "Twee", "Drie"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    // MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        // Hide gray selection
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

