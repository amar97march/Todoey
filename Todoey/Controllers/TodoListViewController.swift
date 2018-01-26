//
//  ViewController.swift
//  Todoey
//
//  Created by Amar Singh on 23/01/18.
//  Copyright © 2018 Amar Singh. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

   
    var itemArray = [Item]()
    
   
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let newItem = Item()
        newItem.title = "Find Mike1"
        itemArray.append(newItem)
        
        let newItem1 = Item()
        newItem1.title = "Find Mike2"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Find Mike3"
        itemArray.append(newItem2)
        
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
    }

//Mark - TableView Methods

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for:indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
    }
    
    //MARK - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        
//        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
//
        tableView.deselectRow(at: indexPath, animated: true)
    }
  //MARK - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
         var itemName = UITextField()
        let alert = UIAlertController(title: "Add Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What happens whe the user presses the button.
            if (itemName.text! != ""){
                
                let newItem = Item()
                newItem.title = itemName.text!
            self.itemArray.append(newItem)
                
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

