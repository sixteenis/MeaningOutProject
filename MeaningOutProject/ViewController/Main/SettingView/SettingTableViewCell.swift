//
//  SettingTableViewCell.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/16/24.
//

import UIKit

import SnapKit

class SettingTableViewCell: UITableViewCell {
    let mainLabel = UILabel()
    let subLabel = UILabel()
    
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
    func setUpHierarch() {
        contentView.addSubview(mainLabel)
        contentView.addSubview(subLabel)
    }
    
    // MARK: - Layout 부분
    func setUpLayout() {
        mainLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide)
            make.centerY.equalTo(contentView)
        }
        subLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.centerY.equalTo(contentView)
            
        }
    }
    
    // MARK: - UI 세팅 부분 (정적)
    func setUpUI() {
        
    }
    
    
    // MARK: - 동적인 세팅 부분
    func setUpData(data: String) {
        subLabel.isHidden = true
        mainLabel.text = data
        
    }
    func setUpData(data: String, likeCount: Int) {
        subLabel.isHidden = false
        let attributedLabel = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = .shoppingImage
        imageAttachment.bounds = CGRect(x: 0, y: -5, width: 20, height: 20)
        attributedLabel.append(NSAttributedString(attachment: imageAttachment))
        attributedLabel.append(NSAttributedString(string: "\(likeCount)개의 상품"))
        subLabel.attributedText = attributedLabel
            
        
        mainLabel.text = data
        
    }

}
