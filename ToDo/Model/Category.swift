//
//  Category.swift
//  ToDo
//
//  Created by Alan Silva on 02/01/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
   @objc dynamic var name: String = ""
    
    //criando a relacao
    let items = List<Item>()
    
}
