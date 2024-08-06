//
//  RandomPhotoCell.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/29/24.
//

import UIKit

import Kingfisher
import SnapKit

final class RandomPhotoCell: BaseCollectionViewCell {
    
    //MARK: - Properties
    
    var photo: Photo?
    
    var closureForDataSend: (Photo) -> Void = { sender in }
    
    //MARK: - UI Components
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var userProfileAndLikeButtonView: UserProfileAndLikeButtonView = {
        let view = UserProfileAndLikeButtonView()
        view.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return view
    }()
    
    //MARK: - Configurations
    
    override func configureLayout() {
        contentView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(userProfileAndLikeButtonView)
        userProfileAndLikeButtonView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    override func configureUI() {
        userProfileAndLikeButtonView.userNameLabel.textColor = Constant.Color.primaryWhite
        userProfileAndLikeButtonView.dateLabel.textColor = Constant.Color.primaryWhite
        userProfileAndLikeButtonView.likeButton.tintColor = Constant.Color.primaryWhite
    }
    
    //MARK: - Actions
    
    @objc func likeButtonTapped() {
        guard let data = photo else { return }
        self.closureForDataSend(data)
    }
    
    //MARK: - Methods
    
    func cellConfig(data: Photo) {
        
        userProfileAndLikeButtonView.userNameLabel.text = data.user.name
        userProfileAndLikeButtonView.dateLabel.text = formatDate(iso8601String: data.createdAt)
        userProfileAndLikeButtonView.profileImageView.kf.setImage(with: URL(string: data.user.profileImage.large))
    }
    
    private func formatDate(iso8601String: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(identifier: "UTC") ?? TimeZone.current
        let date = dateFormatter.date(from: iso8601String)
        
        dateFormatter.dateFormat = "yyyy년 M월 d일 게시됨" //표현하고 싶은 날짜 형식
        return dateFormatter.string(from: date ?? Date())
    }

}
