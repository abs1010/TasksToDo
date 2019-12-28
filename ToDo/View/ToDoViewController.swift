//
//  ViewController.swift
//  ToDo
//
//  Created by Alan Silva on 27/12/19.
//  Copyright © 2019 Alan Silva. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var itemArray : [Item] = []
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let newItem = Item()
        newItem.title = "Find Mike"
        self.itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        self.itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        self.itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
            
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK: - ADD NEW ITEMS
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var tempText = UITextField()
        
        let alerta = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            if tempText.text != "" {
                
                let newItem = Item()
                newItem.title = tempText.text!
                
                self.itemArray.append(newItem)
                
                self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                
            }
            
            self.tableView.reloadData()
        }
        
        alerta.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Digite novo item"
            
            tempText = alertTextField
            
        }
        
        alerta.addAction(action)
        
        present(alerta, animated: true, completion: nil)
    }
    
    
}

