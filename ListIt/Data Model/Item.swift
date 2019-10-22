//
//  Item.swift
//  ListIt
//
//  Created by Jordan Ball on 10/17/19.
//  Copyright © 2019 Ball Web Development, LLC. All rights reserved.
//

import Foundation
import RealmSwift

class ListItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var dateCreated = Date()
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
