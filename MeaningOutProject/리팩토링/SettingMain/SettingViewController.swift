//
//  SettingViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/14/24.
//

import UIKit

import SnapKit

final class SettingViewController: BaseViewController {
    private let line = UIView()
    private let profileView = UIView()
    private lazy var profile = SelcetProfileImageView(profile: userModel.userProfile)
    private let profileLine = UIView()
    private let nickName = UILabel()
    private let userJoinDate = UILabel()
    private let nextSymbol = UIImageView()
    
    
    private let userModel = UserModel.shared
    private let searchModel = SearchDataModel()
    private let tableView = UITableView()
    
    private let settingList = ["나의 장바구니 목록", "자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
    
    private let vm = SettingViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabelView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profile.changeProfile(image: userModel.userProfile)
        nickName.text = userModel.userNickname
        tableView.reloadData()
    }
    // MARK: - vm 구현 부분
    override func bindData() {
        vm.inputViewDidLoad.value = ()
        vm.outputSettingList.loadBind { _ in
            self.tableView.reloadData()
        }
    }
    // MARK: - connect 부분
    override func setUpHierarchy() {
        view.addSubview(line)
        
        view.addSubview(profileView)
        profileView.addSubview(profile)
        profileView.addSubview(nickName)
        profileView.addSubview(userJoinDate)
        profileView.addSubview(nextSymbol)
        view.addSubview(profileLine)
        
        view.addSubview(tableView)
    }
    // MARK: - Layout 부분
    override func setUpLayout() {
        line.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        profileView.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).inset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(120)
        }
        profile.snp.makeConstraints { make in
            //make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.centerY.equalTo(profileView).multipliedBy(1.1)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.size.equalTo(view.snp.width).multipliedBy(0.2)
        }
        nickName.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.top).inset(35)
            make.leading.equalTo(profile.snp.trailing).offset(15)
        }
        userJoinDate.snp.makeConstraints { make in
            make.top.equalTo(nickName.snp.bottom).offset(5)
            make.leading.equalTo(profile.snp.trailing).offset(15)
        }
        
        nextSymbol.snp.makeConstraints { make in
            make.trailing.equalTo(profileView.safeAreaLayoutGuide).inset(5)
            make.centerY.equalTo(profileView)
            make.size.equalTo(20)
        }
        profileLine.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(1)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileLine.snp.bottom)
            make.leading.bottom.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    // MARK: - UI 세팅 부분
    override func setUpView() {
        view.backgroundColor = .backgroundColor
        
        line.backgroundColor = .lineColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileViewTapped))
        profileView.addGestureRecognizer(tap)
        
        navigationItem.title = "SETTING"
        
        nickName.text = userModel.userNickname
        nickName.font = .boldSystemFont(ofSize: 20)
        userJoinDate.text = userModel.userJoinDate
        userJoinDate.font = .systemFont(ofSize: 14)
        userJoinDate.textColor = .textFieldBackgroundColor
        nextSymbol.image = .nextSymbol
        nextSymbol.tintColor = .settingSeperatorColor
        profileLine.backgroundColor = .textFieldBackgroundColor
        
    }
    private func setUpTabelView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.id)
        tableView.rowHeight = 50
        tableView.isScrollEnabled = false
        tableView.separatorColor = .buttonSelectColor
    }
    
    
    // MARK: - 버튼 함수 부분
    @objc func profileViewTapped() {
        let nv = ProfileSetViewController()
        nv.profileSetType = .edit
        userModel.beforProfile = userModel.userProfile
        navigationController?.pushViewController(nv, animated: true)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.outputSettingList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.id, for: indexPath) as! SettingTableViewCell
        let data = vm.outputSettingList.value[indexPath.row]
        cell.selectionStyle = .none
        if data == .shoppingList{
            cell.setUpData(data: data, likeCount: vm.outputLikeCount.value)
        }else {
            cell.setUpData(data: data)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            showAlert(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화됩니다. \n탈퇴 하시겠습니까?", okButton: "탈퇴") {_ in
                self.searchModel.reset()
                self.userModel.reset()
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let navigationController = UINavigationController(rootViewController: OnboardingViewController())
                
                sceneDelegate?.window?.rootViewController = navigationController
                sceneDelegate?.window?.makeKeyAndVisible()
            }
        }else if indexPath.row == 0{
            let vc = LikeFolderShowViewController()
            vc.navTitle = settingList[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}
