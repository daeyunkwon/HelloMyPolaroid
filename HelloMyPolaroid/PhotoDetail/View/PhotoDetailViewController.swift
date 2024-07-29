//
//  PhotoDetailViewController.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/27/24.
//

import UIKit

final class PhotoDetailViewController: BaseViewController {
    
    //MARK: - Properties
    
    let viewModel = PhotoDetailViewModel()
    
    var photo: Photo?
    var likedPhoto: LikedPhoto?
    
    //MARK: - UI Components
    
    private let photoDetailView = PhotoDetailView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = photoDetailView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
        
        if self.photo != nil && self.likedPhoto == nil {
            self.viewModel.inputPhoto.value = self.photo
        } else {
            self.viewModel.inputLikedPhoto.value = self.likedPhoto
        }
    }
    
    //MARK: - Configurations
    
    override func bindData() {
        viewModel.outputShowNetworkErrorAlert.bind { [weak self] _ in
            self?.showNetworkResponseFailAlert()
        }
        
        viewModel.outputUserProfileImage.bind { [weak self] value in
            guard let value = value else { return }
            self?.photoDetailView.userProfileAndLikeButtonView.profileImageView.image = value
        }
        
        viewModel.outputUsername.bind { [weak self] value in
            self?.photoDetailView.userProfileAndLikeButtonView.userNameLabel.text = value
        }
        
        viewModel.outputCreated.bind { [weak self] value in
            self?.photoDetailView.userProfileAndLikeButtonView.dateLabel.text = value
        }
        
        viewModel.outputIsLiked.bind { [weak self] value in
            self?.photoDetailView.isLiked = value
        }
        
        viewModel.outputPhotoImage.bind { [weak self] value in
            guard let value = value else { return }
            self?.photoDetailView.photoImageView.image = value
        }
        
        viewModel.outputPhotoSize.bind { [weak self] value in
            self?.photoDetailView.sizeLabel.text = value
        }
        
        viewModel.outputPhotoViewCount.bind { [weak self] value in
            self?.photoDetailView.viewCountLabel.text = value
        }
        
        viewModel.outputPhotoDownloadCount.bind { [weak self] value in
            self?.photoDetailView.downloadLabel.text = value
        }
    }
    
    private func setupAction() {
        self.photoDetailView.userProfileAndLikeButtonView.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    //MARK: - Actions
    
    @objc private func likeButtonTapped() {
        if photoDetailView.isLiked {
            //좋아요 취소
            viewModel.inputLikeButtonTapped.value = false
        } else {
            //좋아요
            viewModel.inputLikeButtonTapped.value = true
        }
    }
    
}
