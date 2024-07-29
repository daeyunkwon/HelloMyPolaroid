//
//  PhotoDetailView.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/27/24.
//

import UIKit

import SnapKit

final class PhotoDetailView: UIView {
    
    //MARK: - Properties
    
    var isLiked: Bool = false {
        didSet {
            self.updateLikeButtonAppearance()
        }
    }
    
    //MARK: - UI Components
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    let userProfileAndLikeButtonView = UserProfileAndLikeButtonView()
    
//    let profileImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFill
//        iv.backgroundColor = .lightGray
//        iv.layer.cornerRadius = 17.5
//        iv.clipsToBounds = true
//        return iv
//    }()
//    
//    let userNameLabel: UILabel = {
//        let label = UILabel()
//        label.font = Constant.Font.system14
//        return label
//    }()
//    
//    let dateLabel: UILabel = {
//        let label = UILabel()
//        label.font = .boldSystemFont(ofSize: 11)
//        return label
//    }()
//    
//    let likeButton: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setImage(UIImage(named: "like_inactive"), for: .normal)
//        return btn
//    }()
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.image = UIImage(systemName: "photo")?.applyingSymbolConfiguration(.init(font: UIFont.systemFont(ofSize: 300)))
        iv.tintColor = .lightGray
        iv.clipsToBounds = true
        return iv
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "정보"
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    private let sizeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "크기"
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    let sizeLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let viewCountTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "조회수"
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    let viewCountLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let downloadTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "다운로드"
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    let downloadLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let chartTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "차트"
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    private let chartSegment: UISegmentedControl = {
        let sm = UISegmentedControl()
        sm.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 15)], for: .selected)
        sm.insertSegment(withTitle: "조회", at: 0, animated: false)
        sm.insertSegment(withTitle: "다운로드", at: 1, animated: false)
        sm.selectedSegmentIndex = 0
        
        let label = UILabel()
        label.text = "조회"
        let size = label.intrinsicContentSize.width
        sm.setWidth(size + 16, forSegmentAt: 0)
        return sm
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configurations
    
    private func configureLayout() {
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalToSuperview()
        }
        
        contentView.addSubview(userProfileAndLikeButtonView)
        userProfileAndLikeButtonView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(userProfileAndLikeButtonView.snp.bottom).offset(3)
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(descriptionTitleLabel)
        descriptionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(sizeTitleLabel)
        sizeTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(descriptionTitleLabel.snp.trailing).offset(60)
            make.bottom.equalTo(descriptionTitleLabel.snp.bottom)
        }
        
        contentView.addSubview(sizeLabel)
        sizeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(sizeTitleLabel.snp.bottom)
        }
        
        contentView.addSubview(viewCountTitleLabel)
        viewCountTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(sizeTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(sizeTitleLabel.snp.leading)
        }
        
        contentView.addSubview(viewCountLabel)
        viewCountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(viewCountTitleLabel.snp.bottom)
        }
        
        contentView.addSubview(downloadTitleLabel)
        downloadTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(viewCountTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(viewCountTitleLabel.snp.leading)
        }
        
        contentView.addSubview(downloadLabel)
        downloadLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(downloadTitleLabel.snp.bottom)
        }
        
        contentView.addSubview(chartTitleLabel)
        chartTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(downloadLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(chartSegment)
        chartSegment.snp.makeConstraints { make in
            make.top.equalTo(chartTitleLabel.snp.top).offset(2)
            make.leading.equalTo(downloadTitleLabel.snp.leading)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    //MARK: - Methods
    
    private func updateLikeButtonAppearance() {
        if self.isLiked {
            self.userProfileAndLikeButtonView.likeButton.setImage(UIImage(named: "like"), for: .normal)
        } else {
            self.userProfileAndLikeButtonView.likeButton.setImage(UIImage(named: "like_inactive"), for: .normal)
        }
    }
    
}
