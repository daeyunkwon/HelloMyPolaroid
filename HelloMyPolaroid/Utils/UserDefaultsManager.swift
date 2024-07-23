//
//  UserDefaultsManager.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/23/24.
//

import UIKit

@propertyWrapper
struct UserDefaultsPropertyWrapper<T> {
    let key: String
    let defaultValue: T
    var storage: UserDefaults
    
    var wrappedValue: T {
        get {
            return self.storage.object(forKey: self.key) as? T ?? self.defaultValue
        }
        set {
            return self.storage.set(newValue, forKey: self.key)
        }
    }
}

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private init() {}
    
    private var userDefaults = UserDefaults(suiteName: "MyUserDefaults") ?? UserDefaults.standard
    
    enum Key: String, CaseIterable {
        case nickname
        case profile
        case mbti
    }
    
    @UserDefaultsPropertyWrapper(key: Key.nickname.rawValue, defaultValue: nil, storage: UserDefaults(suiteName: "MyUserDefaults") ?? UserDefaults.standard)
    var nickname: String?
    
    @UserDefaultsPropertyWrapper(key: Key.profile.rawValue, defaultValue: nil, storage: UserDefaults(suiteName: "MyUserDefaults") ?? UserDefaults.standard)
    var profile: String?
    
    @UserDefaultsPropertyWrapper(key: Key.mbti.rawValue, defaultValue: nil, storage: UserDefaults(suiteName: "MyUserDefaults") ?? UserDefaults.standard)
    var mbti: [String: String]?
    
    func removeUserData(completion: @escaping () -> Void) {
        
        if UserDefaults.standard.persistentDomain(forName: "MyUserDefaults") != nil {
            UserDefaults.standard.removePersistentDomain(forName: "MyUserDefaults")
            
        } else { //UserDefaults(suiteName: "MyUserDefaults")으로 인스턴스 생성 실패에 대비
            if let bundleID = Bundle.main.bundleIdentifier {
                print(bundleID)
                UserDefaults.standard.removePersistentDomain(forName: bundleID)
            }
        }
        
        completion()
    }
}
