//
//  ProfileSetViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/13/24.
//

import UIKit

class ProfileSetViewController: UIViewController {
    let userModel = UserModel.shared
    lazy var profileImage = MainProfileImageView(profile: userModel.getRandomProfile())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHierarch()
        setUpLayout()
        setUpUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }
    // MARK: - connect 부분
    func setUpHierarch() {
        view.addSubview(profileImage)
        
    }
    
    // MARK: - Layout 부분
    func setUpLayout() {
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(view.snp.width).multipliedBy(0.3)
        }
    }
    
    // MARK: - UI 세팅 부분
    func setUpUI() {
        view.backgroundColor = .backgroundColor
        
        navigationController?.navigationBar.tintColor = .buttonSelectColor
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(nvBackButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = "PROFILE SETTING"
        
    }
    
    // MARK: - 버튼 함수 부분
    @objc func nvBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}
