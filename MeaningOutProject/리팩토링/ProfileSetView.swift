//
//  ProfileSetView.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/25/24.
//

import UIKit

import SnapKit
protocol ProfileSetViewDelegate: AnyObject {
    func setUpProfile()
    func profileTapped(title: String)
}
class ProfileSetView: BaseView {
    private lazy var profileImage = {
        let view = MainProfileImageView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    private let line = {
        let view = UIView()
        view.backgroundColor = .lineColor
        return view
    }()
    private let nicknameTextField = {
        let view = UITextField()
        view.placeholder = PlaceholderEnum.nickName
        view.textColor = .textColor
        view.contentMode = .left
        return view
    }()
    override func setUpHierarchy() {
        
    }
    override func setUpLayout() {
        
    }
    func setUpProfile(image: String) {
        
    }
    @objc func profileImageTapped() {
        
    }
}
