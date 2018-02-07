//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Amar Singh on 30/01/18.
//  Copyright © 2018 Amar Singh. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
//import SwipeCellKit
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categories : Results <Category>?
   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

          loadCategories()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
    }
    //MARK: - TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
      
        let item = categories?[indexPath.row]
        
        cell.textLabel?.text = item?.name ?? "No Category added yet"
        if let colorOfCell = item?.colorName {
            
        guard let categoryColor = UIColor(hexString: colorOfCell) else {fatalError()}

        cell.backgroundColor = categoryColor
        cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
       // cell.accessoryType = item. ? .checkmark : .none
        }
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
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
    }
    
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        
        var itemName = UITextField()
        let alert = UIAlertController(title: "Add Task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if (itemName.text! != "") {
                let newCategory = Category()
                newCategory.name = itemName.text!
                newCategory.colorName = UIColor.randomFlat.hexValue()
                //newItem.done = false
               // self.categories.append(newCategory)
                self.save(category: newCategory)
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category"
            itemName = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
   
    
    
    func save(category : Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
        print("Success")
        
    }
    
    func loadCategories (){
        categories = realm.objects(Category.self)
        
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        do {
//            categoryArray = try context.fetch(request)
//        }catch {
//            print("Error fetching data from request. \(error)")
//        }
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        if let categoryToDelete = self.categories?[indexPath.row] {
                            do {
                                try self.realm.write {
                                    self.realm.delete(categoryToDelete)
                                }
            
                            } catch{
                                print("Error deleting category, \(error)")
                            }
                            //tableView.reloadData()
                        }
    }

}

