//
//  LikeIItemShowViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/8/24.
//

import UIKit

import SnapKit
// TODO: 디폴트 폴더 1개 전체
// TODO: 사용자 커스텀으로 폴더를 최대 4개까지 만들 수 있게 구현
// TODO: 쇼핑검색에서 좋아요 버튼을 눌렀을 때 이제 바로 좋아요 토글이 아니라 얼럿 쉬트르를 통해 커스텀 폴더에 들어가게끔 구현하기
// TODO: 폴더안에서 좋아요를 취소도 할 수 있다!
class LikeItemShowViewController: BaseViewController {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    private let likeRepository = LikeRepository.shard
    private let folder = LikeRepository.shard.fetchFolder()
    var index: Int!
    var nvTitle: String?
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func setUpHierarchy() {
        view.addSubview(collectionView)
    }
    override func setUpLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func setUpView() {
        navigationItem.title = nvTitle
        collectionView.delegate = self
        collectionView.dataSource = self
        //collectionView.prefetchDataSource = self
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.id)
        collectionView.backgroundColor = .backgroundColor
    }
}
extension LikeItemShowViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folder[index].likeLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.id, for: indexPath) as! SearchResultCollectionViewCell
        let data = folder[index].likeLists[indexPath.item]
        cell.backgroundColor = .backgroundColor
        //cell.setUpDataFolder(data)
        
        cell.likeTapped = {[weak self] in
            guard let self = self else { return }
            // MARK: - 폴더에 넣어주는 곳
            
//            likeRepository.addItem(LikeList(productId: data.productId, title: data.title, image: data.image, lprice: data.lprice, mallName: data.mallName, link: data.link), folder:self.folder.first!)
            // MARK: - 지금은 폴더가 하나지만 나중에 폴더가 늘어나면 처리해줘야됨
            let item = LikeList(productId: data.productId, title: data.title, image: data.image, lprice: data.lprice, mallName: data.mallName, link: data.link)
            let folder = self.folder.first!
            likeRepository.toggleLike(item, folder: folder)
            //searchDataModel.LikeListFunc(data.productId)
            collectionView.reloadItems(at: [indexPath])
        }
        
        
        return cell
    }
    // MARK: - 네트워크 컨트롤러 이동하는 부분
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = NetworkViewController()
        let data = folder[index].likeLists[indexPath.item]
        vc.item = LikeList(productId: data.productId, title: data.title, image: data.image, lprice: data.lprice, mallName: data.mallName, link: data.link)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
//extension LikeItemShowViewController: UICollectionViewDataSourcePrefetching {
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        let data = folder[index].likeLists[indexPaths.count]
//        for item in indexPaths {
//            if data.count - 4 == item.row && page + searchDataModel.display < isEnd {
//                page += searchDataModel.display
//                callRequset()
//            }
//        }
//    }
//    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
//    }
//    
//}

