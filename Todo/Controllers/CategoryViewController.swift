//
//  CategoryViewController.swift
//  Todo
//
//  Created by Arie van Boxel on 11/10/2018.
//  Copyright © 2018 Arie van Boxel. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    var categories:Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    // This is called before performSeque is executed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Persist
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
    // MARK: - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                NSLog("## \(#function) r\(#line) - \(error.localizedDescription)")
            }
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // Create new Category
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        // Add a textfield
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new Category"
            textField = alertTextField
        }
        alert.addAction(action)
        // Presents a view controller modally.
        present(alert, animated: true, completion: nil)
    }
    

    
}
