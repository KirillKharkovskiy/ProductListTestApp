//
//  ApiServise.swift
//  listProductTest
//
//  Created by Кирилл Харьковский on 23.08.2021.
//

import Foundation
import Alamofire

enum errorRequest {
    
}
// MARK:- API Manager Singleton
class ApiServise {
    // MARK:- SingleTon Structure
    public static let shared = ApiServise()
    private init(){}
    
    // MARK:- Properties
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    //MARK: - Main Controller
    public func  fetchProductList(completion: @escaping([ProductListModel]?) -> Void) {
        let request = AF.request(URLs.main, method: .get)
        request.responseDecodable (of: [ProductListModel].self, decoder: self.decoder) { response in
            print("debug: ",response.debugDescription)
            switch response.result {
            case .success(let productList):
                completion(productList)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
      
        }
    }

