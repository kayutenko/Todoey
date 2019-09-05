//
//  Item.swift
//  Todoey
//
//  Created by kayutenko on 04/09/2019.
//  Copyright © 2019 kayutenko. All rights reserved.
//

import Foundation

class Task : Codable {
     
    var title = ""
    var isDone = false
    
    init(title: String) {
        self.title = title
    }
    
}
