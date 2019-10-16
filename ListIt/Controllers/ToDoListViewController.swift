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
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

  

        saveItems()
//        tableView.deselectRow(at: indexPath, animated: true)

        

    }
    //MARK - Add new items.
    
    @IBAction func addItem(_ sender: UIBarButtonItem){

        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen upon click
            let newItem = ListItem(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            self.saveItems()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        
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
            print("doing it")
            itemArray = try context.fetch(request)
            print(itemArray.count)
        } catch {
            print("FETCH ERR: \(error)")
        }
    }

    private func updateData() {
        print(itemArray)
    }
}

//MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText.lowercased()
        var resArray = [ListItem]()
        
        let searchTerm = searchText.lowercased()
               if searchBar.text == "" {
                   self.loadItems()
               } else {
                self.loadItems()
                   itemArray.forEach{
                       if $0.title!.lowercased().contains(searchTerm) {
                           resArray.append($0)
                       }
                   }
                   resArray.forEach{
                       print($0.title!)
                   }
                   itemArray = resArray
               }
                self.tableView.reloadData()
                
    }

//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//////        let request : NSFetchRequest<ListItem> = ListItem.fetchRequest()
//        var resArray = [ListItem]()
//        let searchTerm = searchBar.text?.lowercased()
//        if searchBar.text == "" {
//            print("inIf")
//            self.loadItems()
//        } else {
//            itemArray.forEach{
//                if $0.title!.lowercased().contains(searchTerm!) {
//                    resArray.append($0)
//                }
//            }
//            resArray.forEach{
//                print($0.title!)
//            }
//            itemArray = resArray
//        }
//        self.tableView.reloadData()
//    }
}
