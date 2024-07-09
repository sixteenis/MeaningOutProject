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
    private let vm = ProfileSetVM()
    var profileSetType: ProfileSetType = .first
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHierarch()
        setUpLayout()
        setUpUI()
        setUpChangeUI()
        bindData()
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
        self.checkTextFiled(self.vm.outputFilterBool.value)
    }
    @objc func saveButtonTapped() {
        self.checkTextFiled(self.vm.outputFilterBool.value)
    }
    // MARK: - 다음뷰로 이동하는 부분
    private func nextView() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        //let navigationController = UINavigationController(rootViewController: TabBarController())
        
        sceneDelegate?.window?.rootViewController = TabBarController()
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    // MARK: - vm 부분
    private func bindData() {
        
        vm.outputFilterTitle.bind { data in
            self.nicknameFilterLabel.text = data.rawValue
            self.nicknameFilterLabel.textColor = data.color
        }
    }
    // MARK: - 확인 버튼 눌렀을 때 다음 뷰로 갈지 정하는 함수
    func checkTextFiled(_ bool: Bool){
        if bool {
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
            simpleShowAlert(title: "닉네임을 확인해주세요.", message: nil, okButton: "확인")
        }
    }
}



extension ProfileSetViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //checkTextFiled()
        return true
    }
    //텍스트 필드 글자 필터링 하는 부분
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.vm.inputNickname.value = textField.text
    }

}
