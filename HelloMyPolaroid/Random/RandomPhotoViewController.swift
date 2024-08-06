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

final class RandomPhotoViewController: BaseViewController {
    
    //MARK: - Properties
    
    private var photoList: [Photo] = []
    
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
        cv.backgroundColor = Constant.Color.primaryMediumGray
        cv.backgroundColor = .red
        cv.bounces = false
        print(UIScreen.main.bounds.height)
        return cv
    }()
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
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
    
    override func configureLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    //MARK: - Actions
    
    @objc private func likeButtonTapped() {
        print(#function)
    }
    
    //MARK: - Methods
    
    private func fetchData() {
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
        
        cell.cellConfig(data: self.photoList[indexPath.row])
        
        return cell
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
