//
//  Category.swift
//  ListIt
//
//  Created by Jordan Ball on 10/17/19.
//  Copyright © 2019 Ball Web Development, LLC. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<ListItem>()
}
