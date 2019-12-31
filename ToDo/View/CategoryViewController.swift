//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Alan Silva on 30/12/19.
//  Copyright © 2019 Alan Silva. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray : [Category] = []
    var colorsArray : [UIColor] = [.red, .systemPink, .orange, .black, .brown, .cyan, .green, .gray , .darkGray, .lightGray, .blue, .magenta, .purple]
    
    //Cria a instancia para o CoreData em context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadItems()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "", message: "Add New Category", preferredStyle: .alert)
        
        var categoryTextField = UITextField()
        
        let btnAdd = UIAlertAction(title: "Add", style: .default) { (AlertAction) in
            
            if categoryTextField.text != "" {
                
                let newCategory = Category(context: self.context)
                newCategory.name = categoryTextField.text
                
                self.categoryArray.append(newCategory)
                self.saveItems()
            
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
        
        return self.categoryArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = self.categoryArray[indexPath.row].name
        cell.backgroundColor = self.colorsArray[indexPath.row]
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //if segue.identifier == "goToItems" {
            
            let destinationVC = segue.destination as! ToDoViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categoryArray[indexPath.row]
                destinationVC.tempIndex = indexPath.row
            }
        
        //}
        
    }
    
    
    //MARK: - CRUD METHODS
    
    func saveItems(){
        
        do {
            
            try context.save()
            
        }catch{
            
            print("Error saving context, \(error)")
            
        }
        
        self.tableView.reloadData()
        
    }
    
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
            
        }catch{
            
            print("Error fetching data from context \(error)")
            
        }
        
        tableView.reloadData()
    }
    
}
