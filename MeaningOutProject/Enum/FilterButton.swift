//
//  NetWorkFilterEnum.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/15/24.
//

import UIKit

enum FilterButtonEnum: String {
    case accuracy = "정확도"
    case date = "날짜순"
    case priceUp = "가격높은순"
    case priceDown = "가격낮은순"
    var titleFont: UIFont {
        return UIFont.systemFont(ofSize: 14)
    }
    var noSelectTextColor: UIColor {
        return UIColor.textColor
    }
    var SelectTextColor: UIColor {
        return UIColor.backgroundColor
    }
    var noSelectBackground: UIColor {
        return UIColor.backgroundColor
    }
    var SelectBackground: UIColor {
        return UIColor.buttonSelectColor
    }
    var borderColor: CGColor {
        return UIColor.textFieldBackgroundColor.cgColor
    }
    var borderWidth: CGFloat {
        return 1
    }
    var radius: CGFloat {
        return 15
    }
}
