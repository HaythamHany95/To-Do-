//
//  Title.swift
//  To Do
//
//  Created by Haytham on 26/09/2023.
//

import Foundation
import RealmSwift

class Item: Object {
   @objc dynamic var title: String?
   @objc dynamic var checked: Bool = false

    let parent = LinkingObjects(fromType: Category.self, property: "items")
}
