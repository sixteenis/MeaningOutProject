//
//  SelectProfileVM.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/9/24.
//

import Foundation

final class SelectProfileViewModel {
    private let userModel = UserModelManager.shared
    
    var profileImage: [String] {
        return userModel.profileList
    }
    var getSelectImage: String {
        return userModel.beforProfile
    }
    lazy var inputSelectProfile: Obsearvable<Int?> = Obsearvable(nil)
    
    private(set) lazy var outputChangeProfile: Obsearvable<String> = Obsearvable(userModel.beforProfile)
    
    init() {
        inputSelectProfile.bind { index in
            guard let index = index else { return }
            self.changeProfile(index)
        }
    }
    
    private func changeProfile(_ index: Int) {
        self.outputChangeProfile.value = self.profileImage[index]
        self.userModel.beforProfile = self.profileImage[index]
    }
    
}
