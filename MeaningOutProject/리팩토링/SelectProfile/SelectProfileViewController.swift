//
//  SelectProfileViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/14/24.
//

import UIKit

import SnapKit

final class SelectProfileViewController: BaseViewController {
    private let line = UIView()
    private lazy var profileImage = MainProfileImageView(profile: vm.getSelectImage)
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    static func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 50 // 20 + 30
        layout.itemSize = CGSize(width: width/4, height: width/4) //셀
        layout.scrollDirection = .vertical // 가로, 세로 스크롤 설정
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }
    
    private let vm = SelectProfileViewModel()
    var profileSetType: ProfileSetType = .first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
    
    override func bindData() {
        vm.outputChangeProfile.bind { _ in
            self.collectionView.reloadData()
        }
    }
    // MARK: - connect 부분
    override func setUpHierarchy() {
        view.addSubview(line)
        view.addSubview(profileImage)
        view.addSubview(collectionView)
    }
    // MARK: - Layout 부분
    override func setUpLayout () {
        line.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(view.snp.width).multipliedBy(0.3)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    // MARK: - UI 세팅 부분
    override func setUpView() {
        line.backgroundColor = .lineColor
        navigationController?.navigationBar.tintColor = .buttonSelectColor
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(nvBackButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = profileSetType.rawValue
        
    }
    // MARK: - Collection 세팅 부분
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SelectProfileCollectionViewCell.self, forCellWithReuseIdentifier: SelectProfileCollectionViewCell.id)
        collectionView.backgroundColor = .backgroundColor
        
        collectionView.reloadData()
    }
    // MARK: - 버튼 함수 부분
    @objc func nvBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension SelectProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.profileImage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectProfileCollectionViewCell.id, for: indexPath) as! SelectProfileCollectionViewCell
        let data = vm.profileImage[indexPath.row]
        let selectBool = data == vm.outputChangeProfile.value
        cell.backgroundColor = .backgroundColor
        cell.setUpData(data, select: selectBool)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        vm.inputSelectProfile.value = indexPath.row
        self.profileImage.changeImage(vm.outputChangeProfile.value)
    }
}
