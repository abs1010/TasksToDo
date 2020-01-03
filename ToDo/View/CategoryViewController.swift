//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Alan Silva on 30/12/19.
//  Copyright © 2019 Alan Silva. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    var categoryArray : Results<Category>?
    
    var colorsArray : [UIColor] = [.red, .systemPink, .orange, .black, .brown, .cyan, .green, .gray , .darkGray, .lightGray, .blue, .magenta, .purple]
    
    //Cria a instancia para o CoreData em context
    // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = self.categoryArray?[indexPath.row].name ?? "Sem categorias adicionadas"
        cell.backgroundColor = self.colorsArray[indexPath.row]
        
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
    
    
    func loadCategories() {
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
}
