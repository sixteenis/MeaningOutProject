//
//  NetworkViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/15/24.
//

import UIKit
import WebKit

import SnapKit

class NetworkViewController: UIViewController {
    let webView = WKWebView()
    
    var shoppingTitle: String?
    var id: String = ""
    var url: String = ""
    let searchDataModel = SearchDataModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHierarch()
        setUpLayout()
        setUpUI()
        setWebView()
    }
    
    // MARK: - connect 부분
    func setUpHierarch() {
        view.addSubview(webView)
    }
    
    // MARK: - Layout 부분
    func setUpLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        changerightBarButtinImage()
    }
    
    // MARK: - UI 세팅 부분
    func setUpUI() {
        view.backgroundColor = .backgroundColor
        
        navigationController?.navigationBar.tintColor = .buttonSelectColor
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(nvBackButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        let rightButton = UIBarButtonItem(image: .shoppingImage, style: .plain, target: self, action: #selector(shoppingNVButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.title = shoppingTitle
        
        
    }
    func setWebView() {
        let myurl = URL(string: url)
        if let myurl = myurl {
            let myrequest = URLRequest(url: myurl)
            webView.load(myrequest)
        }
        // TODO: url이 이상하다면? 피드백을 줄까?
    }

    // MARK: - 버튼 함수 부분
    @objc func nvBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func shoppingNVButtonTapped() {
        searchDataModel.LikeListFunc(id)
        changerightBarButtinImage()
    }
    func changerightBarButtinImage() {
        if searchDataModel.likeList.contains(id) {
            navigationItem.rightBarButtonItem?.image = .shoppingImage
        }else{
            navigationItem.rightBarButtonItem?.image = .unshoppingImage
        }
    }
}
