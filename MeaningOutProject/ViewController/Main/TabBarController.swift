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
        super.viewDidLoad()
        self.delegate = self
        
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
        // MARK: - 내부적으로 vc의 lifecycle로 동작하므로 의도하지 않은 문제가 발생
        // MARK: -할 수 있음. 개선해보자
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
