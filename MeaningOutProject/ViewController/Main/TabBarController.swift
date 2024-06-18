//
//  TabBarController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/14/24.
//

import UIKit

import SnapKit
final class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private let line = UIView()
    override func viewDidLoad() {
        self.delegate = self

        super.viewDidLoad()
        tabBar.tintColor = .mainOragieColor
        tabBar.unselectedItemTintColor = .textFieldBackgroundColor
        
        
        let searchVC = SearchViewController()
        let nav1 = UINavigationController(rootViewController: searchVC)
        nav1.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        let settingVC = SettingViewController()
        let nav2 = UINavigationController(rootViewController: settingVC)
        nav2.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "person"), tag: 1)
        
        setUpline()
        setViewControllers([nav1,nav2], animated: true)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        viewController.viewWillAppear(true)
    }
    func setUpline() {
        view.addSubview(line)
        line.snp.makeConstraints { make in
            make.bottom.equalTo(tabBar.snp.top)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
            
        }
        line.backgroundColor = .lineColor
    }
    
}
