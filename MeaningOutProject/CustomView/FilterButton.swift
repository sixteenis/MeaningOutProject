//
//  FilterButton.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/14/24.
//

import UIKit

final class FilterButton: UIButton {
    init(type: FilterButtonEnum) {
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
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
