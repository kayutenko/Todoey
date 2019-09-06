//
//  ViewController.swift
//  Todoey
//
//  Created by kayutenko on 04/09/2019.
//  Copyright © 2019 kayutenko. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var tasksArray = [Task]()
    var parentCategory : Category? {
        didSet {
            loadData()
        }
    }
    
    @IBOutlet var navigationBarLabel: UINavigationItem!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarLabel.title = parentCategory!.name
        
        
    }
    
    // MARK: - Table View Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = tasksArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell")
        
        cell?.textLabel!.text = task.title
        
        cell?.accessoryType = task.isDone ? .checkmark : .none
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasksArray.count
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let task = tasksArray[indexPath.row]
        
        task.isDone = !task.isDone
    
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveData()
    }

    @IBAction func plusButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new task?", message: "", preferredStyle: .alert)
        
        alert.addTextField { (taskTextField) in
            taskTextField.placeholder = "Do the shopping..."
        }
        
        let action = UIAlertAction(title: "Add task", style: .default) { (action) in
            
            let task = Task(context: self.context)
            task.title = alert.textFields![0].text!
            task.isDone = false
            task.parentCategory = self.parentCategory!
            
            self.tasksArray.append(task)
            
            self.saveData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        do {
            try self.context.save()
        } catch {
            print("Error with saving data, \(error)")
        }
        tableView.reloadData()
    }

    func loadData(with request : NSFetchRequest<Task> = Task.fetchRequest()) {
        
        let categoriesPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", parentCategory!.name!)
        
        var predicates = [categoriesPredicate]
        
        if let requestPredicate = request.predicate {
            predicates.append(requestPredicate)
        }
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        do {
            tasksArray = try context.fetch(request)
        } catch {
            print("Error with loading data, \(error)")
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete task") {(a, b, c) in
            print("task deleted")
            self.context.delete(self.tasksArray[indexPath.row])
            self.tasksArray.remove(at: indexPath.row)
            self.saveData()
        }
        
        let action2 = UIContextualAction(style: .normal, title: "edit task") {
            (action, tableView, isActive) in
            
            let alert = UIAlertController(title: "Edit task:", message: "", preferredStyle: .alert)
            let task = self.tasksArray[indexPath.row]
            
            alert.addTextField { (taskTextField) in
                taskTextField.text = task.title
            }
            
            let saveChangesAction = UIAlertAction(title: "Save changes", style: .default) { (action) in
                print("Changes accepted")
                task.title = alert.textFields![0].text!
                self.saveData()
            }
            
            let cancelChangesAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(saveChangesAction)
            alert.addAction(cancelChangesAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        let swipeAction = UISwipeActionsConfiguration(actions: [action, action2])
        
        return swipeAction
    }
    
    
    
}

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Task> = Task.fetchRequest()
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            loadData(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            loadData()
        }
    }
}
