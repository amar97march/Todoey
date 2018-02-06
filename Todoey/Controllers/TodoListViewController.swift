//
//  ViewController.swift
//  Todoey
//
//  Created by Amar Singh on 23/01/18.
//  Copyright © 2018 Amar Singh. All rights reserved.

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{

   
    var toDoItems : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //To access appDelegate func directly
   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       //print(dataFilePath as Any)
        //searchBar.delegate = self
        
        //loadItems()
    }

//Mark - TableView Methods

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for:indexPath)
        
        if let item = toDoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No items added"
        }
        
        
        return cell
    }
    
    //MARK - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row]{
            do {
            try realm.write {
                //realm.delete(item)
                
                item.done = !item.done
            }
            }catch{
                print("Error saving done status, \(error)")
            }
            
        }
        tableView.reloadData()
        //print(itemArray[indexPath.row])
       // context.delete(itemArray[indexPath.row])
       // itemArray.remove(at: indexPath.row)
        
       // toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done
       // saveItem()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
  //MARK - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
         var itemName = UITextField()
        let alert = UIAlertController(title: "Add Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What happens whe the user presses the button.
            if let currentCategory = self.selectedCategory{
                do {
                try self.realm.write {
                let date = Date()
                    //let formatter = DateFormatter()
                
               // formatter.dateFormat = "ddMMyyyy"
                let newItem = Item()
                newItem.title = itemName.text!
                newItem.dateCreated = date
                currentCategory.items.append(newItem)
                
//                    self.saveItem()
                    
                    }
                }catch{
                    print("Error saving new items \(error)")
                }
                }
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            itemName = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
//    func saveItem(){
//
//        do{
//            realm.write {
//                realm.add(<#T##object: Object##Object#>)
//            }
//        }catch{
//            print("Error saving context \(error)")
//        }
//
//        self.tableView.reloadData()
//        print("Success")
//
//    }
    
    //MARK : loaditems method to load array list from NSEncoder
    func loadItems (){
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
      
         tableView.reloadData()
    }
    
    
}
//MARK: - Search bar method
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            //main thread
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}

