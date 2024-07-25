//
//  UIViewController+Extension.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/24/24.
//

import UIKit

extension UIViewController {
    
    func showNetworkResponseFailAlert() {
        let alert = UIAlertController(title: "알림", message: "서버와의 연결이 실패했습니다. 잠시 후 다시 시도해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        present(alert, animated: true)
    }
    
}
