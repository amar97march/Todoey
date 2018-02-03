//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Amar Singh on 30/01/18.
//  Copyright © 2018 Amar Singh. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

          loadItems()
    }
    //MARK: - TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell",for:indexPath)
        
        let item = categoryArray[indexPath.row]
        
        cell.textLabel?.text = item.name
        
       // cell.accessoryType = item. ? .checkmark : .none
        
        
        return cell
    }
    
    //MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        // context.delete(itemArray[indexPath.row])
        // itemArray.remove(at: indexPath.row)
        
        //categoryArray[indexPath.row].done = !categoryArray[indexPath.row].done
         performSegue(withIdentifier: "goToItems", sender: self)
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        
        var itemName = UITextField()
        let alert = UIAlertController(title: "Add Task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if (itemName.text! != "") {
                let newItem = Category(context: self.context)
                newItem.name = itemName.text!
                //newItem.done = false
                self.categoryArray.append(newItem)
                self.saveItem()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category"
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
    
    func loadItems (with request : NSFetchRequest<Category> = Category.fetchRequest()){
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        }catch {
            print("Error fetching data from request. \(error)")
        }
        tableView.reloadData()
    }

}
