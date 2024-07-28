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
    
    enum ViewType {
        case search
        case like
    }
    var viewType: ViewType = .search {
        didSet {
            self.updateSortToggleButtonAppearance()
            self.setupEmptyLabelText()
        }
    }
    
    //MARK: - UI Components
    
    let colorOptionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 90)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cellSpacing: CGFloat = 3
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
        view.layer.shadowColor = Constant.Color.primaryLightGray.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        return view
    }()
    
    let sortToggleButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "sort"), for: .normal)
        btn.tintColor = Constant.Color.primaryBlack
        let attribute = NSAttributedString(string: " 관련순", attributes: [.foregroundColor: Constant.Color.primaryBlack, .backgroundColor: UIColor.clear, .font: UIFont.boldSystemFont(ofSize: 15)])
        btn.setAttributedTitle(attribute, for: .normal)
        return btn
    }()
    
    private let emptySearchResultLabel: UILabel = {
        let label = UILabel()
        label.text = "사진을 검색해보세요."
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        label.isHidden = false
        return label
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
    
    //MARK: - Configurations
    
    private func configureLayout() {
        self.addSubview(colorOptionCollectionView)
        colorOptionCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(50)
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
            make.top.equalTo(colorOptionCollectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        self.addSubview(emptySearchResultLabel)
        emptySearchResultLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(50)
        }
    }
    
    private func configureUI() {
        self.backgroundColor = Constant.Color.primaryWhite
    }
    
    //MARK: - Methods
    
    private func setupEmptyLabelText() {
        switch viewType {
        case .search:
            self.emptySearchResultLabel.text = "검색 결과가 없습니다."
        case .like:
            self.emptySearchResultLabel.text = "저장된 사진이 없어요."
        }
    }
    
    private func updateSortToggleButtonAppearance() {
        switch viewType {
        case .search:
            if isSortButtonSelected {
                let attribute = NSAttributedString(string: " 최신순", attributes: [.foregroundColor: Constant.Color.primaryBlack, .backgroundColor: UIColor.clear, .font: UIFont.boldSystemFont(ofSize: 15)])
                sortToggleButton.setAttributedTitle(attribute, for: .normal)
                
            } else {
                //디폴트
                let attribute = NSAttributedString(string: " 관련순", attributes: [.foregroundColor: Constant.Color.primaryBlack, .backgroundColor: UIColor.clear, .font: UIFont.boldSystemFont(ofSize: 15)])
                sortToggleButton.setAttributedTitle(attribute, for: .normal)
            }
            
        case .like:
            if isSortButtonSelected {
                let attribute = NSAttributedString(string: " 과거순", attributes: [.foregroundColor: Constant.Color.primaryBlack, .backgroundColor: UIColor.clear, .font: UIFont.boldSystemFont(ofSize: 15)])
                sortToggleButton.setAttributedTitle(attribute, for: .normal)
                
            } else {
                //디폴트
                let attribute = NSAttributedString(string: " 최신순", attributes: [.foregroundColor: Constant.Color.primaryBlack, .backgroundColor: UIColor.clear, .font: UIFont.boldSystemFont(ofSize: 15)])
                sortToggleButton.setAttributedTitle(attribute, for: .normal)
            }
        }
    }
    
    func showEmptySearchResultLabel() {
        self.emptySearchResultLabel.isHidden = false
    }
    
    func hideEmptySearchResultLabel() {
        self.emptySearchResultLabel.isHidden = true
    }
    
}

