//
//  ViewController.swift
//  Todoey
//
//  Created by kayutenko on 04/09/2019.
//  Copyright © 2019 kayutenko. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemsArray = ["Learn Swift", "Build your own app", "become an iOS developper", "be happy!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK - Table View Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell")
        
        cell!.textLabel!.text = itemsArray[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
//        Add the check mark when the cell is tapped
        if cell?.accessoryType != .checkmark {
            cell?.accessoryType = .checkmark
        } else if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }


}

