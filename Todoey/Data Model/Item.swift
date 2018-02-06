//
//  Item.swift
//  Todoey
//
//  Created by Amar Singh on 06/02/18.
//  Copyright © 2018 Amar Singh. All rights reserved.
//

import Foundation
import RealmSwift
class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
