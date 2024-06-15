//
//  TabBarController.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/14/24.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
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
    
        
        setViewControllers([nav1,nav2], animated: true)
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let nav = viewController as? UINavigationController{
            if nav.topViewController is SettingViewController {
                viewController.viewWillAppear(true)
            }
        }
    }
}
