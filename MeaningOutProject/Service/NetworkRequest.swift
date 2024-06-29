//
//  ShoopingRequest.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/28/24.
//

import Foundation
import Alamofire
enum DataType{
    
    case shopping
    
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
    
    
}
