//
//  ViewController.swift
//  HelloMyPoraroid
//
//  Created by 권대윤 on 7/22/24.
//

import UIKit

import SnapKit

final class OnboardingViewController: BaseViewController {
    
    //MARK: - UI Components
    
    private let launchTitleImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = Constant.Image.launchTitle
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let launchImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = Constant.Image.launchImage
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .heavy)
        label.text = "권대윤"
        return label
    }()
    
    private lazy var startButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("시작하기", for: .normal)
        btn.setTitleColor(Constant.Color.primaryWhite, for: .normal)
        btn.backgroundColor = Constant.Color.signatureColor
        btn.layer.cornerRadius = 25
        btn.titleLabel?.font = Constant.Font.onboardingButtonTitleFont
        btn.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
    }
    
    //MARK: - Configurations
    
    override func configureLayout() {
        view.addSubview(launchTitleImageView)
        launchTitleImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(77)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(84)
        }
        
        view.addSubview(launchImageView)
        launchImageView.snp.makeConstraints { make in
            make.top.equalTo(launchTitleImageView.snp.bottom).offset(44)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(386)
        }
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(launchImageView.snp.bottom).offset(5)
        }
        
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    //MARK: - Actions
    
    @objc private func startButtonTapped() {
        self.pushViewController(ProfileSettingViewController(viewType: .setting))
    }
}

