//
//  PhotoListWithColorOptionView.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/26/24.
//

import UIKit

import SnapKit

final class PhotoListWithColorOptionView: UIView {
    
    //MARK: - Properties
    
    var isSortButtonSelected = false {
        didSet {
            self.updateSortToggleButtonAppearance()
        }
    }
    
    //MARK: - UI Components
    
    let colorOptionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 10
        let cellSpacing: CGFloat = 5
        layout.itemSize = CGSize(width: 100, height: 50)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cellSpacing: CGFloat = 3
        let cellCount: CGFloat = 2
        let width = UIScreen.main.bounds.width - ((cellSpacing * (cellCount - 1)))
        layout.itemSize = CGSize(width: width / cellCount, height: width / cellCount * 1.5)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.primaryWhite
        view.layer.borderColor = Constant.Color.primaryLightGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let sortToggleButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "sort"), for: .normal)
        btn.tintColor = Constant.Color.primaryBlack
        let attribute = NSAttributedString(string: "정렬순", attributes: [.foregroundColor: Constant.Color.primaryBlack, .backgroundColor: UIColor.clear, .font: UIFont.boldSystemFont(ofSize: 15)])
        btn.setAttributedTitle(attribute, for: .normal)
        return btn
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        self.addSubview(colorOptionCollectionView)
        colorOptionCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        
        self.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-85)
        }
        
        backView.addSubview(sortToggleButton)
        sortToggleButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(backView.snp.trailing).offset(-50)
        }
        
        self.addSubview(photoCollectionView)
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(colorOptionCollectionView.snp.bottom).offset(5)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func configureUI() {
        self.backgroundColor = Constant.Color.primaryWhite
    }
    
    //MARK: - Methods
    
    private func updateSortToggleButtonAppearance() {
        if isSortButtonSelected {
            let attribute = NSAttributedString(string: "최신순", attributes: [.foregroundColor: Constant.Color.primaryBlack, .backgroundColor: UIColor.clear, .font: UIFont.boldSystemFont(ofSize: 15)])
            sortToggleButton.setAttributedTitle(attribute, for: .normal)
            
        } else {
            let attribute = NSAttributedString(string: "정렬순", attributes: [.foregroundColor: Constant.Color.primaryBlack, .backgroundColor: UIColor.clear, .font: UIFont.boldSystemFont(ofSize: 15)])
            sortToggleButton.setAttributedTitle(attribute, for: .normal)
        }
    }
    
}

