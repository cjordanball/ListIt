//
//  Data.swift
//  ListIt
//
//  Created by Jordan Ball on 10/17/19.
//  Copyright © 2019 Ball Web Development, LLC. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
