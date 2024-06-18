//
//  NetworkViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/15/24.
//

import UIKit
import WebKit

import SnapKit

final class NetworkViewController: UIViewController {
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    let webView = WKWebView()
    let noDataView = UIView()
    let noDataImage = UIImageView()
    let noDataLabel = UILabel()
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
    private func setUpHierarch() {
        view.addSubview(webView)
        
        view.addSubview(noDataView)
        noDataView.addSubview(noDataImage)
        noDataView.addSubview(noDataLabel)
    }
    
    // MARK: - Layout 부분
    private func setUpLayout() {
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
    override func viewWillAppear(_ animated: Bool) {
        changerightBarButtinImage()
    }
    
    // MARK: - UI 세팅 부분
    private func setUpUI() {
        view.backgroundColor = .backgroundColor
        webView.navigationDelegate = self
        navigationController?.navigationBar.tintColor = .buttonSelectColor
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(nvBackButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        let rightButton = UIBarButtonItem(image: .shoppingImage, style: .plain, target: self, action: #selector(shoppingNVButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
        var filterTitle = shoppingTitle?.replacingOccurrences(of: "<b>", with: "")
        filterTitle = filterTitle?.replacingOccurrences(of: "</b>", with: "")
        navigationItem.title = filterTitle
        
        noDataView.backgroundColor = .backgroundColor
        
        noDataImage.image = .noDataImage
        
        noDataLabel.font = .systemFont(ofSize: 15, weight: .heavy)
        
    }
    private func setWebView() {
        let myurl = URL(string: url)
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
        searchDataModel.LikeListFunc(id)
        changerightBarButtinImage()
    }
    private func changerightBarButtinImage() {
        if searchDataModel.likeList.contains(id) {
            navigationItem.rightBarButtonItem?.image = .shoppingImage
        }else{
            navigationItem.rightBarButtonItem?.image = .unshoppingImage
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
    func errorAlert(message: String) {
        let alert = UIAlertController(
            title: message,
            message: nil,
            preferredStyle: .alert
        )
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
