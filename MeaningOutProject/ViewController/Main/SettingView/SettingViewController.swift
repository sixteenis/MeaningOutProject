//
//  SettingViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/14/24.
//

import UIKit

import SnapKit

class SettingViewController: UIViewController {
    let profileView = UIView()
    lazy var profile = SelcetProfileImageView(profile: userModel.userProfile)
    let nickName = UILabel()
    let userJoinDate = UILabel()
    let nextSymbol = UIImageView()
    let userModel = UserModel.shared
    let searchModel = SearchDataModel.shared
    let tableView = UITableView()
    
    let settingList = ["나의 장바구니 목록", "자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHierarch()
        setUpLayout()
        setUpUI()
        setUpTabelView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    // MARK: - connect 부분
    func setUpHierarch() {
        view.addSubview(profileView)
        profileView.addSubview(profile)
        profileView.addSubview(nickName)
        profileView.addSubview(userJoinDate)
        profileView.addSubview(nextSymbol)
        
        view.addSubview(tableView)
    }
    
    // MARK: - Layout 부분
    func setUpLayout() {
        profileView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(120)
        }
        profile.snp.makeConstraints { make in
            //make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.centerY.equalTo(profileView)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.size.equalTo(view.snp.width).multipliedBy(0.2)
        }
        nickName.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.top).inset(30)
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
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
    }
    
    // MARK: - UI 세팅 부분
    func setUpUI() {
        view.backgroundColor = .backgroundColor
        profileView.backgroundColor = .backgroundColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileViewTapped))
        profileView.addGestureRecognizer(tap)
        navigationItem.title = "SETTING"
        
        nickName.text = userModel.userNickname
        userJoinDate.text = userModel.userJoinDate
        nextSymbol.image = .nextSymbol
        nextSymbol.tintColor = .settingSeperatorColor
    }
    func setUpTabelView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.id)
        tableView.rowHeight = 50
    }

    
    // MARK: - 버튼 함수 부분
    @objc func profileViewTapped() {
        print(#function)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.id, for: indexPath) as! SettingTableViewCell
        let data = settingList[indexPath.row]
        cell.selectionStyle = .none
        if data == "나의 장바구니 목록" {
            cell.setUpData(data: data, likeCount: searchModel.likeList.count)
        }else{
            cell.setUpData(data: data)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            //1.
            let alert = UIAlertController(
                title: "탈퇴하기",
                message: "탈퇴를 하면 데이터가 모두 초기화됩니다. \n탈퇴 하시겠습니까?",
                preferredStyle: .alert
            )
            //2.
            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                self.searchModel.reset()
                self.userModel.reset()
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
                let navigationController = UINavigationController(rootViewController: OnboardingViewController())
        
                sceneDelegate?.window?.rootViewController = navigationController
                sceneDelegate?.window?.makeKeyAndVisible()
                
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            
            //3.
            alert.addAction(cancel)
            alert.addAction(ok)
            //4
            present(alert, animated: true)
        }
    }
    
    
}
