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
    var inputPlusPage: Obsearvable<Void?> = Obsearvable(nil)
    var inputfilterSelect: Obsearvable<Int?> = Obsearvable(nil)
    
    var outputList: Obsearvable<[Item]> = Obsearvable([Item]())
    var outputTotal: Obsearvable<Int> = Obsearvable(0)
    var outputPage = Obsearvable(0)
    var outputFilterIndex = Obsearvable(0)
    init() {
        inputLoadView.loadBind { item in
            guard let item = item else {return}
            self.model.nowItem = item
            self.model.start = 1
            self.model.filterType = .accuracy
            self.getNewItems()
        }
        inputPlusPage.bind { _ in
            self.model.start += 30
            self.getNewItems()
        }
        inputfilterSelect.bind { index in
            guard let index = index else { return }
            let filter = ShoppingDataType.allCases[index]
            if filter != self.model.filterType {
                self.model.filterType = filter
                self.getNewItems()
            }
        }
    }
    
    private func getNewItems() {
        ShoppingNetworkManager.shard.callNetwork(query: model.nowItem, start: model.start, data: model.filterType ?? .priceDown, type: ShoppingModel.self) { data in
            guard let data = data else { return }
            guard let item = data.items else { return }
            if self.model.start == 1 {
                self.outputList.value = item
            }else{
                self.outputList.value.append(contentsOf: item)
            }
            self.outputPage.value = data.start!
            self.outputTotal.value = data.total!
        }
    }
    
    
}
