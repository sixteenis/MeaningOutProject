//
//  LikeFolderShowViewModel.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/17/24.
//

import Foundation

class LikeFolderShowViewModel {
    let repository = LikeRepository.shard
    var inputViewDidLoad: Obsearvable<Void?> = Obsearvable(nil)
    
    var outputGetFolderList: Obsearvable<[FolderModel]> = Obsearvable([FolderModel]())
    
    init() {
        inputViewDidLoad.bind { _ in
            self.getFolderList()
        }
    }
    
    func getFolderList() {
        self.outputGetFolderList.value = repository.getFolderList()
    }
}
