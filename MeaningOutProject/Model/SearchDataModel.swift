//
//  SearchDataModel.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/14/24.
//

import Foundation

final class SearchDataModel {
    static let shared = SearchDataModel()
    var searchItem: [String] {
        get{
            return UserDefaults.standard.array(forKey: "searchItem") as? [String] ?? [String]()
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "searchItem")
        }
    }
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
    private init() {}
}
