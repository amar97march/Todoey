//
//  Category.swift
//  Todoey
//
//  Created by Amar Singh on 06/02/18.
//  Copyright © 2018 Amar Singh. All rights reserved.
//

import Foundation
import RealmSwift
class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var colorName : String = ""
    let items = List<Item>()
}
