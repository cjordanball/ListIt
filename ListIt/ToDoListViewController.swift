//
//  ViewController.swift
//  ListIt
//
//  Created by Jordan Ball on 10/8/19.
//  Copyright © 2019 Ball Web Development, LLC. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    let itemArray = ["Play Viola", "Dig Pit", "Learn Swift(ly)", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

}
