//
//  ViewController.swift
//  ToDo
//
//  Created by Alan Silva on 27/12/19.
//  Copyright © 2019 Alan Silva. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoViewController: SwipeTableViewController {
    
    var todoItems : Results<Item>?      
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }
    
    //DELEGATE AND DATASOURCE METHODS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        }
        else{
            cell.textLabel?.text = "Sem tarefas adicionadas"
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
            }
            catch{
                print("Erro ao gravar mudanca: \(error)")
            }
            
            tableView.reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //
    //        if let item = todoItems?[indexPath.row] {
    //            do{
    //                try realm.write {
    //                    realm.delete(item)
    //                }
    //            }
    //            catch{
    //                print("Erro ao remover registro : \(error)")
    //            }
    //
    //            tableView.reloadData()
    //        }
    //
    //        tableView.deselectRow(at: indexPath, animated: true)
    //
    //
    //    }
    
    
    //MARK: - ADD NEW ITEMS
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var tempText = UITextField()
        
        let alerta = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            if tempText.text != "" {
                
                if let currentCategory = self.selectedCategory {
                    
                    do{
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = tempText.text!
                            currentCategory.items.append(newItem)
                            newItem.dateCreated = Date()
                        }
                    }catch{
                        print("Erro ao gravar os dados na base realm")
                    }
                    
                }
                self.tableView.reloadData()
                
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
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    //MARK: - DELETE model manipulation methods
    
    override func updateModel(at indexPath: IndexPath) {
        
        super.updateModel(at: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(item)
                }
            }
            catch{
                print("Erro ao remover registro : \(error)")
            }
            
        }
        
    }
    
    
}


//MARK: - UISearch Bar methods

extension ToDoViewController : UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
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
