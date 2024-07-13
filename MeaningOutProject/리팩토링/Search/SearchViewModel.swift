//
//  SearchViewModel.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/10/24.
//

import Foundation

final class SearchViewModel {
    let model = SearchDataModel.shared
    let userModel = UserModel.shared
    var inputViewLoad: Obsearvable<Void?> = Obsearvable(nil)
    var inputSearchTextFiled: Obsearvable<String?> = Obsearvable(nil) //서치바의 텍스트를 설정하고 검색할 때 또는 검색기록에서 눌렀을 때
    var inputRemoveAllButton: Obsearvable<Void> = Obsearvable(()) // 전체 삭제 버튼을 눌렀을 때
    var inputRemoveOneButton: Obsearvable<Int?> = Obsearvable(nil)//하나씩 삭제 눌렀을 때
    
    
    //서치바나 검색기록에서 검색하면 그걸 모델에 저장하고 다음화면으로 이동하는 output 구현
    //하나씩 삭제할 때 인덱스를 인붓으로 받고 아웃붙으로 하나 삭제하고 리로드해줘야됨
    //전체 삭제누르면 모델 전체삭제하고 아웃붙 클로저에서 리로드
    
    lazy var outputSearchList: Obsearvable<[String]> = Obsearvable([String]())
    lazy var outputNickName: Obsearvable<String> = Obsearvable("")
    var outputSearchText = Obsearvable("")
    
    init() {
        inputViewLoad.loadBind { _ in
            self.outputSearchList.value = self.model.searchItem
            self.outputNickName.value = self.userModel.userNickname
        }
        inputSearchTextFiled.bind { text in
            guard let text = text else {return}
            self.searchShopping(text)
        }
        inputRemoveAllButton.bind { _ in
            self.removeAllSearchList()
        }
        inputRemoveOneButton.bind { index in
            guard let index = index else {return}
            self.removeOneSearchList(index)
        }
        
        
    }
    private func searchShopping(_ text: String) {
        model.appendSearchItem(text)
        outputSearchList.value = self.model.searchItem
        outputSearchText.value = text
    }
    private func removeAllSearchList() {
        self.model.searchItem = []
        outputSearchList.value = self.model.searchItem
    }
    private func removeOneSearchList(_ index: Int) {
        self.model.removeSearchItem(index)
        outputSearchList.value = self.model.searchItem
    }
    
}
