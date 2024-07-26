//
//  UIViewController+Extension.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/24/24.
//

import UIKit

extension UIViewController {
    
    func showNetworkResponseFailAlert() {
        let alert = UIAlertController(title: "시스템 알림", message: "서버와의 연결이 실패했습니다. 잠시 후 다시 시도해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        present(alert, animated: true)
    }
    
    func showRealmErrorAlert(type: LikedPhotoRepository.RealmError) {
        var message: String
        
        switch type {
        case .failedToCreate:
            message = "선택한 사진에 좋아요 설정이 실패되었습니다. 잠시 후 다시 시도해주세요."
        case .failedToDelete:
            message = "선택한 사진에 좋아요 해제 설정이 실패되었습니다. 잠시 후 다시 시도해주세요."
        case .failedToAllDelete:
            message = "좋아요한 사진들 정보 삭제가 실패되었습니다. 잠시 후 다시 시도해주세요."
        }
        
        let alert = UIAlertController(title: "시스템 알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        present(alert, animated: true)
    }
    
}
