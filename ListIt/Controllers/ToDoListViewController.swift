//
//  ViewController.swift
//  ListIt
//
//  Created by Jordan Ball on 10/8/19.
//  Copyright © 2019 Ball Web Development, LLC. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var toDoItems: Results<ListItem>?
    
    var selectedCategory: Category? {
        didSet{
            loadItems(cat: selectedCategory!)
        }
    }

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Will Appear!")
        guard let colorHex = selectedCategory?.color else { fatalError("selectedCategory does not exist!") }
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller doew not exist") }
        
        title = selectedCategory?.name
        navBar.barTintColor = UIColor(hexString: colorHex)
        searchBar.barTintColor = navBar.barTintColor
        searchBar.searchTextField.backgroundColor = .white
        navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: UIColor(hexString: colorHex), isFlat: true)
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : navBar.tintColor]
    }


    //MARK: TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let item = toDoItems?[indexPath.row]
        cell.textLabel?.text = item?.title ?? "Create an item!"
        if let backColor =  UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: (CGFloat(Float(indexPath.row) / (2.0 * Float(toDoItems!.count))))) {
            cell.backgroundColor = backColor
            cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: backColor, isFlat: true)
            cell.accessoryType = item!.done ? .checkmark : .none
        }
        return cell
    }
    
    //MARK: - Nav Bar Setup
    
    func updateNavBar(withHexCode colourHexCode: String) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    //MARK - TableView Delegate Mwethos
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
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

    //MARK: - Delete Data from Swipe
    override func updateModelUponDelete(at indexPath: IndexPath) {
        super.updateModelUponDelete(at: indexPath)
        if let itemForDelete = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemForDelete)
                }
            } catch {
                print("ERROR: Unable to delete item. \(error)")
            }
        }
    }
        
}

//MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {
//
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText.last)
        let filteredText = searchText.filter { $0 != "\t"}
        searchBar.text = filteredText.lowercased()
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
        searchBar.searchTextField.backgroundColor = UIColor.init(hue: 0.0, saturation: 0.0, brightness: 0.8, alpha: 1.0)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.searchTextField.backgroundColor = .white
        searchBar.text = ""
        if let selCat = selectedCategory {
            loadItems(cat: selCat)
        }
    }
}
