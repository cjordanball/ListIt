//
//  ViewController.swift
//  ListIt
//
//  Created by Jordan Ball on 10/8/19.
//  Copyright © 2019 Ball Web Development, LLC. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Play Viola"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemArray = defaults.array(forKey:"ToDoListArray") != nil ? defaults.array(forKey: "ToDoListArray") as! [String] : itemArray
    }

    //MARK: TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - TableView Delegate Mwethos
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        tableView.deselectRow(at: indexPath, animated: true)
        
        (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) ?
            (tableView.cellForRow(at: indexPath)?.accessoryType = .none) :
            (tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark)

    }
    //MARK - Add new items.
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {

        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen upon click
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func updateData() {
        print(itemArray)
    }
}
