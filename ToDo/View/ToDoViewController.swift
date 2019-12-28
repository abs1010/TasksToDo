//
//  ViewController.swift
//  ToDo
//
//  Created by Alan Silva on 27/12/19.
//  Copyright © 2019 Alan Silva. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
            itemArray = items
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ToDoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = self.itemArray[indexPath.row]
        cell.detailTextLabel?.text = String(indexPath.row)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        }
        else {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
        
    }
    
    
    //MARK: - ADD NEW ITEMS
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var tempText = UITextField()
        
        let alerta = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            if tempText.text != "" {
                self.itemArray.append(tempText.text!)
                
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

