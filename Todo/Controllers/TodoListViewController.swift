//
//  ViewController.swift
//  Todo
//
//  Created by Arie van Boxel on 10/10/2018.
//  Copyright © 2018 Arie van Boxel. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    let realm = try! Realm()
    var todoItems: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        
        guard let colorHex = selectedCategory?.backgroundColor else { return }
        
        updateNavBar(withHexCode: colorHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    // MARK: - NavBar Setup Methods
    func updateNavBar(withHexCode colorHexCode: String) {
        guard let navBar = navigationController?.navigationBar else { return }
        guard let navBarColor = UIColor(hexString: colorHexCode) else { return }
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(backgroundColor: navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: navBar.tintColor]
        searchBar.barTintColor = navBarColor
    }

    // MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added Yet"
        }
        
        if let currentCategory = self.selectedCategory, let categoryBackgroundColor = currentCategory.backgroundColor {
            let baseColor = UIColor(hexString: categoryBackgroundColor)
            if let backgroundColor = baseColor?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = backgroundColor
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor: backgroundColor, returnFlat: true)
            }
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                     item.done = !item.done
                }
                tableView.reloadData()
            } catch {
                NSLog("## \(#function) r\(#line) - \(error.localizedDescription)")
            }
        }

        // Hide gray selection
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                NSLog("## \(#function) r\(#line) - \(error.localizedDescription)")
            }
        }
        
    }

    
    // MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() // Create scoped utility variable
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let text = textField.text {
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = text
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                        self.tableView.reloadData()
                    } catch {
                        NSLog("## \(#function) r\(#line) -  Could not save item: \(error.localizedDescription)")
                    }
                }

            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
}

// MARK: - SearchBarDelegate
extension TodoListViewController:UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            // Hide keyboard and flickering cursor
            // (Be shure to be inside the main thread)
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }

}

