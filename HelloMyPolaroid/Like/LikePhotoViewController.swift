//
//  LikePhotoViewController.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/27/24.
//

import UIKit

import Kingfisher
import RealmSwift

final class LikePhotoViewController: BasePhotoListViewController {
    
    //MARK: - Properties
    
    private let repository = LikedPhotoRepository()
    
    private enum OrderType: String {
        case latest
        case oldest
    }
    private var orderType: OrderType = .latest
    
    private var likedPhotos: Results<LikedPhoto>! {
        didSet {
            self.photoView.photoCollectionView.reloadData()
            
            if likedPhotos.isEmpty {
                photoView.showEmptySearchResultLabel()
            } else {
                photoView.hideEmptySearchResultLabel()
            }
        }
    }
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "MY POLAROID"
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Configurations
    
    override func setupColorOptionCollectionView() {
        super.setupColorOptionCollectionView()
        photoView.colorOptionCollectionView.delegate = self
        photoView.colorOptionCollectionView.dataSource = self
    }
    
    override func setupPhotoCollectionView() {
        super.setupPhotoCollectionView()
        photoView.photoCollectionView.dataSource = self
        photoView.photoCollectionView.delegate = self
    }
    
    override func configureUI() {
        super.configureUI()
        
        photoView.viewType = .like
    }
    
    //MARK: - Actions
    
    override func sortToggleButtonTapped() {
        photoView.isSortButtonSelected.toggle()
        
        if photoView.isSortButtonSelected {
            self.orderType = .oldest
        } else {
            self.orderType = .latest
        }
        
        fetchData()
    }
    
    //MARK: - Methods
    
    private func fetchData() {
        var ascending: Bool
        
        switch orderType {
        case .latest:
            ascending = false
        case .oldest:
            ascending = true
        }
        
        let result = repository.fetchAllItemSorted(key: .date, ascending: ascending)
        self.likedPhotos = result
    }

}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension LikePhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case photoView.colorOptionCollectionView:
            return colorOptions.count
            
        case photoView.photoCollectionView:
            return likedPhotos.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case photoView.colorOptionCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorOptionCollectionViewCell.identifier, for: indexPath) as? ColorOptionCollectionViewCell else {
                print("Failed to dequeue a ColorOptionCollectionViewCell. Using default UICollectionViewCell.")
                return UICollectionViewCell()
            }
            
            let data = self.colorOptions[indexPath.row]
            cell.cellConfig(color: data)
            
            return cell
            
        case photoView.photoCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
                print("Failed to dequeue a PhotoCollectionViewCell. Using default UICollectionViewCell.")
                return UICollectionViewCell()
            }
            
            cell.delegate = self
            cell.cellType = .like
            cell.cellConfig(likedPhoto: self.likedPhotos[indexPath.row])
            
            let data = self.likedPhotos[indexPath.row]
            cell.photo = Photo(id: data.photoID, createdAt: data.created, width: data.width, height: data.height, urls: Urls(raw: data.photoImageURLRaw, small: data.photoImageURLSmall), likes: data.likeCount, user: User(name: data.username, profileImage: ProfileImage(small: data.userProfileImageURLSmall, medium: data.userProfileImageURLMedium, large: data.userProfileImageURLLarge)))
            
            return cell
        default:
            return UICollectionViewCell()
         }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PhotoDetailViewController()
        vc.likedPhoto = self.likedPhotos[indexPath.row]
        pushViewController(vc)
    }
    
}

//MARK: - PhotoCollectionViewCellDelegate

extension LikePhotoViewController: PhotoCollectionViewCellDelegate {
    
    func likeButtonTapped(senderCell: PhotoCollectionViewCell) {
        guard let photo = senderCell.photo else { return }
        guard let image = senderCell.photoImage else { return }
        
        let data = LikedPhoto(photoID: photo.id, created: photo.createdAt, width: photo.width, height: photo.height, photoImageURLRaw: photo.urls.raw, photoImageURLSmall: photo.urls.small, userProfileImageURLSmall: photo.user.profileImage.small, userProfileImageURLMedium: photo.user.profileImage.medium, userProfileImageURLLarge: photo.user.profileImage.large, username: photo.user.name, likeCount: photo.likes)
        
        senderCell.isLikeButtonSelected.toggle()
        
        if senderCell.isLikeButtonSelected {
            //좋아요한 경우
            self.repository.create(data: data) { [weak self] result in
                guard let self else { return }
                
                senderCell.likeButton.isEnabled = false
                
                switch result {
                case .success(_):
                    //사진 이미지를 파일에 저장
                    ImageFileManager.shared.saveImageToDocument(image: image, filename: data.photoID)
                    
                    //유저 프로필 이미지를 파일에 저장
                    if let url = URL(string: data.userProfileImageURLLarge) {
                        ImageDownloader.default.downloadImage(with: url) { result in
                            switch result {
                            case .success(let value):
                                ImageFileManager.shared.saveImageToDocument(image: value.image, filename: data.userProfileID)
                                self.showLikeAddedToast()
                                senderCell.likeButton.isEnabled = true
                                
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                    self.showRealmErrorAlert(type: error)
                    senderCell.isLikeButtonSelected.toggle() //버튼 상태 복귀
                }
            }
        } else {
            //좋아요 취소한 경우
            self.repository.deleteItem(photoID: data.photoID) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    print(success)
                    ImageFileManager.shared.removeImageFromDocument(filename: data.photoID)
                    ImageFileManager.shared.removeImageFromDocument(filename: data.userProfileID)
                    self.showLikeRemovedToast()
                    
                case .failure(let error):
                    print(error)
                    self.showRealmErrorAlert(type: error)
                    senderCell.isLikeButtonSelected.toggle() //버튼 상태 복귀
                }
            }
        }
    }
}

