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
    
    //MARK: - Inputs
    
    var inputPhoto = Observable<Photo?>(nil)
    var inputLikedPhoto = Observable<LikedPhoto?>(nil)
    
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
            
            self?.fetchData(with: photo.id)
            self?.setupPhotoData(username: photo.user.name, created: photo.createdAt, width: photo.width, height: photo.height, photoID: photo.id)
            
            var tempImageView = UIImageView(frame: .zero)
            tempImageView.kf.setImage(with: URL(string: photo.user.profileImage.medium))
            self?.outputUserProfileImage.value = tempImageView.image
            
            tempImageView.kf.setImage(with: URL(string: photo.urls.raw))
            self?.outputPhotoImage.value = tempImageView.image
        }
        
        inputLikedPhoto.bind { [weak self] value in
            guard let likedPhoto = value else { return }
            
            self?.fetchData(with: likedPhoto.photoID)
            self?.setupPhotoData(username: likedPhoto.username, created: likedPhoto.created, width: likedPhoto.width, height: likedPhoto.height, photoID: likedPhoto.photoID)
            
            //self?.outputUserProfileImageURL.value = userProfileImageURL
            self?.outputPhotoImage.value = ImageFileManager.shared.loadImageToDocument(filename: likedPhoto.photoID)
        }
    }
    
    //MARK: - Methods

    private func fetchData(with photoID: String) {
        NetworkManager.shared.fetchData(api: .statistics(photoID: photoID), model:Statistics.self) { [weak self] result in
            switch result {
            case .success(let value):
                self?.setupStatisticsData(data: value)
            case .failure(let error):
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
    
    
    
}
