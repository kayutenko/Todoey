//
//  ViewController.swift
//  Todoey
//
//  Created by kayutenko on 04/09/2019.
//  Copyright © 2019 kayutenko. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let arrayKey = "TodoListArray"
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Tasks.plist")
    
//    var tasksArray = [Task(title: "Go shopping"),
//                      Task(title: "Do the homework"),
//                      Task(title: "Find will"),
//                      Task(title: "Kill the demogorgone"),
//                      Task(title: "Help ell"),
//                      Task(title: "Dstroy the evil scientists")
//                      ]
    var tasksArray = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let tasks = defaults.array(forKey: arrayKey) as? [Task] {
//            tasksArray = tasks
//        }
        loadData()
    }
    
    //MARK - Table View Methods
    
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
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let task = tasksArray[indexPath.row]
        
        task.isDone = !task.isDone
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveData()
    }

    @IBAction func plusButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new task?", message: "", preferredStyle: .alert)
        
        alert.addTextField { (taskTextField) in
            taskTextField.placeholder = "Do the shopping..."
        }
        
        let action = UIAlertAction(title: "Add task", style: .default) { (action) in
            
            let task = Task(title: alert.textFields![0].text!)
            self.tasksArray.append(task)
            self.tableView.reloadData()
            self.saveData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(tasksArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("error occurred while writting the data, \(error)")
        }
    }
    
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                try tasksArray = decoder.decode([Task].self, from: data)
            } catch {
                print("Error while attempting to read data, \(error)")
            }
        }
    }
    
}

