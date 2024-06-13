//
//  SelectProfileViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/14/24.
//

import UIKit

class SelectProfileViewController: UIViewController {
    let usermodel = UserModel.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHierarch()
        setUpLayout()
        setUpUI()
    }
    
    // MARK: - connect 부분
    func setUpHierarch() {
        
    }
    
    // MARK: - Layout 부분
    func setUpLayout() {
        
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
