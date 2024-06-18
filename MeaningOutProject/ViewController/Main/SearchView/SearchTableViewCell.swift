//
//  SearchTableViewCell.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/14/24.
//

import UIKit

import SnapKit

final class SearchTableViewCell: UITableViewCell {
    let recentImage = UIImageView()
    let searchTitle = UILabel()
    let delectButton = UIButton(type: .custom)
    
    var didDelete: () -> ()  = { }
    
    let searchDataModel = SearchDataModel.shared
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpHierarch()
        setUpLayout()
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - connect 부분
    private func setUpHierarch() {
        contentView.addSubview(recentImage)
        contentView.addSubview(searchTitle)
        contentView.addSubview(delectButton)
        
    }
    
    // MARK: - Layout 부분
    private func setUpLayout() {
        recentImage.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.4)
            make.width.equalTo(recentImage.snp.height)
        }
        searchTitle.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(recentImage.snp.trailing).offset(15)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(45)
        }
        delectButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.3)
            make.width.equalTo(recentImage.snp.height)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - UI 세팅 부분 (정적)
    private func setUpUI() {
        recentImage.image = .searchCellClockImage
        recentImage.tintColor = .textColor
        
        searchTitle.font = .systemFont(ofSize: 14)
        searchTitle.numberOfLines = 1
        
        delectButton.setImage(.searchCellXmarkImage, for: .normal)
        delectButton.tintColor = .textColor
        delectButton.addTarget(self, action: #selector(delectButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - 동적인 세팅 부분
    func setUpData(data: String) {
        searchTitle.text = data
        
    }
    // MARK: - 버튼 기능 부분
    @objc func delectButtonTapped() {
        didDelete()
    }

}

