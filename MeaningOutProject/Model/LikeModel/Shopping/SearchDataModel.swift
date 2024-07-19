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
    @ShoppingDefault(key: "searchItem", defaultValue: [String](), storage: .standard)
    var searchItem: [String]
    

    func appendSearchItem(_ item: String) {
        var befor = self.searchItem
        
        if let index = befor.firstIndex(of: item) {
            befor.remove(at: index)
        }
        befor.insert(item, at: 0)
        self.searchItem = befor
    }
    
    func removeSearchItem(_ itemIndex: Int) {
        var befor = self.searchItem
        befor.remove(at: itemIndex)
        self.searchItem = befor
    }
    
    
}
