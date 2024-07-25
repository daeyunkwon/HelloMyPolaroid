//
//  File.swift
//  HelloMyPoraroid
//
//  Created by 권대윤 on 7/22/24.
//

import UIKit

import SnapKit

final class ProfileCircleWithCameraIcon: UIView {
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.borderWidth = 5
        iv.layer.borderColor = Constant.Color.signatureColor.cgColor
        iv.layer.cornerRadius = 60
        iv.alpha = 1
        iv.clipsToBounds = true
        return iv
    }()
    
    let cameraIconButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(Constant.Icon.camera?.applyingSymbolConfiguration(.init(font: UIFont.systemFont(ofSize: 20), scale: .small)), for: .normal)
        btn.setTitle("", for: .normal)
        btn.tintColor = Constant.Color.primaryWhite
        btn.backgroundColor = Constant.Color.signatureColor
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        addSubview(cameraIconButton)
        cameraIconButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.trailing.equalTo(profileImageView.snp.trailing)
            make.bottom.equalTo(profileImageView.snp.bottom)
        }
    }
}
