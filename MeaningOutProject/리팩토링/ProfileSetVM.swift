//
//  ProfileSetVM.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/9/24.
//

import Foundation

final class ProfileSetVM {
    //닉네임 텍스트를 받은 input 하나
    var inputNickname: Obsearvable<String?> = Obsearvable(nil)
    
    //닉네임 필터링을 통해 string값 하나
    //닉네임 필터링을 통해 bool값 하나
    var outputFilterTitle: Obsearvable<NickNameFilter> = Obsearvable(.start)
    var outputFilterBool = Obsearvable(false)
    
    init() {
        inputNickname.bind { _ in
            self.nickNameFilter()
            self.checkName()
        }
    }
    private func checkName() {
        if self.outputFilterTitle.value == .ok {
            outputFilterBool.value = true
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







