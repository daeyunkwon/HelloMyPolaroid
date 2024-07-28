//
//  MBTICircleButton.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/22/24.
//

import UIKit

import SnapKit

final class MBTICircleButtonView: UIView {
    
    //MARK: - UI Components
    
    let alphabetButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = Constant.Color.primaryWhite
        btn.layer.borderColor = Constant.Color.primaryMediumGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 25
        return btn
    }()
    
    let alphabetLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constant.Color.primaryMediumGray
        label.font = Constant.Font.system15
        return label
    }()
    
    //MARK: - Init
    
    init(alphabetTitle: String) {
        super.init(frame: .zero)
        configureLayout()
        self.alphabetLabel.text = alphabetTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configurations
    
    private func configureLayout() {
        self.addSubview(alphabetButton)
        alphabetButton.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
        self.addSubview(alphabetLabel)
        alphabetLabel.snp.makeConstraints { make in
            make.center.equalTo(alphabetButton.snp.center)
        }
    }
    
    //MARK: - Methods
    
    func updateAppearanceUI(isSelected: Bool) {
        if isSelected {
            self.alphabetButton.backgroundColor = Constant.Color.signatureColor
            self.alphabetButton.layer.borderColor = UIColor.clear.cgColor
            self.alphabetLabel.textColor = Constant.Color.primaryWhite
        } else {
            self.alphabetButton.backgroundColor = Constant.Color.primaryWhite
            self.alphabetButton.layer.borderColor = Constant.Color.primaryMediumGray.cgColor
            self.alphabetLabel.textColor = Constant.Color.primaryMediumGray
        }
    }
}
