//
//  ShoppingNetworkManager.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/11/24.
//

import Foundation
import Alamofire

final class ShoppingNetworkManager {
    static let shard = ShoppingNetworkManager()
    private init() {}
    func callNetwork<T: Decodable>(query: String, start: Int ,data: ShoppingDataType,type: T.Type, completionHander: @escaping (T?)->()){
        let url = data.url
        let header: HTTPHeaders = data.header
        let getParam = data.param(query: query, start: start)
        let param: Parameters = getParam
        AF.request(url,method: .get,parameters: param, headers: header)
            .responseDecodable(of: T.self) {respons in
                switch respons.result {
                case .success(let data):
                    completionHander(data)
                    
                case .failure(let error):
                    completionHander(nil)
                }
                
            }
        
    }
}
