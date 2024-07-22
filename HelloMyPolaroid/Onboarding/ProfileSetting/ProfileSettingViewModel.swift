//
//  ProfileSettingViewModel.swift
//  HelloMyPoraroid
//
//  Created by 권대윤 on 7/22/24.
//

import Foundation

final class ProfileSettingViewModel {
    
    //MARK: - Properties
    
    
    //MARK: - Inputs
    
    var inputViewDidLoad = Observable<Void?>(nil)
    
    //MARK: - Ouputs
    
    private(set) var outputProfileImageName = Observable<String>("")
    
    //MARK: - Init
    
    init() {
        transform()
    }
    
    private func transform() {
        inputViewDidLoad.bind { [weak self] _ in
            self?.randomProfileImageName()
        }
    }
    
    //MARK: - Methods
    
    private func randomProfileImageName() {
        let name = Constant.ProfileImage.allCases.randomElement()?.rawValue ?? "profile_0"
        self.outputProfileImageName.value = name
    }

}
