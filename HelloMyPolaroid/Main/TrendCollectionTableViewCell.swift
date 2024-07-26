//
//  TrendCollectionTableViewCell.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/24/24.
//

import UIKit

import SnapKit

final class TrendCollectionTableViewCell: BaseTableViewCell {
    
    //MARK: - Properties
    
    enum CellType: Int, CaseIterable {
        case goldenhour
        case business
        case architecture
        
        var titleString: String {
            switch self {
            case .goldenhour:
                "골든 아워"
            case .business:
                "비즈니스 및 업무"
            case .architecture:
                "건축 및 인테리어"
            }
        }
    }
    var cellType: CellType? {
        didSet {
            guard let cellType = self.cellType else { return }
            
            self.sectionTitleLabel.text = cellType.titleString
        }
    }
    
    var photoList: [Photo] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - UI Components
    
    private let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    //MARK: - Configurations
    
    override func configureLayout() {
        contentView.addSubview(sectionTitleLabel)
        sectionTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(15)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sectionTitleLabel.snp.bottom).offset(5)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension TrendCollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            print("Failed to dequeue a TrendCollectionViewCell. Using default UICollectionViewCell.")
            return UICollectionViewCell()
        }
        cell.cellType = .trend
        cell.cellConfig(photo: self.photoList[indexPath.row])
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension TrendCollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = contentView.bounds.width / 1.9 - 10
        return CGSize(width: width, height: contentView.bounds.height - 50)
    }
}
