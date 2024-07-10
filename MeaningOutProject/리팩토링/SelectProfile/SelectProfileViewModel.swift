//
//  SelectProfileVM.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/9/24.
//

import Foundation

final class SelectProfileViewModel {
    private let userModel = UserModel.shared
    
    var profileImage: [String] {
        return userModel.profileList
    }
    lazy var inputSelectProfile = Obsearvable(userModel.beforProfile)
    
    //private func
    
}
