//
//  SearchResultCollectionViewCell.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/15/24.
//

import UIKit

import SnapKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    let profileImage = SelcetProfileImageView()
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
        contentView.addSubview(profileImage)
    }
//    override func layoutSublayers(of layer: CALayer) {
//        super.layoutSublayers(of: layer)
//        contentView.layer.cornerRadius = contentView.frame.width / 2
//    }
    // MARK: - Layout 부분
    func setUpLayout() {
        profileImage.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - UI 세팅 부분 (정적)
    func setUpUI() {
        contentView.clipsToBounds = true
        
        contentView.backgroundColor = .backgroundColor
    }
    
    // MARK: - 동적인 세팅 부분
//    func setUpData(_ data: String, select: Bool) {
//        profileImage.selectedProfile(data, select: select)
//
//    }
    
}

