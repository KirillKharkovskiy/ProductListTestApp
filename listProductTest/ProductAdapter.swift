//
//  ProductAdapter.swift
//  listProductTest
//
//  Created by Кирилл Харьковский on 24.08.2021.
//

import Foundation
import UIKit
import RealmSwift

class ProductAdapter {
    
    private var productListApi = [ProductListModel]()
    
    // получение productList
    public func getProductList(completion: @escaping( [Product]) -> Void ) {
        guard let realm = try? Realm() else { return }
        let productListRealm = realm.objects(ProductListRealmModel.self)
        
        
        if productListRealm.isEmpty {
            var productArray = [Product]()
            ApiServise.shared.fetchProductList { [weak self] data in
                
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    guard let data = data else {return}
                    self.productListApi = data
                    
                    data.forEach {
                        let product = Product(imageUrl: $0.image, price: $0.price, name: $0.name, weight: $0.weight, id: $0.id, desc: $0.desc, isSelected: false)
                        productArray.append(product)
                    }
                    completion(productArray)
                    guard let realm = try? Realm() else { return }
                    let productListRealm = realm.objects(ProductListRealmModel.self)
                    
                    if productListRealm.isEmpty{
                        
                        guard let realm = try? Realm() else { return }
                        
                        try! realm.write {
                            data.forEach {
                                let productRealm = ProductListRealmModel()
                                productRealm.imageUrl = $0.image
                                productRealm.price = $0.price
                                productRealm.name  = $0.name
                                productRealm.weight = $0.weight
                                productRealm.idProduct = $0.id
                                productRealm.desc = $0.desc
                                productRealm.isSelected = false
                                realm.add(productRealm)
                            }
                        }
                    }
                }
            }
            
        } else {
            newItems()
            var productArray = [Product]()
            productListRealm.forEach {
                let product = Product(imageUrl: $0.imageUrl, price: $0.price, name: $0.name, weight: $0.weight, id: $0.idProduct, desc: $0.desc, isSelected: $0.isSelected)
                productArray.append(product)
            }
            completion(productArray)
            
        }
        
        
        
    }
    
    // получение избранных
    public func getFavsProductList(completion: @escaping( [Product]) -> Void ) {
        guard let realm = try? Realm() else { return }
        let productRealm = realm.objects(ProductListRealmModel.self).filter("isSelected == true")
        
        var productArray = [Product]()
        productRealm.forEach {
            let product = Product(imageUrl: $0.imageUrl, price: $0.price, name: $0.name, weight: $0.weight, id: $0.idProduct, desc: $0.desc, isSelected: $0.isSelected)
            productArray.append(product)
        }
        
        completion(productArray)
    }
    
    // функция которая сверяет старые данные с новыми
    private func newItems() {
        
        fetchProductList()
        
        guard let realm = try? Realm() else { return }
        let productListRealm = realm.objects(ProductListRealmModel.self)
        
        var state = false
        
        
        productListApi.forEach { item in
            
            
            let index = productListRealm.firstIndex(where: {$0.idProduct == item.id})
            if index == nil {
                state = true
            }
            
            
            // если state == true значит такого элемента нет в базе и мы его добавляем
            if state {
                guard let realm = try? Realm() else { return }
                try! realm.write {
                    let productRealm = ProductListRealmModel()
                    productRealm.imageUrl = item.image
                    productRealm.price = item.price
                    productRealm.name = item.name
                    productRealm.weight = item.weight
                    productRealm.idProduct = item.id
                    productRealm.desc = item.desc
                    productRealm.isSelected = false
                    realm.add(productRealm)
                }
            }
        }
        
        
        
    }
    
    private func selectedProduct (_ id: String) -> ProductListRealmModel {
        guard let realm = try? Realm() else { return ProductListRealmModel() }
        let productRealm = realm.objects(ProductListRealmModel.self)
        guard let index = productRealm.firstIndex( where: {$0.idProduct == id }) else { return ProductListRealmModel()}
        return  productRealm[index]
    }
    
    // занесения продукта в избранное
    
    private func addFavourites(_ id: String) {
        
        guard let realm = try? Realm() else { return }
        let selectedProduct = selectedProduct(id)
        try! realm.write {
            selectedProduct.isSelected = true
        }
    }
    //удаление из избранного 
    private func removeProductFromFavs(_ id: String){
        guard let realm = try? Realm() else { return }
        let selectedProduct = selectedProduct(id)
        try! realm.write {
            selectedProduct.isSelected = false
        }
    }
    
    public func tapLike(_ id: String) {
        let selectedProduct = selectedProduct(id)
        if selectedProduct.isSelected {
            removeProductFromFavs(id)
        } else {
            addFavourites(id)
        }
    }
    
    // api request
    private func fetchProductList() {
        ApiServise.shared.fetchProductList { [weak self] data in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                guard let data = data else {return}
                self.productListApi = data
                
                
                guard let realm = try? Realm() else { return }
                let productListRealm = realm.objects(ProductListRealmModel.self)
                
                if productListRealm.isEmpty{
                    
                    guard let realm = try? Realm() else { return }
                    
                    try! realm.write {
                        data.forEach {
                            let productRealm = ProductListRealmModel()
                            productRealm.imageUrl = $0.image
                            productRealm.price = $0.price
                            productRealm.name  = $0.name
                            productRealm.weight = $0.weight
                            productRealm.idProduct = $0.id
                            productRealm.desc = $0.desc
                            productRealm.isSelected = false
                            realm.add(productRealm)
                        }
                        
                    }
                    
                }
                
            }
            
        }
    }
}
