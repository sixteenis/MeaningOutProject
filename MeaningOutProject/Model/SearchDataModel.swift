//
//  SearchDataModel.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/14/24.
//

import Foundation

import Alamofire
final class SearchDataModel {
    // TODO: 쇼핑(라이크) 카운팅 해주기
    static let shared = SearchDataModel()
    let display = 30
    var nowItem = ""
    var searchItem: [String] {
        get{
            return UserDefaults.standard.array(forKey: "searchItem") as? [String] ?? [String]()
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "searchItem")
        }
    }
    var likeList: [String] {
        get{
            return UserDefaults.standard.array(forKey: "like") as? [String] ?? [String]()
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "like")
        }
    }//coll
    var shoppingData: SearchDataModel?
    

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
                //self.hideLoadingIndicator()
                completionHander(respons.value)
//                switch respons.result{
//                case .success(let value):
//                    //self.succesNetWork(value)
//                    completionHander(value)
//                case .failure(let error):
//                    completionHander(nil)
////                    self.noDataView.isHidden = false
////                    self.noDataLabel.text = "네트워크 오류가 발생했습니다!"
//                    
//                }
            }
    }
    func appendSearchItem(_ item: String) {
        var befor = UserDefaults.standard.array(forKey: "searchItem") as? [String] ?? [String]()
        // TODO: 스페이스바를 눌러서 검색했을 때 스페이스바 제거해서 리스트에 저장하기 ㅠ
        let result: [Character] = Array(item)
        let result2 = result.filter{$0 != " "}
        var b = ""
        let _ = result2.map{ b += String($0)}

        //print(resultString)
        if let index = befor.firstIndex(of: b) {
            befor.remove(at: index)
        }
            befor.insert(b, at: 0)
        UserDefaults.standard.setValue(befor, forKey: "searchItem")
    }
    func removeSearchItem(_ itemIndex: Int) {
        var befor = UserDefaults.standard.array(forKey: "searchItem") as? [String] ?? [String]()
        befor.remove(at: itemIndex)
        UserDefaults.standard.setValue(befor, forKey: "searchItem")
    }
    
    func LikeListFunc(_ item: String){
        var befor = UserDefaults.standard.array(forKey: "like") as? [String] ?? [String]()
        if let index = befor.firstIndex(of: item) { // 원래 좋아요 눌러있던 값일 경우
            befor.remove(at: index)
            UserDefaults.standard.setValue(befor, forKey: "like")
            return
        }else{ // 좋아요가 안눌러저 있던 것 
            befor.append(item)
            UserDefaults.standard.setValue(befor, forKey: "like")
            return
        }
        
        
    }
    func reset() {
        UserDefaults.standard.setValue(nil, forKey: "searchItem")
        UserDefaults.standard.setValue(nil, forKey: "like")
    }
    
}
