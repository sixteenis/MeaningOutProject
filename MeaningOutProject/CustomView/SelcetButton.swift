//
//  SelcetButton.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/13/24.
//

import UIKit

class SelcetButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.whitetitleColor, for: .normal)
        backgroundColor = .mainOragieColor
        contentMode = .center
        layer.cornerRadius = 20
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
