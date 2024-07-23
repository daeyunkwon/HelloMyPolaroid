//
//  ProfileImageCollectionViewCell.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/23/24.
//

import UIKit

import SnapKit

final class ProfileImageCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - Properties
    
    enum ProfileType {
        case selected
        case unselected
    }
    var type: ProfileType = ProfileType.unselected
    
    var profile: UIImage? {
        didSet {
            self.profileImageView.image = profile
            
            switch type {
            case .selected:
                self.profileImageView.layer.borderColor = Constant.Color.signatureColor.cgColor
                self.profileImageView.layer.borderWidth = 3
                self.profileImageView.alpha = 1
            
            case .unselected:
                self.profileImageView.layer.borderColor = Constant.Color.primaryMediumGray.cgColor
                self.profileImageView.layer.borderWidth = 1
                self.profileImageView.alpha = 0.5
            }
        }
    }
    
    //MARK: - UI Components
    
    private let profileImageView = ProfileCircle()
    
    //MARK: - Init
    
    override func configureLayout() {
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        DispatchQueue.main.async {
            self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width / 2
        }
    }
}
