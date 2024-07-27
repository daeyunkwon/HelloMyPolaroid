//
//  BasePhotoListViewController.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/27/24.
//

import UIKit

class BasePhotoListViewController: BaseViewController {
    
    //MARK: - Properties
    
    enum ColorType: String {
        case black
        case white
        case yellow
        case red
        case purple
        case green
        case blue
    }
    var colorType: ColorType?
    
    let colorOptions: [Color] = [
        Color(name: "블랙", uiColor: .black),
        Color(name: "화이트", uiColor: .white),
        Color(name: "옐로우", uiColor: .yellow),
        Color(name: "레드", uiColor: .red),
        Color(name: "퍼플", uiColor: .purple),
        Color(name: "그린", uiColor: .green),
        Color(name: "블루", uiColor: .blue),
    ]
    
    //MARK: - UI Components
    
    let photoView = PhotoListWithColorOptionView()

    //MARK: - Life Cycle
    
    override func loadView() {
        view = self.photoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupAction()
    }
    
    //MARK: - Configurations
    
    private func setupCollectionView() {
        setupColorOptionCollectionView()
        setupPhotoCollectionView()
    }
    
    func setupColorOptionCollectionView() {
        photoView.colorOptionCollectionView.register(ColorOptionCollectionViewCell.self, forCellWithReuseIdentifier: ColorOptionCollectionViewCell.identifier)
    }
    
    func setupPhotoCollectionView() {
        photoView.photoCollectionView.keyboardDismissMode = .onDrag
        photoView.photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    }
    
    func setupAction() {
        photoView.sortToggleButton.addTarget(self, action: #selector(sortToggleButtonTapped), for: .touchUpInside)
    }
    
    override func configureUI() {
        super.configureUI()
        
        DispatchQueue.main.async {
            self.photoView.backView.layer.cornerRadius = self.photoView.backView.frame.size.height / 2
        }
    }
    
    //MARK: - Actions
    
    @objc func sortToggleButtonTapped() { }   
}

//MARK: - UICollectionViewDelegateFlowLayout

extension BasePhotoListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == photoView.colorOptionCollectionView {
            let text = colorOptions[indexPath.item].name
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = text
            let size = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            return CGSize(width: size.width + 55, height: 50)
        }
        
        if collectionView == photoView.photoCollectionView {
            let cellSpacing: CGFloat = 3
            let cellCount: CGFloat = 2
            let width = UIScreen.main.bounds.width - ((cellSpacing * (cellCount - 1)))
            return CGSize(width: width / cellCount, height: width / cellCount * 1.3)
        }
        
        return CGSize(width: 0, height: 0)
    }
}
