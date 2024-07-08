//
//  LikeIItemShowTableViewCell.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/8/24.
//

import UIKit
import SnapKit
class LikeFolderShowTableViewCell: UITableViewCell {
    let image = UIImageView()
    let title = UILabel()
    let count = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpHierarchy()
        setUpLayout()
        setUpView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func setUpHierarchy() {
        contentView.addSubview(image)
        contentView.addSubview(title)
        contentView.addSubview(count)
        
    }
    func setUpLayout() {
        image.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.size.equalTo(50)
        }
        title.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(image.snp.trailing).offset(20)
        }
        count.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
    }
    func setUpView() {
        image.layer.cornerRadius = image.frame.width / 2
        
        title.font = .boldSystemFont(ofSize: 16)
        title.textColor = .textColor
        title.textAlignment = .left
        title.numberOfLines = 1
        
        count.font = .boldSystemFont(ofSize: 26)
        count.textColor = .textColor
        count.textAlignment = .right
        count.numberOfLines = 1
        
    }
    func changView(_ data: Folder) {
        print("1123")
        image.image = UIImage(systemName: data.image)
        title.text = data.folderName
        count.text = data.likeLists.count.formatted()
    }
}
