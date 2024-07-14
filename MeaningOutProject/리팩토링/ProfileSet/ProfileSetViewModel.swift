//
//  ProfileSetVM.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/9/24.
//

import Foundation

final class ProfileSetViewModel {
    private let model = UserModel.shared

    var inputViewDidLoadTrigger: Obsearvable<Void?> = Obsearvable(nil)
    var inputNickname: Obsearvable<String?> = Obsearvable(nil)
    
    private(set) lazy var outputProfileImage = Obsearvable(self.model.beforProfile)
    private(set) var outputFilterTitle: Obsearvable<NickNameFilter> = Obsearvable(.start)
    private(set) var outputFilterBool = Obsearvable(false)
    
    init() {
        inputNickname.bind { name in
            self.nickNameFilter()
            self.checkName(name)
        }
        inputViewDidLoadTrigger.bind { _ in
            self.changeProfile()
        }
    }
    private func changeProfile() {
        outputProfileImage.value = model.beforProfile
    }
    private func checkName(_ name: String?) {
        if self.outputFilterTitle.value == .ok {
            guard let name = name else {return}
            outputFilterBool.value = true
            model.userProfile = model.beforProfile
            model.userNickname = name
            model.setUserJoinDate()
            return
        }
        outputFilterBool.value = false
    }
    
    private func nickNameFilter() {
        guard let name = self.inputNickname.value else { return }
        let specialChar = CharacterSet(charactersIn: "@#$%")
        let filterNum = name.filter{$0.isNumber}
        
        if name.count < 2 || name.count >= 10 {
            outputFilterTitle.value = .lineNumber
            return
        }
        if name.rangeOfCharacter(from: specialChar) != nil {
            outputFilterTitle.value = .specialcharacters
            return
        }
        if name.isEmpty {
            outputFilterTitle.value = .numbers
            return
        }
        if !filterNum.isEmpty {
            outputFilterTitle.value = .numbers
            return
        }
        if name.hasPrefix(" ") || name.hasSuffix(" ") {
            outputFilterTitle.value = .spacer
            return
        }
        outputFilterTitle.value = .ok
    }
}







