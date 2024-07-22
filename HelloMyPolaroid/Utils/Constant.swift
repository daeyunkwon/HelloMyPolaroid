//
//  Constant.swift
//  HelloMyPoraroid
//
//  Created by 권대윤 on 7/22/24.
//

import UIKit

enum Constant {
    
    enum Color {
        static let signatureColor = UIColor(red: 0.09, green: 0.44, blue: 0.95, alpha: 1.00)
        static let primaryRed = UIColor(red: 0.94, green: 0.27, blue: 0.32, alpha: 1.00)
        static let primaryLightGray = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
        static let primaryMediumGray = UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 1.00)
        static let primaryDarkGray = UIColor(red: 0.30, green: 0.34, blue: 0.32, alpha: 1.00)
        static let primaryBlack = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00)
        static let primaryWhite = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
    }
    
    enum Font {
        static let system20 = UIFont.systemFont(ofSize: 20)
        static let system19 = UIFont.systemFont(ofSize: 19)
        static let system18 = UIFont.systemFont(ofSize: 18)
        static let system17 = UIFont.systemFont(ofSize: 17)
        static let system16 = UIFont.systemFont(ofSize: 16)
        static let system15 = UIFont.systemFont(ofSize: 15)
        static let system14 = UIFont.systemFont(ofSize: 14)
        static let system13 = UIFont.systemFont(ofSize: 13)
        static let onboardingButtonTitleFont = UIFont.boldSystemFont(ofSize: 16)
    }
    
    enum Icon {
        static let camera = UIImage(systemName: "camera.fill")
        static let star = UIImage(systemName: "star")
        static let starFill = UIImage(systemName: "star.fill")
        static let heart = UIImage(systemName: "heart")
        static let heartFill = UIImage(systemName: "heart.fill")
    }
    
    enum Image {
        static let launchTitle = #imageLiteral(resourceName: "launchTitle")
        static let launchImage = #imageLiteral(resourceName: "launchImage")
    }
    
    enum ProfileImage: String, CaseIterable {
        case profile_0
        case profile_1
        case profile_2
        case profile_3
        case profile_4
        case profile_5
        case profile_6
        case profile_7
        case profile_8
        case profile_9
        case profile_10
        case profile_11
    }
}
