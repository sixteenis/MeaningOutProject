//
//  FilterButton.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/14/24.
//

import UIKit

final class FilterButtonView: UIButton {
    let type: FilterButtonEnum
    init(type: FilterButtonEnum) {
        self.type = type
        super.init(frame: .zero)
        setTitle(type.rawValue, for: .normal)
        titleLabel?.font = type.titleFont
        setTitleColor(type.noSelectTextColor, for: .normal)
        backgroundColor = type.noSelectBackground
        layer.cornerRadius = type.radius
        layer.borderWidth = type.borderWidth
        layer.borderColor = type.borderColor
        contentMode = .center
    }
    func select() {
        setTitleColor(type.SelectTextColor, for: .normal)
        backgroundColor = type.SelectBackground
    }
    func noselect() {
        setTitleColor(type.noSelectTextColor, for: .normal)
        backgroundColor = type.noSelectBackground
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
