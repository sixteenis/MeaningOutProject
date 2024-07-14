//
//  SearchResultCollectionViewCell.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/15/24.
//

import UIKit

import SnapKit

final class SearchResultCollectionViewCell: BaseCollectioViewCell {
    private let image = UIImageView()
    private let likeButton = UIButton()
    private let mallNameLabel = UILabel()
    private let titleLabel = UILabel()
    private let lpriceLabel = UILabel()
    
    var likeTapped: () -> () = {}
    
    let searchDataModel = SearchDataModel()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    // MARK: - connect 부분
    override func setUpHierarchy() {
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
    override func setUpLayout() {
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
    override func setUpView() {
        contentView.backgroundColor = .backgroundColor
        
        image.clipsToBounds = true

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
    func setUpData(_ data: Item, bool: Bool) {
        let url = URL(string: data.image)!
        self.image.image = nil
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {return}
            do {
                let imageData = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    if self.image.image != UIImage(data: imageData){
                        self.image.image = UIImage(data: imageData)
                    }

                }
            }catch {
                DispatchQueue.main.async {
                    self.image.image = UIImage(systemName: "bag")
                }
            }
        }
        
        mallNameLabel.text = data.mallName
        
        var beforText = data.title.replacingOccurrences(of: "<b>", with: "")
        beforText = beforText.replacingOccurrences(of: "</b>", with: "")
    
        titleLabel.text = beforText
        
        
        lpriceLabel.text = "\(Int(data.lprice)!.formatted())원"
        if bool{ //[201,206] 101 view
            likeButton.setImage(.shoppingImage, for: .normal)
            likeButton.backgroundColor = .backgroundColor
            likeButton.layer.opacity = 1
            
        }else{
            likeButton.setImage(.unshoppingImage, for: .normal)
            likeButton.backgroundColor = .settingSeperatorColor
            likeButton.layer.opacity = 0.7
            
            
        }
    }
    
    func setUpDataFolder(_ data: LikeList) {
        let url = URL(string: data.image)!
        // 킹피셔 안쓰고 이미지 처리
        self.image.image = nil
        //계속 밑으로 내리면 이전 이미지가 뜨는 문제 해결해야됨...ㅠ..ㅠ
        DispatchQueue.global().async { [weak self] in
            do {
                let imageData = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    if self?.image.image != UIImage(data: imageData){
                        self?.image.image = UIImage(data: imageData)
                    }

                }
            }catch {
                DispatchQueue.main.async {
                    self?.image.image = UIImage(systemName: "bag")
                }
            }
        }
        
        mallNameLabel.text = data.mallName
        
        var beforText = data.title.replacingOccurrences(of: "<b>", with: "")
        beforText = beforText.replacingOccurrences(of: "</b>", with: "")
    
        titleLabel.text = beforText
        
        
        lpriceLabel.text = "\(Int(data.lprice)!.formatted())원"
        if searchDataModel.likeList[data.productId] != nil{ //[201,206] 101 view
            likeButton.setImage(.shoppingImage, for: .normal)
            likeButton.backgroundColor = .backgroundColor
            likeButton.layer.opacity = 1
            
        }else{
            likeButton.setImage(.unshoppingImage, for: .normal)
            likeButton.backgroundColor = .settingSeperatorColor
            likeButton.layer.opacity = 0.7
            
            
        }
    }
    // MARK: - 라이크 버튼 기능
    @objc func likeButtonTapped() {
        likeTapped()
    }
}

