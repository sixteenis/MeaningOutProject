//
//  ProfileSetViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/13/24.
//

import UIKit

final class ProfileSetViewController: UIViewController {
    private lazy var profileImage = MainProfileImageView(profile: userModel.beforProfile)
    private let line = UIView()
    private let nicknameTextField = UITextField()
    private let textLine = UIView()
    private let nicknameFilterLabel = UILabel()
    private let okButton = SelcetButton(title: "완료")
    private var textfilter: NickNameFilter = .start {
        didSet{
            setUpChangeUI()
        }
    }
    
    let userModel = UserModel.shared
    var profileSetType: ProfileSetType = .first
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHierarch()
        setUpLayout()
        setUpUI()
        setUpChangeUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch profileSetType {
        case .first:
            profileImage.changeImage(userModel.beforProfile)
        case .edit:
            profileImage.changeImage(userModel.beforProfile)
        }
        
            
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }
    // MARK: - connect 부분
    func setUpHierarch() {
        view.addSubview(line)
        view.addSubview(profileImage)
        view.addSubview(nicknameTextField)
        view.addSubview(textLine)
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
        line.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(view.snp.width).multipliedBy(0.3)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        textLine.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(1)
        }
        nicknameFilterLabel.snp.makeConstraints { make in
            make.top.equalTo(textLine.snp.bottom).offset(10)
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
        
        if profileSetType == .edit{
            let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
            navigationItem.rightBarButtonItem = saveButton
            okButton.isHidden = true
        }
        navigationItem.title = profileSetType.rawValue
        
        line.backgroundColor = .lineColor
        nicknameTextField.placeholder = PlaceholderEnum.nickName
        nicknameTextField.textColor = .textColor
        nicknameTextField.contentMode = .left
        
        textLine.backgroundColor = .lineColor
        
        
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
        if profileSetType == .edit {
            userModel.beforProfile = userModel.userProfile
        }else{
            reset()
        }
        navigationController?.popViewController(animated: true)
        
    }
    @objc func profileImageTapped() {
        let vc = SelectProfileViewController()
        vc.profileSetType = self.profileSetType
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func okButtonTapped() {
        checkTextFiled()
    }
    @objc func saveButtonTapped() {
        if nicknameTextField.text == "" {
            userModel.userProfile = userModel.beforProfile
            navigationController?.popViewController(animated: true)
        }else{
            checkTextFiled()
        }
        
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
            if profileSetType == .first {
                userModel.setUserJoinDate()
                nextView()
                return
            }else{
                navigationController?.popViewController(animated: true)
                return
            }
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
        textfilter = filterText(text)
        
    }
    // MARK: - 닉네임 필터 기능
    func filterText(_ text: String) -> NickNameFilter {
        if text.count < 2 || text.count >= 10 {
            return .lineNumber
        }
        let specialChar = CharacterSet(charactersIn: "@#$%")
        if text.rangeOfCharacter(from: specialChar) != nil  {
            return .specialcharacters
        }
        
        let filterNum = text.filter{$0.isNumber}
        if !filterNum.isEmpty {
            return .lineNumber
        }
        if text.hasPrefix(" ") || text.hasSuffix(" ") {
            return .spacer
        }
        return .ok
    }
}
