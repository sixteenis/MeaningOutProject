//
//  UserModel.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/13/24.
//

import UIKit
// TODO: UserDefaults들에 대한 로직들을 담당하는 부분을 객체에서 관리하는 것?
final class UserModel {
    static let shared = UserModel()
    lazy var beforProfile = self.userProfile
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
    var userJoinDate: String {
        get{
            return UserDefaults.standard.string(forKey: "joinDate") ?? "??"
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "joinDate")
        }
    }
    private init() {}
    
    // MARK: - 랜덤 프로필 가져와주는 함수
    func getRandomProfile(){
        let profile = self.profileList[Int.random(in: 0..<profileList.count)]
        self.beforProfile = profile
    }
    func setUserJoinDate() {
        let date = Date()
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy.MM.dd 가입"
        let dateString = myFormatter.string(from: date)
        self.userJoinDate = dateString
    }
    func reset() {
        UserDefaults.standard.setValue(nil, forKey: "userProfile")
        UserDefaults.standard.setValue(nil, forKey: "userNickname")
        UserDefaults.standard.setValue(nil, forKey: "joinDate")
    }
    
}
