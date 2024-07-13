//
//  MainViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/14/24.
//

import UIKit

import SnapKit

final class SearchViewController: BaseViewController {
    // TODO: 네이게이션 밑에 라인 없애기
    private let searchBar = UISearchBar()
    private let line = UIView()
    
    private let recentLabel = UILabel()
    private let allRemoveButton = UIButton()
    private let searchTableView = UITableView()
    
    private let noDataView = UIView()
    private let noDataImage = UIImageView()
    private let noDataLabel = UILabel()
    
    private let vm = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
        setUpTableView()
        bindData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func bindData() {
        vm.inputViewLoad.value = ()
        // TODO: 다른 탭바에서 닉네임 변경 시 네비타이틀 자동 변경 구현하기
        vm.outputNickName.loadBind { [weak self] name in
            guard let self = self else {return}
            self.navigationItem.title = "\(name)'s MEANING OUT"
        }
        vm.outputSearchList.bind { [weak self] _ in
            guard let self = self else{ return }
            self.searchTableView.reloadData()
            noDataChang()
        }
        vm.outputSearchText.bind { [weak self] text in
            guard let self = self else {return}
            let vc = SearchResultViewController()
            vc.searchText = text
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    // MARK: - connect 부분
    override func setUpHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(line)
        
        view.addSubview(recentLabel)
        view.addSubview(allRemoveButton)
        view.addSubview(searchTableView)
        
        view.addSubview(noDataView)
        noDataView.addSubview(noDataImage)
        noDataView.addSubview(noDataLabel)
        
    }
    
    // MARK: - Layout 부분
    override func setUpLayout() {
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
        recentLabel.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        allRemoveButton.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(5)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        searchTableView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(recentLabel.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        noDataView.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        noDataImage.snp.makeConstraints { make in
            make.centerX.equalTo(noDataView.safeAreaLayoutGuide)
            make.centerY.equalTo(noDataView.safeAreaLayoutGuide)
            make.width.equalTo(view.snp.width).multipliedBy(0.75)
            make.height.equalTo(noDataImage.snp.width).multipliedBy(0.8)
            
        }
        noDataLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(noDataImage.snp.bottom).offset(10)
        }
        
        
    }
    
    // MARK: - UI 세팅 부분
    override func setUpView() {
        view.backgroundColor = .backgroundColor
        
        searchBar.placeholder = PlaceholderEnum.searchBar
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)

        
        line.backgroundColor = .lineColor
        recentLabel.text = "최근 검색"
        recentLabel.font = .systemFont(ofSize: 14, weight: .heavy)
        
        //allRemoveButton.tintColor = .mainOragieColor
        allRemoveButton.setTitle("전체 삭제", for: .normal)
        allRemoveButton.setTitleColor(.mainOragieColor, for: .normal)
        allRemoveButton.titleLabel?.font = .systemFont(ofSize: 13)
        
        noDataView.backgroundColor = .backgroundColor
        
        noDataImage.image = .noDataImage
        
        noDataLabel.text = "최근 검색어가 없어요"
        noDataLabel.font = .systemFont(ofSize: 15, weight: .heavy)
    }
    // MARK: - 델리게이트 연결 부분
    private func setUpDelegate() {
        searchBar.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        allRemoveButton.addTarget(self, action: #selector(allRemoveButtonTapped), for: .touchUpInside)
    }
    // MARK: - 테이블 뷰 세팅 부분
    private func setUpTableView() {
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
        searchTableView.rowHeight = 40
        searchTableView.backgroundColor = .backgroundColor
        searchTableView.separatorStyle = .none
        searchTableView.keyboardDismissMode = .onDrag
    }
    // MARK: - SearchData 배열 유무에 따라 뷰 바뀌는 함수
    private func noDataChang() {
        if vm.outputSearchList.value.isEmpty{
            noDataView.isHidden = false
        }else{
            noDataView.isHidden = true
        }
        
    }
    // MARK: - 버튼 함수 부분
    @objc func allRemoveButtonTapped() {
        vm.inputRemoveAllButton.value = ()
    }
}

// MARK: - 서치바 부분
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty && searchBar.text!.count > 1 {
            self.vm.inputSearchTextFiled.value = searchBar.text
            searchBar.text = nil
        }
        
    }
}

// MARK: - 테이블 부분
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.outputSearchList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id, for: indexPath) as! SearchTableViewCell
        let data = vm.outputSearchList.value[indexPath.row]
        cell.setUpData(data: data)
        cell.selectionStyle = .none
        cell.didDelete = { [weak self] in
            guard let self = self else { return }
            self.vm.inputRemoveOneButton.value = indexPath.row
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = vm.outputSearchList.value[indexPath.row]
        vm.inputSearchTextFiled.value = data
    }
    
}
