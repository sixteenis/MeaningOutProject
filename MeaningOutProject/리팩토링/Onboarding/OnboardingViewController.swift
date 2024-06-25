//
//  OnboardingViewController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/13/24.
//

import UIKit

final class OnboardingViewController: UIViewController {
    private let rootView = OnboardingView()
    private let userModel = UserModel.shared
    override func loadView() {
        self.view = rootView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addDelegate()
    }
    private func addDelegate() {
        self.rootView.delegate = self
    }
}

extension OnboardingViewController: OnboardingViewDelegate {
    @objc func startButtonTapped() {
        userModel.getRandomProfile()
        navigationController?.pushViewController(ProfileSetViewController(), animated: true)
    }
}

