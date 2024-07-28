//
//  PhotoDetailViewModel.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/27/24.
//

import UIKit

import Kingfisher

final class PhotoDetailViewModel {
    
    //MARK: - Properties
    
    private let repository = LikedPhotoRepository()
    
    private var photo: Photo?
    
    private var likedPhoto: LikedPhoto?
    
    //MARK: - Inputs
    
    var inputPhoto = Observable<Photo?>(nil)
    var inputLikedPhoto = Observable<LikedPhoto?>(nil)
    
    var inputLikeButtonTapped = Observable<Bool?>(nil)
    
    //MARK: - Outputs
    
    private(set) var outputUserProfileImage = Observable<UIImage?>(nil)
    
    private(set) var outputUsername = Observable<String?>(nil)
    
    private(set) var outputCreated = Observable<String?>(nil)
    
    private(set) var outputIsLiked = Observable<Bool>(false)
    
    private(set) var outputPhotoImage = Observable<UIImage?>(nil)
    
    private(set) var outputPhotoSize = Observable<String?>(nil)
    
    private(set) var outputPhotoViewCount = Observable<String?>(nil)
    
    private(set) var outputPhotoDownloadCount = Observable<String?>(nil)
    
    private(set) var outputShowNetworkErrorAlert = Observable<Void?>(nil)
    
    //MARK: - Init
    
    init() {
        transform()
    }
    
    private func transform() {
        inputPhoto.bind { [weak self] value in
            guard let photo = value else { return }
            self?.photo = photo
            
            self?.fetchData(with: photo.id)
            self?.setupPhotoData(username: photo.user.name, created: photo.createdAt, width: photo.width, height: photo.height, photoID: photo.id)
            
            self?.downloadImage(url: photo.user.profileImage.large, completionHandler: { image in
                if image != nil {
                    self?.outputUserProfileImage.value = image
                }
            })
            
            self?.downloadImage(url: photo.urls.small, completionHandler: { image in
                if image != nil {
                    self?.outputPhotoImage.value = image
                }
            })
        }
        
        inputLikedPhoto.bind { [weak self] value in
            guard let likedPhoto = value else { return }
            self?.likedPhoto = likedPhoto
            
            self?.fetchData(with: likedPhoto.photoID)
            self?.setupPhotoData(username: likedPhoto.username, created: likedPhoto.created, width: likedPhoto.width, height: likedPhoto.height, photoID: likedPhoto.photoID)
            
            self?.outputUserProfileImage.value = ImageFileManager.shared.loadImageToDocument(filename: likedPhoto.photoID + likedPhoto.username)
            self?.outputPhotoImage.value = ImageFileManager.shared.loadImageToDocument(filename: likedPhoto.photoID)
        }
        
        inputLikeButtonTapped.bind { [weak self] value in
            guard let value = value else { return }
            if value {
                self?.saveItemToRealm()
            } else {
                self?.deleteItemFromRealm()
            }
        }
    }
    
    //MARK: - Methods

    private func fetchData(with photoID: String) {
        NetworkManager.shared.fetchData(api: .statistics(photoID: photoID), model:Statistics.self) { [weak self] result in
            switch result {
            case .success(let value):
                self?.setupStatisticsData(data: value)
            case .failure(let error):
                print(error)
                self?.outputShowNetworkErrorAlert.value = ()
            }
        }
    }
    
    private func setupPhotoData(username: String, created: String, width: Int, height: Int, photoID: String) {
        
        self.outputUsername.value = username
        self.outputCreated.value = formatDate(iso8601String: created)
        self.outputPhotoSize.value = "\(width) x \(height)"
        
        if self.repository.isSaved(photoID: photoID) {
            self.outputIsLiked.value = true
        } else {
            self.outputIsLiked.value = false
        }
    }
    
    private func setupStatisticsData(data: Statistics) {
        self.outputPhotoViewCount.value = data.downloads.total.formatted()
        self.outputPhotoDownloadCount.value = data.views.total.formatted()
    }
    
    private func formatDate(iso8601String: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(identifier: "UTC") ?? TimeZone.current
        let date = dateFormatter.date(from: iso8601String)
        
        dateFormatter.dateFormat = "yyyy년 M월 d일 게시됨" //표현하고 싶은 날짜 형식
        return dateFormatter.string(from: date ?? Date())
    }
    
    private func downloadImage(url: String, completionHandler: @escaping (UIImage?) -> Void) {
        let imageView = UIImageView()
        let urlString = url
        if let url = URL(string: urlString) {
            imageView.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    completionHandler(value.image)
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completionHandler(nil)
                }
            }
        }
    }
    
    private func saveItemToRealm() {
        
        if self.photo != nil && self.likedPhoto == nil {
            
            if let photo = self.photo {
                
                let data = LikedPhoto(photoID: photo.id, created: photo.createdAt, width: photo.width, height: photo.height, photoImageURLRaw: photo.urls.raw, photoImageURLSmall: photo.urls.small, userProfileImageURLSmall: photo.user.profileImage.small, userProfileImageURLMedium: photo.user.profileImage.medium, userProfileImageURLLarge: photo.user.profileImage.large, username: photo.user.name, likeCount: photo.likes)
                
                self.repository.create(data: data) { [weak self] result in
                    switch result {
                    case .success(_):
                        //사진 이미지를 파일에 저장
                        self?.downloadImage(url: photo.urls.small) { image in
                            if let image = image {
                                ImageFileManager.shared.saveImageToDocument(image: image, filename: data.photoID)
                            }
                        }
                        
                        //유저 프로필 이미지를 파일에 저장
                        self?.downloadImage(url: photo.user.profileImage.large) { image in
                            if let image = image {
                                ImageFileManager.shared.saveImageToDocument(image: image, filename: photo.userProfileID)
                            }
                        }
                        
                        self?.outputIsLiked.value = true
                        
                    case .failure(let error):
                        print(error)
                        self?.outputIsLiked.value = false
                    }
                }
            }
        } else {
            
            if let likedPhoto = self.likedPhoto {
                
                self.repository.create(data: likedPhoto) { [weak self] result in
                    switch result {
                    case .success(_):
                        //사진 이미지를 파일에 저장
                        self?.downloadImage(url: likedPhoto.photoImageURLSmall) { image in
                            if let image = image {
                                ImageFileManager.shared.saveImageToDocument(image: image, filename: likedPhoto.photoID)
                            }
                        }
                        
                        //유저 프로필 이미지를 파일에 저장
                        self?.downloadImage(url: likedPhoto.userProfileImageURLLarge) { image in
                            if let image = image {
                                ImageFileManager.shared.saveImageToDocument(image: image, filename: likedPhoto.userProfileID)
                            }
                        }
                        
                        self?.outputIsLiked.value = true
                        
                    case .failure(let error):
                        print(error)
                        self?.outputIsLiked.value = false
                    }
                }
            }
        }
    }
    
    private func deleteItemFromRealm() {
        
        if self.photo != nil && self.likedPhoto == nil {
            
            if let photo = self.photo {
                
                self.repository.deleteItem(photoID: photo.id) { [weak self] result in
                    switch result {
                    case .success(let success):
                        print(success)
                        ImageFileManager.shared.removeImageFromDocument(filename: photo.id)
                        ImageFileManager.shared.removeImageFromDocument(filename: photo.userProfileID)
                        
                        self?.outputIsLiked.value = false
                        
                    case .failure(let error):
                        print(error)
                        
                        self?.outputIsLiked.value = true
                    }
                }
            }
        } else {
            if let likedPhoto = self.likedPhoto {
                
                self.repository.deleteItem(photoID: likedPhoto.photoID) { [weak self] result in
                    switch result {
                    case .success(let success):
                        print(success)
                        ImageFileManager.shared.removeImageFromDocument(filename: likedPhoto.photoID)
                        ImageFileManager.shared.removeImageFromDocument(filename: likedPhoto.userProfileID)
                        
                        self?.outputIsLiked.value = false
                        
                    case .failure(let error):
                        print(error)
                        
                        self?.outputIsLiked.value = true
                    }
                }
            }
        }
    }
    
}
