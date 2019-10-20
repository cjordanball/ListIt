//
//  ViewController.swift
//  ListIt
//
//  Created by Jordan Ball on 10/8/19.
//  Copyright © 2019 Ball Web Development, LLC. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var toDoItems: Results<ListItem>?
    
    var selectedCategory: Category? {
        didSet{
            loadItems(cat: selectedCategory!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    //MARK: TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "Create an item!"
        }
        return cell
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    //MARK - TableView Delegate Mwethos
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                if item.done == true {
                    try realm.write {
                        realm.delete(item)
                    }
                } else {
                    try realm.write {
                        item.done = !item.done
                    }
                }
            } catch {
                print("ERROR UPDATING \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items.
    
    @IBAction func addItem(_ sender: UIBarButtonItem){
        var textField = UITextField()

        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what will happen upon click
            if textField.text == "" {
                return
            }
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = ListItem()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("ERR: \(error)")
                }
            }
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
    
    func loadItems(cat: Category) {
        toDoItems = cat.items.sorted(byKeyPath: "title", ascending: false)
    }

//    private func updateData() {
//        print("itemArray")
//    }
}

//MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {
//
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText.lowercased()
        loadItems(cat: selectedCategory!)
        if searchText == "" {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            tableView.reloadData()
            return
        }
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.searchTextField.backgroundColor = UIColor.init(hue: 240/360, saturation: 0.5, brightness: 0.8, alpha: 0.2)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.searchTextField.backgroundColor = nil
        searchBar.text = ""
        if let selCat = selectedCategory {
            loadItems(cat: selCat)
        }
    }
}
