//
//  SearchResultViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/15/24.
//

import UIKit

import Alamofire
import SnapKit

final class SearchResultViewController: UIViewController {
    let activityIndicator = UIActivityIndicatorView(style: .large)
    private let line = UIView()
    private let allcountLabel = UILabel()
    
    private let accuracyButton = UIButton()
    private let dateButton = UIButton()
    private let priceUpButton = UIButton()
    private let priceDownButton = UIButton()
    
    private let noDataView = UIView()
    private let noDataImage = UIImageView()
    private let noDataLabel = UILabel()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    static func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 40 // 20 + 30
        layout.itemSize = CGSize(width: width/2, height: width/1.2) //셀
        layout.scrollDirection = .vertical // 가로, 세로 스크롤 설정
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }
    let filerArr: [NetWorkFilterEnum] = [.accuracy, .date, .priceUp, .priceDown]
    private let searchDataModel = SearchDataModel.shared
    private var data: [Item] = []
    var filterData: NetWorkFilterEnum = .accuracy {
        didSet {
            setUpFilterButton()
        }
        willSet {
            page = 1
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            callRequset()
        }
    }
    var page = 1
    var isEnd = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHierarch()
        setUpLayout()
        setUpUI()
        setUpcollection()
        callRequset()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpFilterButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noDataView.isHidden = true
        collectionView.reloadData()
    }
    
    // MARK: - connect 부분
    private func setUpHierarch() {
        view.addSubview(line)
        view.addSubview(allcountLabel)
        
        view.addSubview(accuracyButton)
        view.addSubview(dateButton)
        view.addSubview(priceUpButton)
        view.addSubview(priceDownButton)
        
        view.addSubview(collectionView)
        
        view.addSubview(noDataView)
        noDataView.addSubview(noDataImage)
        noDataView.addSubview(noDataLabel)
    }
    
    // MARK: - Layout 부분
    private func setUpLayout() {
        line.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        allcountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        accuracyButton.snp.makeConstraints { make in
            make.top.equalTo(allcountLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(60)
        }
        dateButton.snp.makeConstraints { make in
            make.top.equalTo(allcountLabel.snp.bottom).offset(10)
            make.leading.equalTo(accuracyButton.snp.trailing).offset(10)
            make.width.equalTo(60)
        }
        priceUpButton.snp.makeConstraints { make in
            make.top.equalTo(allcountLabel.snp.bottom).offset(10)
            make.leading.equalTo(dateButton.snp.trailing).offset(10)
            make.width.equalTo(80)
        }
        priceDownButton.snp.makeConstraints { make in
            make.top.equalTo(allcountLabel.snp.bottom).offset(10)
            make.leading.equalTo(priceUpButton.snp.trailing).offset(10)
            make.width.equalTo(80)
        }
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(priceDownButton.snp.bottom).offset(10)
            
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
    private func setUpUI() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        view.backgroundColor = .backgroundColor
        
        navigationController?.navigationBar.tintColor = .buttonSelectColor
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(nvBackButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = searchDataModel.nowItem
        
        line.backgroundColor = .lineColor
        
        //allcountLabel.text = ""
        allcountLabel.font = .systemFont(ofSize: 14, weight: .heavy)
        allcountLabel.textColor = .mainOragieColor
        
        accuracyButton.setTitle("정확도", for: .normal)
        accuracyButton.titleLabel?.font = .systemFont(ofSize: 14)
        accuracyButton.layer.cornerRadius = 15
        accuracyButton.layer.borderWidth = 1
        accuracyButton.layer.borderColor = UIColor.textFieldBackgroundColor.cgColor
        accuracyButton.tag = 0
        accuracyButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        dateButton.setTitle("날짜순", for: .normal)
        dateButton.titleLabel?.font = .systemFont(ofSize: 14)
        dateButton.layer.cornerRadius = 15
        dateButton.layer.borderWidth = 1
        dateButton.layer.borderColor = UIColor.textFieldBackgroundColor.cgColor
        dateButton.tag = 1
        dateButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        priceUpButton.setTitle("가격높은순", for: .normal)
        priceUpButton.titleLabel?.font = .systemFont(ofSize: 14)
        priceUpButton.layer.cornerRadius = 15
        priceUpButton.layer.borderWidth = 1
        priceUpButton.layer.borderColor = UIColor.textFieldBackgroundColor.cgColor
        priceUpButton.tag = 2
        priceUpButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        priceDownButton.setTitle("가격낮은순", for: .normal)
        priceDownButton.titleLabel?.textColor = .black
        priceDownButton.titleLabel?.font = .systemFont(ofSize: 14)
        priceDownButton.layer.cornerRadius = 15
        priceDownButton.layer.borderWidth = 1
        priceDownButton.layer.borderColor = UIColor.textFieldBackgroundColor.cgColor
        priceDownButton.tag = 3
        priceDownButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        noDataView.backgroundColor = .backgroundColor
        
        noDataImage.image = .noDataImage
        
        noDataLabel.font = .systemFont(ofSize: 15, weight: .heavy)
    }
    // MARK: - collection 세팅 부분
    private func setUpcollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.id)
        collectionView.backgroundColor = .backgroundColor
    }
    
    // MARK: - 통신 부분
    private func callRequset() {
        showLoadingIndicator()
        searchDataModel.callNetwork(filterData: filterData.rawValue, page: page, type: ShoppingModel.self) { data in
            self.hideLoadingIndicator()
            guard let data = data else {
                self.noDataView.isHidden = false
                self.noDataLabel.text = "네트워크 오류가 발생했습니다!"
                return
            }
            self.succesNetWork(data)
        }
    }
    
    private func succesNetWork(_ result: ShoppingModel) {
        guard let total = result.total, let items = result.items else { return }
        
        allcountLabel.text = "\(total.formatted())개의 검색 결과"
        isEnd = total
        print(page)
        if page == 1{
            data = items
        }else{
            data.append(contentsOf: items)
        }
        if data.isEmpty {
            self.noDataView.isHidden = false
            self.noDataLabel.text = "\(searchDataModel.nowItem)의 대한 정보가 없습니다!"
        }else{
            noDataView.isHidden = true
        }
        
        collectionView.reloadData()
    }
    // MARK: - 필터 버튼 뷰 세팅하는 함수
    private func setUpFilterButton() {
        accuracyButton.titleLabel?.textColor = .textColor
        accuracyButton.backgroundColor = .backgroundColor
        dateButton.titleLabel?.textColor = .textColor
        dateButton.backgroundColor = .backgroundColor
        priceUpButton.titleLabel?.textColor = .textColor
        priceUpButton.backgroundColor = .backgroundColor
        priceDownButton.titleLabel?.textColor = .textColor
        priceDownButton.backgroundColor = .backgroundColor
        switch filterData {
        case .accuracy:
            accuracyButton.titleLabel?.textColor = .backgroundColor
            accuracyButton.backgroundColor = .buttonSelectColor
        case .date:
            dateButton.titleLabel?.textColor = .backgroundColor
            dateButton.backgroundColor = .buttonSelectColor
        case .priceUp:
            priceUpButton.titleLabel?.textColor = .backgroundColor
            priceUpButton.backgroundColor = .buttonSelectColor
        case .priceDown:
            priceDownButton.titleLabel?.textColor = .backgroundColor
            priceDownButton.backgroundColor = .buttonSelectColor
        }
    }
    // MARK: - 버튼 부분
    @objc func nvBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func filterButtonTapped(_ sender: UIButton) {
        print(searchDataModel.searchItem)
        // TODO: 이미 선택된 필터일 경우 통신을 막아야되나? 안막아도 되나? 고민해보자
        if filterData != filerArr[sender.tag]{
            switch sender.tag {
            case 0:
                filterData = .accuracy
            case 1:
                filterData = .date
            case 2:
                filterData = .priceUp
            case 3:
                filterData = .priceDown
            default:
                filterData = .accuracy
            }
        }
    }
    // MARK: - 로딩 구현 부분
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
    
}



extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.id, for: indexPath) as! SearchResultCollectionViewCell
        let data = data[indexPath.item]
        cell.backgroundColor = .backgroundColor
        cell.setUpData(data)
        
        cell.likeTapped = {[weak self] in
            guard let self = self else { return }
            searchDataModel.LikeListFunc(data.productId)
            collectionView.reloadItems(at: [indexPath])
        }
        
        
        return cell
    }
    // MARK: - 네트워크 컨트롤러 이동하는 부분
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = NetworkViewController()
        vc.shoppingTitle = data[indexPath.item].title
        vc.url = data[indexPath.item].link
        vc.id = data[indexPath.item].productId
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            if data.count - 4 == item.row && page + searchDataModel.display < isEnd {
                page += searchDataModel.display
                callRequset()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    }
    
}
