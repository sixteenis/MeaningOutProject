//
//  SearchResultViewModel.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/13/24.
//

import Foundation

final class SearchResultViewModel {
    private let model = SearchDataModel()
    private let likeModel = LikeRepository.shard
    var inputLoadView: Obsearvable<String?> = Obsearvable(nil)
    var inputPlusPage: Obsearvable<Void?> = Obsearvable(nil)
    var inputfilterSelect: Obsearvable<Int?> = Obsearvable(nil)
    var inputAppendLike: Obsearvable<(Item?,Folder?,IndexPath?)> = Obsearvable((nil,nil,nil))
    
    private(set) var outputList: Obsearvable<[Item]> = Obsearvable([Item]())
    private(set) var outputTotal: Obsearvable<Int> = Obsearvable(0)
    private(set) var outputPage = Obsearvable(0)
    private(set) var outputFilterIndex = Obsearvable(0)
    
    private(set) var outputFolder = Obsearvable([Folder]())
    private(set) var outputLikeList = Obsearvable([String]())
    private(set) var outputloadIndex: Obsearvable<IndexPath?> = Obsearvable(nil)
    
    init() {
        inputLoadView.bind { item in
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
        inputAppendLike.bind { item, folder, index in
            guard let item = item else { return }
            let newItem = LikeList(productId: item.productId, title: item.title, image: item.image, lprice: item.lprice, mallName: item.mallName, link: item.link)
            self.likeModel.toggleLike(newItem, folder: folder)
            self.appendLikeItem(index)
            
        }
    }
    private func appendLikeItem(_ index: IndexPath?) {
        self.outputLikeList.value = self.likeModel.getLikeList()
        self.outputloadIndex.value = index
    }
    private func getNewItems() {
        ShoppingNetworkManager.shard.callNetwork(query: model.nowItem, start: model.start, data: model.filterType, type: ShoppingModel.self) { data in
            guard let data = data else { return }
            guard let item = data.items else { return }
            guard let start = data.start else {return}
            guard let total = data.total else {return}
            if self.model.start == 1 {
                self.outputTotal.value = total
                self.outputList.value = item
            }else{
                self.outputList.value.append(contentsOf: item)
            }
            self.outputFolder.value = self.likeModel.fetchFolder()
            //print(self.likeModel.fetchFolder())
            self.outputLikeList.value = self.likeModel.getLikeList()
            self.outputPage.value = start
            
        }
    }
    
    
}
