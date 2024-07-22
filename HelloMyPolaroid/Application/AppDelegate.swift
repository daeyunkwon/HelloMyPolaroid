//
//  AppDelegate.swift
//  HelloMyPoraroid
//
//  Created by 권대윤 on 7/22/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //UILabel Appearance 전역설정
        UILabel.appearance().textColor = Constant.Color.primaryBlack
        
        //UINavigationBar Appearance 전역설정
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Constant.Color.primaryWhite
        UINavigationBar.appearance().tintColor = Constant.Color.primaryBlack
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        //UITabBar Appearance 전역설정
        UITabBar.appearance().tintColor = Constant.Color.primaryBlack
        UITabBar.appearance().unselectedItemTintColor = Constant.Color.primaryLightGray
        
        sleep(2)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

