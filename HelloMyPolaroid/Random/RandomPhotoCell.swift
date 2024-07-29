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
    
    //MARK: - UI Components
    
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    //MARK: - Configurations
    
    override func configureLayout() {
        contentView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Methods
    
    func cellConfig(data: Photo) {
        let url = URL(string: data.urls.small)
        self.photoImageView.kf.setImage(with: url)
    }

}
