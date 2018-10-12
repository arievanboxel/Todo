//
//  Item.swift
//  Todo
//
//  Created by Arie van Boxel on 11/10/2018.
//  Copyright © 2018 Arie van Boxel. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    // Inverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
