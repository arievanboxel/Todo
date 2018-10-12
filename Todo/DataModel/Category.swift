//
//  Category.swift
//  Todo
//
//  Created by Arie van Boxel on 11/10/2018.
//  Copyright © 2018 Arie van Boxel. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
