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
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadItems()
        
        //        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
        //            itemArray = items
        //        }
        
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
        
        saveItems()
        
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
                
                self.saveItems()
                
                //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
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
    
    //MARK: - model manipulation methods
    
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        
        do {
            
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        }catch{
            print("Erro ao encoder item array, \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding items")
            }
            
        }
        
        
    }
    
}

