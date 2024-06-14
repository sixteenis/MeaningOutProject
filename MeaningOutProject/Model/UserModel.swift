//
//  UserModel.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/13/24.
//

import UIKit

class UserModel {
    static let shared = UserModel()
    var beforProfile = "" //고르기 직전
    let profileList = ["profile_0","profile_1","profile_2","profile_3","profile_4","profile_5","profile_6","profile_7","profile_8","profile_9","profile_10","profile_11"]
    var userProfile: String {
        get{
            return UserDefaults.standard.string(forKey: "userProfile") ?? "??"
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "userProfile")
        }
    }
    var userNickname: String {
        get{
            return UserDefaults.standard.string(forKey: "userNickname") ?? "??"
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "userNickname")
        }
    }
    private init() {}
    
    // MARK: - 랜덤 프로필 가져와주는 함수
    func getRandomProfile(){
        let profile = self.profileList[Int.random(in: 0..<profileList.count)]
        self.beforProfile = profile
    }
    
    
}
