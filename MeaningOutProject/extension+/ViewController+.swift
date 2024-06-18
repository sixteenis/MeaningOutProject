//
//  ViewController+.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/14/24.
//

import UIKit

extension UIViewController {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

