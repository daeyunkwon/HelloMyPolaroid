//
//  TabBarController.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/24/24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    //MARK: - Configurations
    
    private func setupTabBar() {
        let mainVC = UINavigationController(rootViewController: TrendViewController())
        let likeVC = UINavigationController(rootViewController: UIViewController())
        likeVC.view.backgroundColor = .white
        let searchVC = UINavigationController(rootViewController: SearchPhotoViewController())
        let heartVC = UINavigationController(rootViewController: UIViewController())
        heartVC.view.backgroundColor = .white
        
        mainVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_trend_inactive"), selectedImage: UIImage(named: "tab_trend"))
        likeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_random_inactive"), selectedImage: UIImage(named: "tab_random"))
        searchVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_search_inactive"), selectedImage: UIImage(named: "tab_search"))
        heartVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_like_inactive"), selectedImage: UIImage(named: "tab_like"))
        
        self.setViewControllers([mainVC, likeVC, searchVC, heartVC], animated: false)
    }
}
