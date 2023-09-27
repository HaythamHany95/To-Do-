//
//  Category.swift
//  To Do
//
//  Created by Haytham on 26/09/2023.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title: String?
    
    let items = List<Item>()
}
