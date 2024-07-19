//
//  SettingViewModel.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/15/24.
//

import Foundation

class SettingViewModel {
    private let userModel = UserModelManager.shared
    var inputViewDidLoad: Obsearvable<Void?> = Obsearvable(nil)
    
    var outputSettingList: Obsearvable<[Setting]> = Obsearvable([Setting]())
    var outputUserData: Obsearvable<UserModelManager?> = Obsearvable(nil)
    var outputLikeCount = Obsearvable(0)
    init() {
        inputViewDidLoad.loadBind { _ in
            self.getLikeCount()
            self.getSettingList()
            self.getUserData()
        }
    }
    func getLikeCount() {
        self.outputLikeCount.value = LikeRepository.shard.fetchAll().count
    }
    func getSettingList() {
        self.outputSettingList.value = Setting.allCases
    }
    func getUserData() {
        self.outputUserData.value = UserModelManager.shared
    }
}
