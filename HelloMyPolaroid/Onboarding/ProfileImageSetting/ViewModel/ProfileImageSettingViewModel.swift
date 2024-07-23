//
//  ProfileImageSettingViewModel.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/23/24.
//

import UIKit

final class ProfileImageSettingViewModel {
    
    //MARK: - Properties
    
    var closureForProfileImageSend: (UIImage?) -> Void = { sender in }
    
    var selectedProfileImage: UIImage?
    
    //MARK: - Inputs
    
    var inputViewDidLoad = Observable<Void?>(nil)
    
    var inputSelectedRow = Observable<Int?>(nil)
    
    //MARK: - Outputs
    
    private(set) var outputViewDidLoad = Observable<UIImage?>(nil)
    
    private(set) var outputProfileImageNameList = Constant.ProfileImage.allCases
    
    private(set) var outputSelectedProfileImageName = Observable<String?>("")
    
    //MARK: - Init
    
    init() {
        transform()
    }
    
    private func transform() {
        inputViewDidLoad.bind { [weak self] _ in
            self?.outputViewDidLoad.value = self?.selectedProfileImage
        }
        
        inputSelectedRow.bind { [weak self] row in
            guard let row = row else { return }
            self?.outputSelectedProfileImageName.value = self?.outputProfileImageNameList[row].rawValue
            self?.closureForProfileImageSend(UIImage(named: self?.outputProfileImageNameList[row].rawValue ?? ""))
        }
    }
    
}
