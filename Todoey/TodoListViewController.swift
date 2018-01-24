//
//  ViewController.swift
//  Todoey
//
//  Created by Amar Singh on 23/01/18.
//  Copyright © 2018 Amar Singh. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

   
    var itemArray = ["Find Mike","Buy Eggs","Destroy Demogorgon"]
   
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
            itemArray = items
        }
    }

//Mark - TableView Methods

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for:indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
  //MARK - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
         var itemName = UITextField()
        let alert = UIAlertController(title: "Add Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What happens whe the user presses the button.
            if (itemName.text! != ""){
            self.itemArray.append(itemName.text!)
                
                self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                self.tableView.reloadData()
                print("Success")}
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            itemName = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}

