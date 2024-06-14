//
//  SearchResultViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/15/24.
//

import UIKit

import Alamofire
import SnapKit
//case accuracy = "sim"
//case date = "date"
//case priceUp = "asc"
//case priceDown = "dsc"
class SearchResultViewController: UIViewController {
    let line = UIView()
    let allcountLabel = UILabel()
    
    let accuracyButton = UIButton()
    let dateButton = UIButton()
    let priceUpButton = UIButton()
    let priceDownButton = UIButton()
    
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
    
    let searchDataModel = SearchDataModel.shared
    var filterData: NetWorkFilterEnum = .accuracy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHierarch()
        setUpLayout()
        setUpUI()
        setUpcollection()
        callRequset()
    }
    
    // MARK: - connect 부분
    func setUpHierarch() {
        view.addSubview(line)
        view.addSubview(allcountLabel)
        
        view.addSubview(accuracyButton)
        view.addSubview(dateButton)
        view.addSubview(priceUpButton)
        view.addSubview(priceDownButton)
        
        view.addSubview(collectionView)
        
    }
    
    // MARK: - Layout 부분
    func setUpLayout() {
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
    }
    
    // MARK: - UI 세팅 부분
    func setUpUI() {
        view.backgroundColor = .backgroundColor
        
        navigationController?.navigationBar.tintColor = .buttonSelectColor
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(nvBackButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = searchDataModel.nowItem
        
        line.backgroundColor = .textFieldBackgroundColor
        
        allcountLabel.text = "99999999개의 검색 결과"
        allcountLabel.font = .systemFont(ofSize: 14, weight: .heavy)
        allcountLabel.textColor = .mainOragieColor
        
        accuracyButton.setTitle("정확도", for: .normal)
        accuracyButton.titleLabel?.font = .systemFont(ofSize: 14)
        accuracyButton.layer.cornerRadius = 15
        accuracyButton.tintColor = .black
        accuracyButton.backgroundColor = .red
        
        dateButton.setTitle("날짜순", for: .normal)
        dateButton.titleLabel?.font = .systemFont(ofSize: 14)
        dateButton.layer.cornerRadius = 15
        dateButton.tintColor = .black
        dateButton.backgroundColor = .red
        
        priceUpButton.setTitle("가격높은순", for: .normal)
        priceUpButton.titleLabel?.font = .systemFont(ofSize: 14)
        priceUpButton.layer.cornerRadius = 15
        priceUpButton.tintColor = .black
        priceUpButton.backgroundColor = .red
        
        priceDownButton.setTitle("가격낮은순", for: .normal)
        priceDownButton.titleLabel?.font = .systemFont(ofSize: 14)
        priceDownButton.layer.cornerRadius = 15
        priceDownButton.tintColor = .black
        priceDownButton.backgroundColor = .red
        
    }
    // MARK: - collection 세팅 부분
    func setUpcollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.id)
        collectionView.backgroundColor = .backgroundColor
    }
    
    // MARK: - 통신 부분
    func callRequset() {
        let url = "https://openapi.naver.com/v1/search/shop.json"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.id,
            "X-Naver-Client-Secret": APIKey.Secret
        ]
        let param: Parameters = [
            "query": searchDataModel.nowItem,
            "sort": filterData.rawValue,
            "display": 30,
            "start": 1,
        ]
        
        AF.request(url,method: .get,parameters: param, headers: header)
            .responseDecodable(of: ShoppingModel.self) {respons in
                switch respons.result{
                case .success(let value):
                    print(#function)
                    //isEnd = value.meta.is_end
//                    print("SUCCESS")
//                    if page == 1 || self.searchBar.text! != bookname{
//                        self.list = value.documents
//                        
//                        
//                    }else{
//                        self.list.append(contentsOf: value.documents)
//                    }
//                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print(error)
                }
            }
        
        
    }
    @objc func nvBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    

}



extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.id, for: indexPath) as! SearchResultCollectionViewCell
//        let data = userModel.profileList[indexPath.row]
//        let selectBool = data == userModel.beforProfile
//        cell.backgroundColor = .backgroundColor
//        cell.setUpData(data, select: selectBool)
        print(#function)
        cell.backgroundColor = .red
        return cell
    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        userModel.beforProfile = userModel.profileList[indexPath.row]
//        self.profileImage.changeImage(userModel.beforProfile)
//        collectionView.reloadData()
//        
//    }
    
    
    
}
