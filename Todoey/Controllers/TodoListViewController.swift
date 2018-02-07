//
//  ViewController.swift
//  Todoey
//
//  Created by Amar Singh on 23/01/18.
//  Copyright © 2018 Amar Singh. All rights reserved.

import UIKit
import RealmSwift
import ChameleonFramework


class TodoListViewController: SwipeTableViewController{

   
    var toDoItems : Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    
    //To access appDelegate func directly
   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       //print(dataFilePath as Any)
        //searchBar.delegate = self
        
        //loadItems()
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        navigationItem.title = selectedCategory?.name
     
}

    
    func barColorChange (colorName hexColor : String){
        guard let navBar = navigationController?.navigationBar else { fatalError() }
        guard let navBarColor = UIColor(hexString: hexColor) else { fatalError() }
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor,returnFlat: true)
        searchBar.barTintColor = navBarColor
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.colorName {
            
            barColorChange(colorName: colorHex)
            
            }
          
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        barColorChange(colorName : "00bfff")
    }
    
//Mark - TableView Methods

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title
            
            if let color = HexColor(selectedCategory!.colorName)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(toDoItems!.count)) {
        cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: false)
            }
            
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
                if (itemName.text! != "") {
                    let newItem = Item()
                newItem.title = itemName.text!
                newItem.dateCreated = date
                currentCategory.items.append(newItem)
                    }
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
    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = self.toDoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemToDelete)
                }
                
            } catch{
                print("Error deleting category, \(error)")
            }
            //tableView.reloadData()
        }
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



