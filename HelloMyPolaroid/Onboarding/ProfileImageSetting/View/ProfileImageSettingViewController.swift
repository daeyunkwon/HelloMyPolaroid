//
//  ProfileImageSettingViewController.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/23/24.
//

import UIKit

import SnapKit

final class ProfileImageSettingViewController: BaseViewController {
    
    //MARK: - Properties
    
    let viewModel = ProfileImageSettingViewModel()
    
    //MARK: - UI Components
    
    private let mainProfileImageView: ProfileCircleWithCameraIcon = {
        let view = ProfileCircleWithCameraIcon()
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionView.layoutSquareType(sectionSpacing: 20, minimumInteritemSpacing: 10, minimumLineSpacing: 10, cellCount: 4))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
        return collectionView
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Configurations
    
    override func bindData() {
        viewModel.outputViewDidLoad.bind { [weak self] image in
            self?.mainProfileImageView.profileImageView.image = image
            self?.collectionView.reloadData()
        }
        
        viewModel.inputViewDidLoad.value = ()
        
        viewModel.outputSelectedProfileImageName.bind { [weak self] imageName in
            guard let imageName = imageName else { return }
            self?.viewModel.selectedProfileImage = UIImage(named: imageName)
            self?.mainProfileImageView.profileImageView.image = UIImage(named: imageName)
            self?.collectionView.reloadData()
        }
    }
    
    override func setupNavi() {
        navigationItem.title = "PROFILE SETTING"
    }
    
    override func configureLayout() {
        view.addSubview(mainProfileImageView)
        mainProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(mainProfileImageView.snp.bottom).offset(50)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ProfileImageSettingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputProfileImageNameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as? ProfileImageCollectionViewCell else {
            print("Failed to dequeue a ProfileImageCollectionViewCell. Using default UICollectionViewCell.")
            return UICollectionViewCell()
        }
        
        let image = UIImage(named: viewModel.outputProfileImageNameList[indexPath.row].rawValue)
        
        
        if self.viewModel.selectedProfileImage == image {
            cell.type = .selected
        } else {
            cell.type = .unselected
        }
        
        cell.profile = image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.inputSelectedRow.value = indexPath.row
    }
}
