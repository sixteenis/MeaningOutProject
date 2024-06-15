//
//  SearchDataModel.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/14/24.
//

import Foundation

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
    var shoppingData: SearchDataModel?
    

    private init() {}
    
    
    func appendSearchItem(_ item: String) {
        var befor = UserDefaults.standard.array(forKey: "searchItem") as? [String] ?? [String]()
        if let index = befor.firstIndex(of: item) {
            befor.remove(at: index)
        }
            befor.insert(item, at: 0)
        
        UserDefaults.standard.setValue(befor, forKey: "searchItem")
    }
    func removeSearchItem(_ itemIndex: Int) {
        var befor = UserDefaults.standard.array(forKey: "searchItem") as? [String] ?? [String]()
        //befor.append(item)
        befor.remove(at: itemIndex)
        UserDefaults.standard.setValue(befor, forKey: "searchItem")
    }
}
