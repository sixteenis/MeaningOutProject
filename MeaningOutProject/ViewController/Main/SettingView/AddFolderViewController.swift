//
//  AddFolderViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/8/24.
//

import UIKit

import SnapKit
import RealmSwift
class AddFolderViewController: BaseViewController {
    let setTitle = UITextField()
    let likeRepository = LikeRepository.shard
    var completion: (() -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setUpHierarchy() {
        view.addSubview(setTitle)
    }
    override func setUpLayout() {
        setTitle.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func setUpView() {
        setTitle.placeholder = "폴더 이름을 써주세요"
        
        navigationItem.title = "폴더 생성"
        let item = UIBarButtonItem(title: "저장",style: .plain,  target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = item
    }
    @objc func saveButtonTapped() {
        if likeRepository.fetchFolder().count <= 3 {
            let newfolder = FolderModel(folderName: setTitle.text!, image: "figure.2", imageColor: "dd", likeList: LikeList())
            
            likeRepository.addFolder(newfolder)
            completion?()
        }
        dismiss(animated: true)
        //navigationController?.popViewController(animated: true)
        // TODO:  4개 이상이면 알람 띄워주삼 ㅇㅇ
    }
}
