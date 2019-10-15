//
//  ViewController.swift
//  ListIt
//
//  Created by Jordan Ball on 10/8/19.
//  Copyright © 2019 Ball Web Development, LLC. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [ListItem]()
    
    let defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
            let newItem = ListItem(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
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
        
        do {
            try context.save()
        } catch {
            print("ERR: \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func loadItems() {
        let request: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("FETCH ERR: \(error)")
        }
    }
    
    private func updateData() {
        print(itemArray)
    }
}
