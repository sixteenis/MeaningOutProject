//
//  OnboardingViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/13/24.
//

import UIKit

import SnapKit

class OnboardingViewController: UIViewController {
    let mainLabel = UILabel()
    let logoImage = UIImageView()
    let mainImage = UIImageView()
    let startButton = SelcetButton(title: "시작하기")
    
    let userModel = UserModel.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHierarch()
        setUpLayout()
        setUpUI()
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - connect 부분
    func setUpHierarch() {
        view.addSubview(logoImage)
        view.addSubview(mainImage)
        view.addSubview(startButton)
    }
    
    // MARK: - Layout 부분
    func setUpLayout() {
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(25)
            make.bottom.equalTo(mainImage.snp.top).offset(-55)
        }
        mainImage.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(view.snp.width).multipliedBy(0.75)
            make.height.equalTo(mainImage.snp.width).multipliedBy(1.25)
            
        }
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(45)
        }
    }
    
    // MARK: - UI 세팅 부분
    func setUpUI() {
        view.backgroundColor = .backgroundColor
        
//        mainLabel.text = "MeaningOut"
//        mainLabel.font = .systemFont(ofSize: 55, weight: .heavy)
//        mainLabel.textAlignment = .center
//        mainLabel.textColor = .mainOragieColor
        logoImage.image = .logo
        logoImage.contentMode = .scaleAspectFill
        mainImage.image = .launch
        mainImage.contentMode = .scaleAspectFill
        
        
    }
    @objc func startButtonTapped() {
        userModel.getRandomProfile()
        navigationController?.pushViewController(ProfileSetViewController(), animated: true)
    }

}

