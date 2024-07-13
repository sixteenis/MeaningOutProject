//
//  SearchResultViewModel.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/13/24.
//

import Foundation

final class SearchResultViewModel {
    let model = SearchDataModel()
    
    var inputLoadView: Obsearvable<String?> = Obsearvable(nil)
    var inputPlusPage = Obsearvable(0)
    
    var outputList: Obsearvable<[Item]> = Obsearvable([Item]())
    var outputTotal: Obsearvable<Int> = Obsearvable(0)
    var outputPage = Obsearvable(0)
    init() {
        inputLoadView.loadBind { item in
            guard let item = item else {return}
            self.model.nowItem = item
            self.model.start = 1
            self.getNewItems()
        }
        inputPlusPage.bind { page in
            self.model.start += page
            self.outputList.value = self.model.shoppingList
            self.outputPage.value = self.model.start
        }
    }
    
    private func getNewItems() {
        ShoppingNetworkManager.shard.callNetwork(query: model.nowItem, start: 1, data: model.filterType, type: ShoppingModel.self) { data in
            guard let data = data else { return }
            guard let item = data.items else { return }
            self.outputList.value = item
            self.outputPage.value = data.start!
            self.outputTotal.value = data.total!
        }
    }
    
    
}
