//
//  ProfileSetViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/13/24.
//

import UIKit

class ProfileSetViewController: UIViewController {
    private lazy var profileImage = MainProfileImageView(profile: userModel.beforProfile)
    private let nicknameTextField = UITextField()
    private let line = UIView()
    private let nicknameFilterLabel = UILabel()
    private let okButton = SelcetButton(title: "완료")
    private var textfilter: NickNameFilter = .start {
        didSet{
            setUpChangeUI()
        }
    }
    
    let userModel = UserModel.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHierarch()
        setUpLayout()
        setUpUI()
        setUpChangeUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileImage.changeImage(userModel.beforProfile) 
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }
    // MARK: - connect 부분
    func setUpHierarch() {
        view.addSubview(profileImage)
        view.addSubview(nicknameTextField)
        view.addSubview(line)
        view.addSubview(nicknameFilterLabel)
        view.addSubview(okButton)
        
        //델리게이트
        nicknameTextField.delegate = self
        
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImage.addGestureRecognizer(tap)
    }
    
    // MARK: - Layout 부분
    func setUpLayout() {
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(view.snp.width).multipliedBy(0.3)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        line.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(1)
        }
        nicknameFilterLabel.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        okButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameFilterLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(45)
        }
    }
    
    // MARK: - UI 세팅 부분
    func setUpUI() {
        view.backgroundColor = .backgroundColor
        
        navigationController?.navigationBar.tintColor = .buttonSelectColor
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(nvBackButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = "PROFILE SETTING"
        
        nicknameTextField.placeholder = PlaceholderEnum.nickName
        nicknameTextField.textColor = .textColor
        nicknameTextField.contentMode = .left
        
        line.backgroundColor = .textFieldBackgroundColor
        
        
        nicknameFilterLabel.textAlignment = .left
        nicknameFilterLabel.numberOfLines = 1
        nicknameFilterLabel.font = .systemFont(ofSize: 13)
        setUpChangeUI()
        
        
    }
    // MARK: - 동적인 UI 세팅 부분
    func setUpChangeUI() {
        nicknameFilterLabel.text = textfilter.rawValue
        nicknameFilterLabel.textColor = textfilter.color
    }
    
    func reset() {
        nicknameTextField.text = ""
        textfilter = .start
    }
    // MARK: - 버튼 함수 부분
    @objc func nvBackButtonTapped() {
        navigationController?.popViewController(animated: true)
        reset()
    }
    @objc func profileImageTapped() {
        navigationController?.pushViewController(SelectProfileViewController(), animated: true)
    }
    @objc func okButtonTapped() {
        checkTextFiled()
    }
    // MARK: - 다음뷰로 이동하는 부분
    func nextView() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        //let navigationController = UINavigationController(rootViewController: TabBarController())
        
        sceneDelegate?.window?.rootViewController = TabBarController()
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    func checkTextFiled(){
        if self.textfilter == .ok && !nicknameTextField.text!.isEmpty {
            userModel.userProfile = userModel.beforProfile
            userModel.userNickname = nicknameTextField.text!
            nextView()
            return
        }else{
            let alert = UIAlertController(
                title: "닉네임을 확인해주세요.",
                message: nil,
                preferredStyle: .alert
            )
            let ok = UIAlertAction(title: "확인", style: .default)
            alert.addAction(ok)
            
            present(alert, animated: true)
        }
    }
}



extension ProfileSetViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkTextFiled()
        return true
    }
    private func containsSpecialChar(_ char: String) -> Bool {
        let specialChar = CharacterSet.alphanumerics.inverted
        return char.rangeOfCharacter(from: specialChar) != nil
    }
    //텍스트 필드 글자 필터링 하는 부분
    func textFieldDidChangeSelection(_ textField: UITextField) {
        //print(#function)
        guard let text = textField.text else {return}
        if text.count < 2 || text.count >= 10 {
            textfilter = .lineNumber
            return
        }
        
        if containsSpecialChar(text) {
            textfilter = .specialcharacters
            return
        }
        
        let filterNum = text.filter{$0.isNumber}
        if !filterNum.isEmpty {
            textfilter = .numbers
            return
        }
        textfilter = .ok
        
    }
}
