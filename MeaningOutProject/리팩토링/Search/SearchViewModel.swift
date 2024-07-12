//
//  SearchViewModel.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/10/24.
//

import Foundation

final class SearchViewModel {
    let model = SearchDataModel.shared
    var inputSearchTextFiled: Obsearvable<String?> = Obsearvable(nil) //서치바의 텍스트를 설정하고 검색할 때
    var inputRemoveAllButtonTapped: Obsearvable<Void> = Obsearvable(()) // 전체 삭제 버튼을 눌렀을 때
    
    var searchList: [String] {
        return model.searchItem
    }
    init() {
        inputSearchTextFiled.bind { text in
            guard let text = text else {return}
            self.searchShopping(text)
        }
        inputRemoveAllButtonTapped.bind { _ in
            self.removeAllSearchList()
        }
        
        
    }
    private func searchShopping(_ text: String) {
        model.appendSearchItem(text)
    }
    private func removeAllSearchList() {
        self.model.searchItem = []
    }
    
}
