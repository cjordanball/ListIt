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
    
    var selectedCategory: Category? {
        didSet{
            loadItems(cat: selectedCategory!)
        }
    }
                             
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what will happen upon click
            if textField.text == "" {
                return
            }
            let newItem = ListItem(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
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
    
    func loadItems(cat: Category, with request: NSFetchRequest<ListItem> = ListItem.fetchRequest()) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", cat.name!)
        let searchPredicate = request.predicate
        if searchPredicate != nil {
            print("inIF")
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, searchPredicate!])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
        do {
            itemArray = try context.fetch(request)
            self.tableView.reloadData()
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
        if searchText == "" {
            loadItems(cat: selectedCategory!)
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            return
        }

        let request: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        self.loadItems(cat: selectedCategory!, with: request)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        SearchBoxColor = searchBar.searchTextField.backgroundColor!
        
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
