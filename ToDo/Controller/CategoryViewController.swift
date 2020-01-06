//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Alan Silva on 30/12/19.
//  Copyright © 2019 Alan Silva. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    var categoryArray : Results<Category>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadCategories()
    
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "", message: "Add New Category", preferredStyle: .alert)
        
        var categoryTextField = UITextField()
        
        let btnAdd = UIAlertAction(title: "Add", style: .default) { (AlertAction) in
            
            if categoryTextField.text != "" {
                
                let newCategory = Category()
                newCategory.name = categoryTextField.text!
                
                self.save(category: newCategory)
                
            }
            
            self.tableView.reloadData()
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Type the new category"
            categoryTextField = textField
        }
        
        let btnCancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(btnCancel)
        alertController.addAction(btnAdd)
        
        self.present(alertController, animated: true)
        
    }
    
    //MARK: - DELEGATE AND DATASOURCE METHODS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.categoryArray?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = self.categoryArray?[indexPath.row].name ?? "Sem categorias adicionadas"
        
        cell.backgroundColor = UIColor.randomFlat()
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
    //MARK: - CRUD METHODS
    
    func save(category: Category){
        
        do {
            
            try realm.write {
                realm.add(category)
            }
            
        }catch{
            
            print("Error saving context, \(error)")
            
        }
        
        self.tableView.reloadData()
        
    }
    
    //MARK: - Load Data
    
    func loadCategories() {
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        super.updateModel(at: indexPath)
        
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Erro ao remover registro \(error)")
            }
            
            //tableView.reloadData()
        }
        
    }
    
    
}


