//
//  OnboardingView.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/25/24.
//

import UIKit
import SnapKit
protocol OnboardingViewDelegate: AnyObject {
    func startButtonTapped()
}
class OnboardingView: BaseView {
    weak var delegate: OnboardingViewDelegate?
    private let logoImage = {
        let view = UIImageView()
        view.image = .logo
        view.contentMode = .scaleAspectFill
        return view
    }()
    private let mainImage = {
        let view = UIImageView()
        view.image = .launch
        view.contentMode = .scaleAspectFill
        return view
    }()
    private lazy var startButton = {
        let view = SelcetButton(title: "시작하기")
        view.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return view
    }()
     
    override internal func setUpHierarchy() {
        self.addSubview(logoImage)
        self.addSubview(mainImage)
        self.addSubview(startButton)
    }
    override internal func setUpLayout() {
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(50)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(25)
            make.bottom.equalTo(mainImage.snp.top).offset(-55)
        }
        mainImage.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(self.snp.width).multipliedBy(0.75)
            make.height.equalTo(mainImage.snp.width).multipliedBy(1.25)
            
        }
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(45)
        }
    }
    @objc func startButtonTapped() {
        guard let delegate = self.delegate else { return }
        delegate.startButtonTapped()
    }
    
}
