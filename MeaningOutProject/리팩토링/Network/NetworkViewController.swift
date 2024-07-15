//
//  NetworkViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/15/24.
//

import UIKit
import WebKit

import SnapKit

final class NetworkViewController: BaseViewController {
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let webView = WKWebView()
    private let noDataView = UIView()
    private let noDataImage = UIImageView()
    private let noDataLabel = UILabel()
    var item: LikeList!
    let searchDataModel = SearchDataModel()
    let likeRepository = LikeRepository.shard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWebView()
        changeImage(item.productId)
    }
    // MARK: - connect 부분
    override func setUpHierarchy() {
        view.addSubview(webView)
        
        view.addSubview(noDataView)
        noDataView.addSubview(noDataImage)
        noDataView.addSubview(noDataLabel)
    }
    
    // MARK: - Layout 부분
    override func setUpLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        noDataView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
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
        webView.navigationDelegate = self
        navigationController?.navigationBar.tintColor = .buttonSelectColor
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(nvBackButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        let rightButton = UIBarButtonItem(image: .shoppingImage, style: .plain, target: self, action: #selector(shoppingNVButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
        var filterTitle = item?.title.replacingOccurrences(of: "<b>", with: "")
        filterTitle = filterTitle?.replacingOccurrences(of: "</b>", with: "")
        navigationItem.title = filterTitle
        
        noDataView.backgroundColor = .backgroundColor
        
        noDataImage.image = .noDataImage
        
        noDataLabel.font = .systemFont(ofSize: 15, weight: .heavy)
        
    }
    private func setWebView() {
        let myurl = URL(string: item.link)
        if let myurl = myurl {
            let myrequest = URLRequest(url: myurl)
            noDataView.isHidden = true
            webView.load(myrequest)
        }else {
            noDataView.isHidden = false
            noDataLabel.text = "유효하지 않은 주소입니다."
        }
        // TODO: url이 이상하다면? 피드백을 줄까?
    }
    
    // MARK: - 버튼 함수 부분
    @objc func nvBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func shoppingNVButtonTapped() {
        changerightBarButtinImage()
    }
    func changeImage(_ id:String) {
        if likeRepository.getLikeList().contains(id) {
            navigationItem.rightBarButtonItem?.image = .shoppingImage
        }else{
            navigationItem.rightBarButtonItem?.image = .unshoppingImage
        }
    }
    private func changerightBarButtinImage() {
        let likeBool = likeRepository.getLikeList().contains(item.productId) //리스트에 있으면 true 없으면 false
        let folder = likeRepository.fetchFolder()
            if !likeBool{ // 좋아요가 눌려있다면?
                if folder.count == 1{
                    likeRepository.toggleLike(item, folder: folder.first!)
                    changeImage(item.productId)
                }else {
                    let alert = UIAlertController(
                        title: nil,
                        message: nil,
                        preferredStyle: .actionSheet
                    )
                    for i in 0..<folder.count{
                        let action = UIAlertAction(title: folder[i].folderName, style: .default) { _ in
                            self.likeRepository.toggleLike(self.item, folder: folder[i])
                            self.changeImage(self.item.productId)
                        }
                        alert.addAction(action)
                    }
                    let cancel = UIAlertAction(title: "취소", style: .cancel)
                    alert.addAction(cancel)
                    present(alert, animated: true)
                }
            }else{ // 좋아요가 안눌려있다면
                self.likeRepository.toggleLike(self.item, folder: nil)
                changeImage(item.productId)
            }
        
    }
    
    
}
extension NetworkViewController: WKNavigationDelegate{
    // MARK: - 웹페에지 로딩 함수
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoadingIndicator()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoadingIndicator()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoadingIndicator()
        errorAlert(message: "네트워크 오류가 발생했습니다.")
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        hideLoadingIndicator()
        errorAlert(message: "네트워크 연결이 끊겼습니다.")
        
    }
    private func showLoadingIndicator() {
        loadingIndicator.startAnimating()
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
    }
    
    private func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
    }
}
