//
//  ProductListRealmModel.swift
//  listProductTest
//
//  Created by Кирилл Харьковский on 25.08.2021.
//

import Foundation
import RealmSwift

class ProductListRealmModel: Object {
    @objc dynamic var imageUrl : String = ""
    @objc dynamic var price : Double = 0.0
    @objc dynamic var name : String = ""
    @objc dynamic var weight : Double = 0.0
    @objc dynamic var idProduct : String = ""
    @objc dynamic var desc : String = ""
    @objc dynamic var isSelected : Bool = false

}
