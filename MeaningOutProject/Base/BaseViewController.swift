//
//  BaseViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/8/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpHierarchy()
        setUpView()
        setUpLayout()
    }
    
    func setUpHierarchy() {}
    func setUpLayout() {}
    func setUpView() {}
    
}
