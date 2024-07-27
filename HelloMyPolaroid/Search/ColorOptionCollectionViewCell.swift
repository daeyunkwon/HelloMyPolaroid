//
//  ColorOptionCollectionViewCell.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/26/24.
//

import UIKit

import SnapKit

final class ColorOptionCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - UI Components
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.primaryLightGray
        view.clipsToBounds = true
        return view
    }()
    
    private let colorCircleView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private let colorNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constant.Color.primaryBlack
        label.font = Constant.Font.system14
        return label
    }()
    
    //MARK: - Configurations
    
    override func configureLayout() {
        contentView.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        backView.addSubview(colorCircleView)
        colorCircleView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(5)
            make.size.equalTo(25)
        }
        
        backView.addSubview(colorNameLabel)
        colorNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(colorCircleView.snp.centerY)
            make.leading.equalTo(colorCircleView.snp.trailing).offset(5)
            make.trailing.equalTo(backView.snp.trailing).offset(-15)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        DispatchQueue.main.async {
            self.backView.layer.cornerRadius = self.backView.frame.height / 2
            self.colorCircleView.layer.cornerRadius = self.colorCircleView.frame.height / 2
        }
    }
    
    //MARK: - Methods
    
    func cellConfig(color: Color) {
        colorNameLabel.text = color.name
        colorCircleView.backgroundColor = color.uiColor
    }
    
}
