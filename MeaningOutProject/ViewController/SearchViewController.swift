//
//  MainViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/14/24.
//

import UIKit

import SnapKit

class SearchViewController: UIViewController {
    let searchBar = UISearchBar()
    let line = UIView()
    let noDataImage = UIImageView()
    let noDataLabel = UILabel()
    
    let userModel = UserModel.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHierarch()
        setUpLayout()
        setUpUI()
    }
    
    // MARK: - connect 부분
    func setUpHierarch() {
        view.addSubview(searchBar)
        view.addSubview(line)
        view.addSubview(noDataImage)
        view.addSubview(noDataLabel)
    }
    
    // MARK: - Layout 부분
    func setUpLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(44)
        }
        line.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        noDataImage.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.9)
            make.width.equalTo(view.snp.width).multipliedBy(0.75)
            make.height.equalTo(noDataImage.snp.width).multipliedBy(0.8)
            
        }
        noDataLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(noDataImage.snp.bottom).offset(10)
        }
        

    }
    
    // MARK: - UI 세팅 부분
    func setUpUI() {
        view.backgroundColor = .backgroundColor
        
        searchBar.placeholder = PlaceholderEnum.searchBar
        
        navigationItem.title = "\(userModel.userNickname)'s MEANING OUT"
        
        noDataImage.image = .noDataImage
        
        noDataLabel.text = "최근 검색어가 없어요"
        noDataLabel.font = .systemFont(ofSize: 15, weight: .heavy)
    }
}
