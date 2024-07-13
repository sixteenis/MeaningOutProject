//
//  ShoopingRequest.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/28/24.
//

import Foundation
import Alamofire

enum ShoppingDataType: String, CaseIterable{
    case accuracy = "sim"
    case date = "date"
    case priceUp = "dsc"
    case priceDown = "asc"
    
    var url: String {
        return "https://openapi.naver.com/v1/search/shop.json"
    }
    var header: HTTPHeaders {
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.id,
            "X-Naver-Client-Secret": APIKey.Secret
        ]
        return header
    }
    // TODO: query, start는 인풋에서 값을 받아와야된다.
    func param(query: String, start: Int) -> Parameters {
        let parameters: Parameters = [
            "query": query,
            "sort": self.rawValue,
            "display": 30,
            "start": start
        ]
        return parameters
    }
}
