//
//  SearchDataModel.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/14/24.
//

import Foundation

import Alamofire


final class SearchDataModel {
    static let shared = SearchDataModel()
    let display = 30
    var nowItem = ""
    var searchItem: [String] {
        get{
            
            return UserDefaults.standard.array(forKey: ShoppingID.searchItem) as? [String] ?? [String]()
        }set{
            UserDefaults.standard.setValue(newValue, forKey: ShoppingID.searchItem)
        }
    }
    var likeList: [String:Bool] {
        get{
            return UserDefaults.standard.dictionary(forKey: ShoppingID.likeDictionary) as? [String:Bool] ?? [String:Bool]()
        }set{
            UserDefaults.standard.setValue(newValue, forKey: ShoppingID.likeDictionary)
        }
    }//coll
    var shoppingData: SearchDataModel?
    

    private init() {}
//    func request<T: Decodable> (api: TMDBRequest , model: T.Type, complitionHandler: @escaping (T?, Error?) -> Void) {
//           AF.request(api.endPoint,
//                      method: api.method,
//                      parameters: api.parameter,
//                      encoding: URLEncoding(destination: .queryString) ,
//                      headers: api.header)
//           .validate(statusCode: 200..<500)
//           // 메타 타입의 값 활용
//           .responseDecodable(of: T.self) { response in
//               
//               print("STATUS: \(response.response?.statusCode ?? 0)")
//               
//               switch response.result {
//               case .success(let value):
//                   print("Success")
//                   //                dump(value.results)
//                   complitionHandler(value, nil)
//                   
//               case .failure(let error):
//                   print("Failed")
//                   print(error)
//                   complitionHandler( nil, error)
//               }
//           }
    func callNetwork<T: Decodable>(filterData: String, page: Int,type: T.Type,completionHander: @escaping (T?)->()){

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
            .responseDecodable(of: T.self) {respons in
                switch respons.result {
                case .success(let data):
                    completionHander(data)
                    
                case .failure(let error):
                    print(error)
                    completionHander(nil)
                }
                
            }
    }
    func appendSearchItem(_ item: String) {
        var befor = UserDefaults.standard.array(forKey: ShoppingID.searchItem) as? [String] ?? [String]()
        // TODO: 스페이스바를 눌러서 검색했을 때 스페이스바 제거해서 리스트에 저장하기 ㅠ
        // TODO: 변수 다시 선언해서 이쁘게 구현 고차함수 reduce활용
        let result: [Character] = Array(item)
        let result2 = result.filter{$0 != " "}
        var b = ""
        let _ = result2.map{ b += String($0)}

        //print(resultString)
        if let index = befor.firstIndex(of: b) {
            befor.remove(at: index)
        }
            befor.insert(b, at: 0)
        UserDefaults.standard.setValue(befor, forKey: ShoppingID.searchItem)
    }
    func removeSearchItem(_ itemIndex: Int) {
        var befor = UserDefaults.standard.array(forKey: ShoppingID.searchItem) as? [String] ?? [String]()
        befor.remove(at: itemIndex)
        UserDefaults.standard.setValue(befor, forKey: ShoppingID.searchItem)
    }
    
    func LikeListFunc(_ item: String){
        var befor = self.likeList
        guard befor[item] != nil else {
            befor[item] = true
            self.likeList = befor
            return
        }
        befor.removeValue(forKey: item)
        self.likeList = befor
        return
        
    }
    func reset() {
        UserDefaults.standard.setValue(nil, forKey: ShoppingID.searchItem)
        UserDefaults.standard.setValue(nil, forKey: ShoppingID.likeDictionary)
    }
    
}
