//
//  UserProfileAndLikeButtonView.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/29/24.
//

import UIKit

import SnapKit

final class UserProfileAndLikeButtonView: UIView {
    
    //MARK: - Properties
    
    var isLikeButtonSelected = false {
        didSet {
            updateLikeButtonAppearance()
        }
    }
    
    //MARK: - UI Components
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 17.5
        iv.clipsToBounds = true
        return iv
    }()

    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.system14
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 11)
        return label
    }()

    let likeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "like_inactive"), for: .normal)
        return btn
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configurations
    
    private func configureLayout() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(35)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.centerY.equalTo(profileImageView).offset(-6)
        }
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(1)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(profileImageView)
            make.size.equalTo(30)
        }
    }
    
    private func configureUI() {
        backgroundColor = .clear
    }
    
    private func updateLikeButtonAppearance() {
        if isLikeButtonSelected {
            likeButton.setImage(UIImage(named: "like")?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "like_inactive")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
}

