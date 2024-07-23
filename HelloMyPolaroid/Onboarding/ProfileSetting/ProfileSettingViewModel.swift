//
//  ProfileSettingViewModel.swift
//  HelloMyPoraroid
//
//  Created by 권대윤 on 7/22/24.
//

import UIKit

enum NicknameConditionError: LocalizedError {
    case dissatisfactionCount
    case dissatisfactionNumber
    case dissatisfactionSpecialSymbol
    
    var errorDescription: String? {
        switch self {
        case NicknameConditionError.dissatisfactionCount:
            "2글자 이상 10글자 미만으로 설정해주세요."
        case NicknameConditionError.dissatisfactionNumber:
            "닉네임에 숫자는 포함할 수 없어요."
        case NicknameConditionError.dissatisfactionSpecialSymbol:
            "닉네임에 @, #, $, % 는 포함할 수 없어요."
        }
    }
}

final class ProfileSettingViewModel {
    
    //MARK: - Properties
    
    private var mbti: [String: String] = [
        "first": "",
        "second": "",
        "third": "",
        "fourth": "",
    ]
    
    //MARK: - Inputs
    
    var inputViewDidLoad = Observable<Void?>(nil)
    
    var inputNicknameTextFieldChanged = Observable<String>("")
    
    var inputMBTIWordButtonTapped = Observable<Int?>(nil)
    
    var inputCompleteButtonTapped = Observable<UIImage?>(nil)
    
    //MARK: - Outputs
    
    private(set) var outputProfileImageName = Observable<String>("")
    
    private(set) var outputValidationText = Observable<String>("")
    
    private(set) var outputIsValid = Observable<[Bool]>([false, false])
    
    private(set) var outputMBTIData = Observable<[String: String]>([:])
    
    private(set) var outputCreateUserDataSucceed = Observable<Bool>(false)
    
    //MARK: - Init
    
    init() {
        transform()
    }
    
    private func transform() {
        inputViewDidLoad.bind { [weak self] _ in
            self?.randomProfileImageName()
        }
        
        inputNicknameTextFieldChanged.bind { [weak self] text in
            self?.validationNickname(text: text)
        }
        
        inputMBTIWordButtonTapped.bind { [weak self] buttonTagValue in
            guard let buttonTagValue = buttonTagValue else { return }
            self?.updateMBTIDictionary(tag: buttonTagValue)
            self?.validationMBTI()
            self?.outputMBTIData.value = self?.mbti ?? [:]
        }
        
        inputCompleteButtonTapped.bind { [weak self] _ in
            print("실행")
        }
    }
    
    //MARK: - Methods
    
    private func randomProfileImageName() {
        let name = Constant.ProfileImage.allCases.randomElement()?.rawValue ?? "profile_0"
        self.outputProfileImageName.value = name
    }
    
    private func updateMBTIDictionary(tag: Int) {
        switch tag {
        case 0:
            if mbti["first"] == "" || mbti["first"] == "I" {
                self.mbti["first"] = "E"
            } else {
                self.mbti["first"] = ""
            }
            
        case 1:
            if mbti["first"] == "" || mbti["first"] == "E" {
                self.mbti["first"] = "I"
            } else {
                self.mbti["first"] = ""
            }
            
        case 2:
            if mbti["second"] == "" || mbti["second"] == "N" {
                self.mbti["second"] = "S"
            } else {
                self.mbti["second"] = ""
            }
            
        case 3:
            if mbti["second"] == "" || mbti["second"] == "S" {
                self.mbti["second"] = "N"
            } else {
                self.mbti["second"] = ""
            }
            
        case 4:
            if mbti["third"] == "" || mbti["third"] == "F" {
                self.mbti["third"] = "T"
            } else {
                self.mbti["third"] = ""
            }
            
        case 5:
            if mbti["third"] == "" || mbti["third"] == "T" {
                self.mbti["third"] = "F"
            } else {
                self.mbti["third"] = ""
            }
            
        case 6:
            if mbti["fourth"] == "" || mbti["fourth"] == "P" {
                self.mbti["fourth"] = "J"
            } else {
                self.mbti["fourth"] = ""
            }
            
        case 7:
            if mbti["fourth"] == "" || mbti["fourth"] == "J" {
                self.mbti["fourth"] = "P"
            } else {
                self.mbti["fourth"] = ""
            }
        default:
            break
        }
    }
    
    private func validationMBTI() {
        if mbti["first"] != "" && mbti["second"] != "" && mbti["third"] != "" && mbti["fourth"] != "" {
            self.outputIsValid.value[1] = true
        } else {
            self.outputIsValid.value[1] = false
        }
    }
    
    private func validationNickname(text: String) {
        do {
            let result = try checkNicknameCondition(target: text)
            if result {
                self.outputValidationText.value = "사용 가능한 닉네임입니다 :D"
                self.outputIsValid.value[0] = true
            }
        } catch {
            print("Error:", error, error.localizedDescription)

            self.outputValidationText.value = error.localizedDescription
            self.outputIsValid.value[0] = false
        }
    }
    
    private func checkNicknameCondition(target text: String) throws -> Bool {
        
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        
        guard trimmedText.count >= 2 && trimmedText.count < 10 else {
            throw NicknameConditionError.dissatisfactionCount
        }
        
        guard !trimmedText.contains("@") && !trimmedText.contains("#") && !trimmedText.contains("$") && !trimmedText.contains("%") else {
            throw NicknameConditionError.dissatisfactionSpecialSymbol
        }
        
        guard !trimmedText.contains("1") && !trimmedText.contains("2") && !trimmedText.contains("3") && !trimmedText.contains("4") && !trimmedText.contains("5") && !trimmedText.contains("6") && !trimmedText.contains("7") && !trimmedText.contains("8") && !trimmedText.contains("9") && !trimmedText.contains("0") else {
            throw NicknameConditionError.dissatisfactionNumber
        }
        
        return true
    }
    
    private func createUserData(profileImage: UIImage?) {
        var profileImageName: String?
        for item in Constant.ProfileImage.allCases {
            if UIImage(named: item.rawValue) == profileImage {
                profileImageName = item.rawValue
            }
        }
        UserDefaultsManager.shared.profile = profileImageName
       
        UserDefaultsManager.shared.nickname = self.inputNicknameTextFieldChanged.value
        
        UserDefaultsManager.shared.mbti = self.mbti
        
        self.outputCreateUserDataSucceed.value = true
    }

}
