//
//  TrendCollectionViewCell.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/24/24.
//

import UIKit

import Kingfisher
import SnapKit

final class TrendCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - UI Components
    
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let starImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "star.fill")?.applyingSymbolConfiguration(.init(font: UIFont.systemFont(ofSize: 10)))
        iv.tintColor = .yellow
        return iv
    }()
    
    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constant.Color.primaryWhite
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private let capsuleBackView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.primaryDarkGray
        return view
    }()
    
    //MARK: - Configurations
    
    override func configureLayout() {
        contentView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        photoImageView.addSubview(capsuleBackView)
        capsuleBackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        
        capsuleBackView.addSubview(starImageView)
        starImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(10)
        }
        
        capsuleBackView.addSubview(likeCountLabel)
        likeCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(starImageView)
            make.leading.equalTo(starImageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(10)
        }
        
        DispatchQueue.main.async {
            self.capsuleBackView.layer.cornerRadius = self.capsuleBackView.frame.height / 2
        }
    }
    
    //MARK: - Methods
    
    func cellConfig(photo: Photo) {
        let url = URL(string: photo.urls.small)
        self.photoImageView.kf.setImage(with: url)
        self.likeCountLabel.text = photo.likes.formatted()
    }
}
