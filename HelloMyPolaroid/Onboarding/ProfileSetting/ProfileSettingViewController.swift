//
//  ProfileSettingViewController.swift
//  HelloMyPoraroid
//
//  Created by 권대윤 on 7/22/24.
//

import UIKit

import SnapKit

final class ProfileSettingViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel = ProfileSettingViewModel()
    
    //MARK: - UI Components
    
    private lazy var profileCircleWithCameraIconView: ProfileCircleWithCameraIcon = {
        let view = ProfileCircleWithCameraIcon()
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        view.profileImageView.addGestureRecognizer(tap)
        view.profileImageView.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var nicknameTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요 :)", attributes: [.foregroundColor: Constant.Color.primaryMediumGray, .font: Constant.Font.system15])
        tf.backgroundColor = .clear
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.keyboardType = .default
        tf.returnKeyType = .done
        tf.addTarget(self, action: #selector(nicknameTextFieldChanged), for: .editingChanged)
        return tf
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.primaryLightGray
        return view
    }()
    
    private let nicknameConditionLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.system13
        label.textColor = Constant.Color.signatureColor
        return label
    }()
    
    private lazy var completeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("완료", for: .normal)
        btn.setTitleColor(Constant.Color.primaryWhite, for: .normal)
        btn.backgroundColor = Constant.Color.primaryMediumGray
        btn.layer.cornerRadius = 25
        btn.titleLabel?.font = Constant.Font.onboardingButtonTitleFont
        btn.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputViewDidLoad.value = ()
    }
    
    //MARK: - Configurations
    
    override func bindData() {
        viewModel.outputProfileImageName.bind { [weak self] imageName in
            self?.profileCircleWithCameraIconView.profileImageView.image = UIImage(named: imageName)
        }
    }
    
    override func setupNavi() {
        navigationItem.title = "PROFILE SETTING"
    }
    
    override func configureLayout() {
        view.addSubview(profileCircleWithCameraIconView)
        profileCircleWithCameraIconView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        view.addSubview(nicknameTextField)
        nicknameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(30)
            make.top.equalTo(profileCircleWithCameraIconView.snp.bottom).offset(40)
        }
        
        view.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(1)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(10)
        }
        
        view.addSubview(nicknameConditionLabel)
        nicknameConditionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(20)
            make.top.equalTo(separatorView.snp.bottom).offset(10)
        }
        
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    //MARK: - Actions
    
    @objc private func profileImageViewTapped() {
        
    }
    
    @objc private func nicknameTextFieldChanged() {
        print(#function)
    }
    
    @objc private func completeButtonTapped() {
        print(#function)
    }
    
    
    //MARK: - Methods
    

}
