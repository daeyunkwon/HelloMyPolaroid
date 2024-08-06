//
//  RandomPhotoViewController.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/29/24.
//

//TODO: 미구현 기능들
// - 셀 선택 시 사진 상세 화면으로 전환
// - 페이지 정보 표시 캡슐 뷰 UI 구현
// - 스크롤마다 페이지 정보 업데이트
// - 작가 프로필 영역 및 좋아요 버튼 UI 구현
// - 스크롤해서 보여지는 사진들에 맞춰서 작가 프로필 영역 및 좋아요 버튼 상태 데이터 업데이트
// - 사진마다 좋아요/좋아요해제 기능

import UIKit

import Kingfisher
import NVActivityIndicatorView
import Toast

final class RandomPhotoViewController: BaseViewController {
    
    //MARK: - Properties
    
    private var photoList: [Photo] = []
    
    private let repository = LikedPhotoRepository()
    
    //MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsVerticalScrollIndicator = false
        cv.register(RandomPhotoCell.self, forCellWithReuseIdentifier: RandomPhotoCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .lightGray
        cv.bounces = false
        return cv
    }()
    
    private let activityIndicatorView: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .zero)
        view.type = .lineSpinFadeLoader
        return view
    }()
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        self.collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    //MARK: - Configurations
    
    override func setupNavi() {
        navigationItem.title = ""
    }
    
    override func configureLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.center.equalToSuperview()
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    //MARK: - Methods
    
    private func fetchData() {
        self.activityIndicatorView.startAnimating()
        
        NetworkManager.shared.fetchData(api: .random, model: [Photo].self) { [weak self] result in
            switch result {
            case .success(let value):
                self?.photoList = value
                self?.collectionView.reloadData()
            
            case .failure(let error):
                print(error)
                self?.showNetworkResponseFailAlert()
            }
        }
    }
    
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension RandomPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RandomPhotoCell.identifier, for: indexPath) as? RandomPhotoCell else {
            print("Failed to dequeue a RandomPhotoCell. Using default UICollectionViewCell.")
            return UICollectionViewCell()
        }
        
        let data = self.photoList[indexPath.row]
        
        let url = URL(string: data.urls.raw)
        cell.photoImageView.kf.setImage(with: url) { result in
            switch result {
            case .success(_):
                self.activityIndicatorView.stopAnimating()
            case .failure(let error):
                print(error)
                self.activityIndicatorView.stopAnimating()
            }
        }
        
        cell.photo = data
        cell.cellConfig(data: data)
        cell.userProfileAndLikeButtonView.isLikeButtonSelected = repository.isSaved(photoID: data.id)
        
        
        cell.closureForDataSend = { [weak self] sender in
            guard let self else { return }
            if !cell.userProfileAndLikeButtonView.isLikeButtonSelected {
                cell.userProfileAndLikeButtonView.likeButton.isEnabled = false
                let data = LikedPhoto(photoID: sender.id, created: sender.createdAt, width: sender.width, height: sender.height, photoImageURLRaw: sender.urls.raw, photoImageURLSmall: sender.urls.small, userProfileImageURLSmall: sender.user.profileImage.small, userProfileImageURLMedium: sender.user.profileImage.medium, userProfileImageURLLarge: sender.user.profileImage.large, username: sender.user.name, likeCount: sender.likes)
                self.repository.create(data: data, completionHandler: { result in
                    switch result {
                    case .success(_):
                        
                        if let url = URL(string: data.photoImageURLSmall) {
                            ImageDownloader.default.downloadImage(with: url) { result in
                                switch result {
                                case .success(let value):
                                    ImageFileManager.shared.saveImageToDocument(image: value.image, filename: data.photoID)
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        }
                        
                        if let url = URL(string: data.userProfileImageURLLarge) {
                            ImageDownloader.default.downloadImage(with: url) { result in
                                switch result {
                                case .success(let value):
                                    ImageFileManager.shared.saveImageToDocument(image: value.image, filename: data.userProfileID)
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        }
                        
                        cell.userProfileAndLikeButtonView.isLikeButtonSelected = true
                        self.showLikeAddedToast()
                        self.collectionView.reloadData()
                    
                    case .failure(let error):
                        print(error)
                        self.showRealmErrorAlert(type: .failedToCreate)
                    }
                    cell.userProfileAndLikeButtonView.likeButton.isEnabled = true
                })
            } else {
                self.repository.deleteItem(photoID: sender.id) { result in
                    switch result {
                    case .success(_):
                        ImageFileManager.shared.removeImageFromDocument(filename: sender.id)
                        ImageFileManager.shared.removeImageFromDocument(filename: sender.userProfileID)
                        cell.userProfileAndLikeButtonView.isLikeButtonSelected = false
                        self.showLikeRemovedToast()
                        
                    case .failure(let error):
                        print(error)
                        self.showRealmErrorAlert(type: .failedToDelete)
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PhotoDetailViewController()
        vc.photo = self.photoList[indexPath.row]
        pushViewController(vc)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            scrollViewDidScroll(collectionView)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = max(scrollView.contentOffset.y, 0)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension RandomPhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let value = view.safeAreaInsets.bottom
        return UIEdgeInsets(top: -value, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
