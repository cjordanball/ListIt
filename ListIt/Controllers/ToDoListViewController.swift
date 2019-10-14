//
//  ViewController.swift
//  ListIt
//
//  Created by Jordan Ball on 10/8/19.
//  Copyright © 2019 Ball Web Development, LLC. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [ListItem]()
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(("ListItems.plist"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
       
        loadItems()
    }


    //MARK: TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        item.done ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        return cell
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - TableView Delegate Mwethos
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = itemArray[indexPath.row]
        item.done = !item.done
        saveItems(itemArray)
        tableView.deselectRow(at: indexPath, animated: true)

        

    }
    //MARK - Add new items.
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {

        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen upon click
            let newItem = ListItem(textField.text!, false)
            self.itemArray.append(newItem)
            self.saveItems(self.itemArray)
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(_ items: [ListItem]) {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath!)
        } catch {
            print("ERROR: \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([ListItem].self, from: data)
            } catch {
                print(error)
            }
        }
    }
    
    private func updateData() {
        print(itemArray)
    }
}
