//
//  UserModel.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/13/24.
//

import UIKit

class UserModel {
    static let shared = UserModel()
    let profileList = ["profile_0","profile_1","profile_2","profile_3","profile_4","profile_5","profile_6","profile_7","profile_8","profile_9","profile_10","profile_11"]
    private init() {}
    
    // MARK: - 랜덤 프로필 가져와주는 함수
    func getRandomProfile() -> String {
        return self.profileList[Int.random(in: 0..<profileList.count)]
    }
    
}
