//
//  CategoryViewController.swift
//  ListIt
//
//  Created by Jordan Ball on 10/16/19.
//  Copyright © 2019 Ball Web Development, LLC. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categorArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    }

    // MARK: - TableView DataSource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categorArray?[indexPath.row].name ?? "Create a category!"
        cell.backgroundColor = UIColor(hexString: categorArray?[indexPath.row].color ?? "1D98BF6")
        cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: cell.backgroundColor, isFlat: true)
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let navBar = navigationController?.navigationBar else {
            fatalError("No Navigation Controller Available")
        }
        navBar.topItem?.title = "Categories"
        navBar.barTintColor = UIColor(hexString: "1D98F6")
        navBar.tintColor = UIColor.flatWhite()
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.flatWhite()]
    }



    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categorArray?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("ERR: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        categorArray = realm.objects(Category.self)
    }
    
    //MARK: - Delete Data from Swipe
    override func updateModelUponDelete(at indexPath: IndexPath) {
        super.updateModelUponDelete(at: indexPath)
        if let catForDelete = categorArray?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(catForDelete)
                }
            } catch {
                print("ERROR: Unable to delete. \(error)")
            }
        }
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what happens upon click
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            if newCategory.name == "" {
                return
            }
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
