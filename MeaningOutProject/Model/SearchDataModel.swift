//
//  SearchDataModel.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/14/24.
//

import Foundation

import Alamofire


final class SearchDataModel {
    let display = 30
    var total = 1
    var start = 1
    var nowItem = ""
    var filterType: ShoppingDataType = .accuracy {
        didSet{
            self.start = 1
        }
    }
    var shoppingList: [Item] = [Item]()
    // MARK: - 검색 기록 저장 부분 ㅇㅇ
    var searchItem: [String] {
        get{
            return UserDefaults.standard.array(forKey: ShoppingID.searchItem) as? [String] ?? [String]()
        }set{
            UserDefaults.standard.setValue(newValue, forKey: ShoppingID.searchItem)
        }
    }
    
    // MARK: - 여기를 램으로 진행합시다!
    var likeList: [String:Bool] {
        get{
            return UserDefaults.standard.dictionary(forKey: ShoppingID.likeDictionary) as? [String:Bool] ?? [String:Bool]()
        }set{
            UserDefaults.standard.setValue(newValue, forKey: ShoppingID.likeDictionary)
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
