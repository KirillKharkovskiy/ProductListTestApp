//
//  ProductListModel.swift
//  listProductTest
//
//  Created by Кирилл Харьковский on 23.08.2021.
//

import Foundation

struct ProductListModel: Decodable{
    let image: String
    let price: Double
    let name: String
    let weight: Double
    let id: String
    let desc: String
}


