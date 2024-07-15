//
//  SearchResultViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/15/24.
//

import UIKit

import Alamofire
import SnapKit

final class SearchResultViewController: BaseViewController {
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let line = UIView()
    private let allcountLabel = UILabel()
    
    private let accuracyButton = FilterButtonView(type: .accuracy)
    private let dateButton = FilterButtonView(type: .date)
    private let priceUpButton = FilterButtonView(type: .priceUp)
    private let priceDownButton = FilterButtonView(type: .priceDown)
    
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
    
    var searchText: String? // 이전뷰에서 받아오는 값
    private let vm = SearchResultViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //showLoadingIndicator()
        setUpcollection()
        setUpFilterButton(0)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.inputLoadView.value = searchText
    }
    override func bindData() {
        vm.outputList.bind { [weak self] data in
            guard let self = self else {return}
            if data.isEmpty {
                self.noDataView.isHidden = false
                self.noDataLabel.text = "\(searchText!)의 대한 정보가 없습니다!"
              //self.hideLoadingIndicator()
                return
            }else{
                //self.hideLoadingIndicator()
                noDataView.isHidden = true
                collectionView.reloadData()
            }
        }
        
        vm.outputTotal.loadBind { total in
            self.allcountLabel.text = total.formatted() + "개의 검색 결과"
        }
        vm.outputPage.bind { page in
            if page == 1 && !self.vm.outputList.value.isEmpty{
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
        }
        vm.outputloadIndex.bind { index in
            guard let index = index else {return}
            self.collectionView.reloadItems(at: [index])
        }
    }
    
    // MARK: - connect 부분
    override func setUpHierarchy() {
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
    override func setUpLayout() {
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
    override func setUpView() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        
        navigationController?.navigationBar.tintColor = .buttonSelectColor
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(nvBackButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = searchText
        
        line.backgroundColor = .lineColor
        
        allcountLabel.font = .systemFont(ofSize: 14, weight: .heavy)
        allcountLabel.textColor = .mainOragieColor
        
        accuracyButton.tag = 0
        accuracyButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        dateButton.tag = 1
        dateButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        priceUpButton.tag = 2
        priceUpButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        priceDownButton.tag = 3
        priceDownButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        noDataView.backgroundColor = .backgroundColor
        noDataImage.image = .noDataImage
        noDataLabel.font = .systemFont(ofSize: 15, weight: .heavy)
        noDataView.isHidden = true
    }
    // MARK: - collection 세팅 부분
    private func setUpcollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.id)
        collectionView.backgroundColor = .backgroundColor
    }
    
    // MARK: - 필터 버튼 뷰 세팅하는 함수
    private func setUpFilterButton(_ tag: Int) {
        accuracyButton.noselect()
        dateButton.noselect()
        priceUpButton.noselect()
        priceDownButton.noselect()
        switch tag {
        case 0:
            accuracyButton.select()
        case 1:
            dateButton.select()
        case 2:
            priceUpButton.select()
        case 3:
            priceDownButton.select()
        default:
            print("필터 버튼에서 에러 발생!")
        }
    }
    // MARK: - 버튼 부분
    @objc func nvBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func filterButtonTapped(_ sender: UIButton) {
        vm.inputfilterSelect.value = sender.tag
        setUpFilterButton(sender.tag)
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
        return vm.outputList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.id, for: indexPath) as! SearchResultCollectionViewCell
        let data = vm.outputList.value[indexPath.item]
        let likeBool = vm.outputLikeList.value.contains(data.productId)
        cell.setUpData(data, bool: likeBool)
        
        cell.likeTapped = {[weak self] in
            guard let self = self else { return }
            if !likeBool{
                if vm.outputFolder.value.count == 1{
                    vm.inputAppendLike.value = (data,vm.outputFolder.value.first, indexPath)
                }else {
                    let alert = UIAlertController(
                        title: nil,
                        message: nil,
                        preferredStyle: .actionSheet
                    )
                    for i in 0..<vm.outputFolder.value.count{
                        let action = UIAlertAction(title: vm.outputFolder.value[i].folderName, style: .default) { _ in
                            let folder = self.vm.outputFolder.value[i]
                            self.vm.inputAppendLike.value = (data, folder, indexPath)
                        }
                        alert.addAction(action)
                    }
                    let cancel = UIAlertAction(title: "취소", style: .cancel)
                    alert.addAction(cancel)
                    present(alert, animated: true)
                }
            }else{
                vm.inputAppendLike.value = (data,nil, indexPath)
            }
        }
        
        return cell
    }
    // MARK: - 네트워크 컨트롤러 이동하는 부분
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = NetworkViewController()
        let data = vm.outputList.value[indexPath.item]
        vc.item = LikeList(productId: data.productId, title: data.title, image: data.image, lprice: data.lprice, mallName: data.mallName, link: data.link)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            let data = vm.outputList.value
            if data.count - 4 == item.row && vm.outputPage.value + 30 < vm.outputTotal.value {
                vm.inputPlusPage.value = ()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    }
    
}
