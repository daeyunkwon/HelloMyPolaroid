//
//  PhotoCollectionViewCell.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/24/24.
//

import UIKit

import Kingfisher
import SnapKit

final class PhotoCollectionViewCell: BaseCollectionViewCell {
     
    //MARK: - Properties
    
    enum CellType {
        case trend
        case search
        case like
    }
    var cellType: CellType? {
        didSet {
            guard let cellType = self.cellType else { return }
            
            switch cellType {
            case .trend:
                photoImageView.layer.cornerRadius = 10
                likeButton.isHidden = true
            
            case .search:
                photoImageView.layer.cornerRadius = 0
                likeButton.isHidden = false
                
            case .like:
                photoImageView.layer.cornerRadius = 0
                likeButton.isHidden = false
                starImageView.isHidden = true
                likeCountLabel.isHidden = true
                capsuleBackView.isHidden = true
            }
        }
    }
    
    var photo: Photo?
    var photoImage: UIImage?
    
    var isLikeButtonSelected = false {
        didSet {
            updateLikeButtonAppearance()
        }
    }
    
    weak var delegate: PhotoCollectionViewCellDelegate?
    
    private let repository = LikedPhotoRepository()
    
    //MARK: - UI Components
    
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
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
    
    lazy var likeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "like_circle_inactive")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return btn
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
        
        contentView.addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(photoImageView).inset(10)
            make.size.equalTo(30)
        }
    }
    
    override func configureUI() {
        DispatchQueue.main.async {
            self.capsuleBackView.layer.cornerRadius = self.capsuleBackView.frame.height / 2
        }
    }
    
    //MARK: - Actions
    
    @objc private func likeButtonTapped() {
        self.delegate?.likeButtonTapped(senderCell: self)
    }
    
    //MARK: - Methods
    
    private func updateLikeButtonAppearance() {
        if isLikeButtonSelected {
            likeButton.setImage(UIImage(named: "like_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "like_circle_inactive")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    func cellConfig(photo: Photo) {
        let url = URL(string: photo.urls.small)
        self.photoImageView.kf.setImage(with: url) { result in
            switch result {
            case .success(_):
                self.photoImage = self.photoImageView.image
            case .failure(_):
                self.photoImage = nil
            }
        }
        self.likeCountLabel.text = photo.likes.formatted()
        
        if repository.isSaved(photoID: photo.id) {
            self.isLikeButtonSelected = true
        } else {
            self.isLikeButtonSelected = false
        }
    }
    
    func cellConfig(likedPhoto: LikedPhoto) {
        self.photoImageView.image = ImageFileManager.shared.loadImageToDocument(filename: likedPhoto.photoID)
        self.photoImage = self.photoImageView.image
        
        self.isLikeButtonSelected = true
    }
}
