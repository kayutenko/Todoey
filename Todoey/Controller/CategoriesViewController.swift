//
//  CategoriesViewController.swift
//  Todoey
//
//  Created by kayutenko on 05/09/2019.
//  Copyright © 2019 kayutenko. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UITableViewController {

    var categoriesArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }


    //MARK: - Table View delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath)
        let category = categoriesArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTasks", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTasks" {
            let destinationVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.parentCategory = self.categoriesArray[indexPath.row]
            }
        }
    }
    
    //MARK: - Data manipulation methods
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving data, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoriesArray = try context.fetch(request)
        } catch {
            print("Error loading data, \(error)")
        }
        tableView.reloadData()
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Shopping"
        }
        
        let addNewCategoryAction = UIAlertAction(title: "Add category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = alert.textFields![0].text!
            self.categoriesArray.append(newCategory)
            self.saveData()
        }
        
        alert.addAction(addNewCategoryAction)
        
        present(alert, animated: true, completion: nil)
    }
}
