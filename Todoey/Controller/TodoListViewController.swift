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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadData()
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
        
//        context.delete(tasksArray[indexPath.row])
//        tasksArray.remove(at: indexPath.row)
//
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

    func loadData() {
        let request : NSFetchRequest<Task> = Task.fetchRequest()
        do {
            tasksArray = try context.fetch(request)
        } catch {
            print("Error with loading data, \(error)")
        }
        
    }
    
}

