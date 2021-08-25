//
//  ProductListViewModel.swift
//  listProductTest
//
//  Created by Кирилл Харьковский on 23.08.2021.
//

import Foundation

struct ProductListViewModel {
    //MARK: - Model
    public let productList: Product
    init(_ productList: Product ) {
        self.productList = productList
    }
    
    //MARK: - Properties
    var image: String {
        return productList.imageUrl
    }
    
    var price: Double {
        return productList.price
    }
    var name: String {
        return productList.name
    }
    var weight: Double {
        return productList.weight
    }
    var id: String {
        return productList.id
    }
    var desc: String {
        return productList.desc
    }
    var isSelect: Bool {
        return productList.isSelected
    }
}
