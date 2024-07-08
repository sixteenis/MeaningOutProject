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
class LikeIItemShowViewController: BaseViewController {
    let collection = UICollectionView()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    override func setUpHierarchy() {
        view.addSubview(collection)
    }
    override func setUpLayout() {
        collection.snp.makeConstraints { make in
            //make.edges.
        }
    }
    override func setUpView() {
        print(#function)
    }
}
