//
//  ListItem.swift
//  ListIt
//
//  Created by Jordan Ball on 10/14/19.
//  Copyright © 2019 Ball Web Development, LLC. All rights reserved.
//

import Foundation

class ListItem {
    var title: String
    var done: Bool
    
    init (_ thisTitle: String, _ thisDone: Bool) {
        self.title = thisTitle
        self.done = thisDone
    }
}
