//
//  SearchResultCollectionViewCell.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/15/24.
//

import UIKit

import SnapKit
import Kingfisher

class SearchResultCollectionViewCell: UICollectionViewCell {
    let image = UIImageView()
    let likeButton = UIButton()
    let mallNameLabel = UILabel()
    let titleLabel = UILabel()
    let lpriceLabel = UILabel()
    
    var likeTapped: () -> () = {}
    
    let searchDataModel = SearchDataModel.shared
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarch()
        setUpLayout()
        setUpUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    // MARK: - connect 부분
    func setUpHierarch() {
        contentView.addSubview(image)
        contentView.addSubview(likeButton)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(lpriceLabel)
        
    }
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        image.layer.cornerRadius = 10
    }
    
    // MARK: - Layout 부분
    func setUpLayout() {
        image.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.7)
        }
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(45)
            make.trailing.equalTo(image.snp.trailing).inset(10)
            make.bottom.equalTo(image.snp.bottom).inset(10)
        }
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        lpriceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
    }
    
    // MARK: - UI 세팅 부분 (정적)
    func setUpUI() {
        contentView.backgroundColor = .backgroundColor
        
        image.clipsToBounds = true
//        image.layer.cornerRadius = 10
        
        //likeButton.setImage(.shoppingImage, for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        likeButton.layer.cornerRadius = 10
        
        mallNameLabel.font = .systemFont(ofSize: 13)
        mallNameLabel.textColor = .textFieldBackgroundColor
        mallNameLabel.numberOfLines = 1
        mallNameLabel.textAlignment = .left
        
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .textColor
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2

        lpriceLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        lpriceLabel.textColor = .textColor
        lpriceLabel.textAlignment = .left
        lpriceLabel.numberOfLines = 1
    }
    
    // MARK: - 동적인 세팅 부분
    func setUpData(_ data: Item) {
        let url = URL(string: data.image)!
        image.kf.setImage(with: url)
        
        mallNameLabel.text = data.mallName
        
        titleLabel.text = data.title
        
        lpriceLabel.text = "\(Int(data.lprice)!.formatted())원"
        if searchDataModel.likeList.contains(data.productId){
            likeButton.setImage(.shoppingImage, for: .normal)
            likeButton.backgroundColor = .backgroundColor
            likeButton.layer.opacity = 1
            
        }else{
            likeButton.setImage(.unshoppingImage, for: .normal)
            likeButton.backgroundColor = .settingSeperatorColor
            likeButton.layer.opacity = 0.7
            
            
        }
    }
    // TODO: 쇼핑이미지 클릭시 색 변경 및 어쩌구
    @objc func likeButtonTapped() {
        likeTapped()
    }
}

