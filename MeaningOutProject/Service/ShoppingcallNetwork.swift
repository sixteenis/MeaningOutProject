//
//  Shopping.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/29/24.
//

import Foundation
import Alamofire
class ShoppingcallNetwork {
    let shard = ShoppingcallNetwork()
    let 
    private init() {}
    
    func callNetwork(filterData: String, page: Int, completionHander: @escaping (ShoppingModel?)->()){

        let url = "https://openapi.naver.com/v1/search/shop.json"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.id,
            "X-Naver-Client-Secret": APIKey.Secret
        ]
        let param: Parameters = [
            "query": self.nowItem,
            "sort": filterData,
            "display": self.display,
            "start": page,
        ]
        AF.request(url,method: .get,parameters: param, headers: header)
            .responseDecodable(of: ShoppingModel.self) {respons in
                completionHander(respons.value)
            }
    }
}
