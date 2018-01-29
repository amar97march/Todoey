//
//  ViewController.swift
//  Todoey
//
//  Created by Amar Singh on 23/01/18.
//  Copyright © 2018 Amar Singh. All rights reserved.

import UIKit
import CoreData
class TodoListViewController: UITableViewController{

   
    var itemArray = [Item]()
    @IBOutlet weak var searchBar: UISearchBar!
    
    //To access appDelegate func directly
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       //print(dataFilePath as Any)
        searchBar.delegate = self
        
        loadItems()
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
       // context.delete(itemArray[indexPath.row])
       // itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItem()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
  //MARK - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
         var itemName = UITextField()
        let alert = UIAlertController(title: "Add Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What happens whe the user presses the button.
            if (itemName.text! != ""){
                
                
                let newItem = Item(context: self.context)
                newItem.title = itemName.text!
                newItem.done = false
                self.itemArray.append(newItem)
                self.saveItem()
                }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            itemName = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItem(){
        
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
        print("Success")
        
    }
    
    //MARK : loaditems method to load array list from NSEncoder
    func loadItems (with request : NSFetchRequest<Item> = Item.fetchRequest()){
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
           itemArray = try context.fetch(request)
        }catch {
           print("Error fetching data from request. \(error)")
        }
         tableView.reloadData()
    }
    
    
}
//MARK: - Search bar method
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@",searchBar.text!)
        
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with : request)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
          
        }
    }
}
