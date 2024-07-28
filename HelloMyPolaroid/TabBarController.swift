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
        let mainVC = UINavigationController(rootViewController: TopicViewController())
        let randomVC = UINavigationController(rootViewController: UIViewController())
        randomVC.view.backgroundColor = .white
        let searchVC = UINavigationController(rootViewController: SearchPhotoViewController())
        let likeVC = UINavigationController(rootViewController: LikePhotoViewController())
        
        mainVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_trend_inactive"), selectedImage: UIImage(named: "tab_trend"))
        randomVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_random_inactive"), selectedImage: UIImage(named: "tab_random"))
        searchVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_search_inactive"), selectedImage: UIImage(named: "tab_search"))
        likeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_like_inactive"), selectedImage: UIImage(named: "tab_like"))
        
        self.setViewControllers([mainVC, randomVC, searchVC, likeVC], animated: false)
    }
}
