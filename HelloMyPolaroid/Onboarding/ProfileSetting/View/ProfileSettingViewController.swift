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
    
    enum ViewType {
        case setting
        case edit
    }
    var viewType: ViewType
    
    private lazy var viewModel = viewType == .setting ? ProfileSettingViewModel(viewType: .setting) : ProfileSettingViewModel(viewType: .edit)
    
    //MARK: - Init
    
    init(viewType: ViewType) {
        self.viewType = viewType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        let accessory = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        lazy var doneButton = UIButton(type: .system)
        doneButton.addTarget(self, action: #selector(doneButtonInsideAccessoryTapped), for: .touchUpInside)
        doneButton.setTitle("완료", for: .normal)
        accessory.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(accessory.snp.trailing).offset(-20)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        accessory.backgroundColor = .systemGroupedBackground
        tf.inputAccessoryView = accessory
        
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
        return label
    }()
    
    private let mbtiLabel: UILabel = {
        let label = UILabel()
        label.text = "MBTI"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var eButton: MBTICircleButtonView = {
        let view = MBTICircleButtonView(alphabetTitle: "E")
        view.alphabetButton.addTarget(self, action: #selector(mbtiWordButtonTapped), for: .touchUpInside)
        view.alphabetButton.tag = 0
        return view
    }()
    
    private lazy var iButton: MBTICircleButtonView = {
        let view = MBTICircleButtonView(alphabetTitle: "I")
        view.alphabetButton.addTarget(self, action: #selector(mbtiWordButtonTapped), for: .touchUpInside)
        view.alphabetButton.tag = 1
        return view
    }()
    
    private lazy var sButton: MBTICircleButtonView = {
        let view = MBTICircleButtonView(alphabetTitle: "S")
        view.alphabetButton.addTarget(self, action: #selector(mbtiWordButtonTapped), for: .touchUpInside)
        view.alphabetButton.tag = 2
        return view
    }()
    
    private lazy var nButton: MBTICircleButtonView = {
        let view = MBTICircleButtonView(alphabetTitle: "N")
        view.alphabetButton.addTarget(self, action: #selector(mbtiWordButtonTapped), for: .touchUpInside)
        view.alphabetButton.tag = 3
        return view
    }()
    
    private lazy var tButton: MBTICircleButtonView = {
        let view = MBTICircleButtonView(alphabetTitle: "T")
        view.alphabetButton.addTarget(self, action: #selector(mbtiWordButtonTapped), for: .touchUpInside)
        view.alphabetButton.tag = 4
        return view
    }()
    
    private lazy var fButton: MBTICircleButtonView = {
        let view = MBTICircleButtonView(alphabetTitle: "F")
        view.alphabetButton.addTarget(self, action: #selector(mbtiWordButtonTapped), for: .touchUpInside)
        view.alphabetButton.tag = 5
        return view
    }()
    
    private lazy var jButton: MBTICircleButtonView = {
        let view = MBTICircleButtonView(alphabetTitle: "J")
        view.alphabetButton.addTarget(self, action: #selector(mbtiWordButtonTapped), for: .touchUpInside)
        view.alphabetButton.tag = 6
        return view
    }()
    
    private lazy var pButton: MBTICircleButtonView = {
        let view = MBTICircleButtonView(alphabetTitle: "P")
        view.alphabetButton.addTarget(self, action: #selector(mbtiWordButtonTapped), for: .touchUpInside)
        view.alphabetButton.tag = 7
        return view
    }()
    
    private lazy var completeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("완료", for: .normal)
        btn.setTitleColor(Constant.Color.primaryWhite, for: .normal)
        btn.backgroundColor = Constant.Color.primaryMediumGray
        btn.layer.cornerRadius = 25
        btn.titleLabel?.font = Constant.Font.onboardingButtonTitleFont
        btn.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    
    private lazy var withdrawalButton: UIButton = {
        let btn = UIButton(type: .system)
        let attributeString = NSMutableAttributedString(string: "회원탈퇴")
        attributeString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributeString.length))
        btn.setAttributedTitle(attributeString, for: .normal)
        btn.addTarget(self, action: #selector(withdrawalButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch viewType {
        case .setting:
            navigationItem.title = "PROFILE SETTING"
        case .edit:
            navigationItem.title = "EDIT PROFILE"
            tabBarController?.tabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputViewDidLoad.value = ()
    }
    
    //MARK: - Configurations
    
    override func bindData() {
        viewModel.outputUserNickname.bind { [weak self] nickname in
            self?.nicknameTextField.text = nickname
            self?.nicknameTextFieldChanged(sender: self?.nicknameTextField ?? UITextField())
        }
        
        viewModel.outputProfileImageName.bind { [weak self] imageName in
            self?.profileCircleWithCameraIconView.profileImageView.image = UIImage(named: imageName)
        }
        
        viewModel.outputMBTIData.bind { [weak self] value in
            self?.updateDisplayMBTIButton(mbti: value)
        }
        
        viewModel.outputIsValid.bind { [weak self] values in
            if values[0] {
                self?.nicknameConditionLabel.textColor = Constant.Color.signatureColor
            } else {
                self?.nicknameConditionLabel.textColor = Constant.Color.primaryRed
            }
            
            switch self?.viewType {
            case .setting:
                if values[0] && values[1] {
                    self?.changeDisplayCompleteButton(conditionsSatisfied: true)
                } else {
                    self?.changeDisplayCompleteButton(conditionsSatisfied: false)
                }
                
            case .edit:
                if values[0] && values[1] {
                    self?.navigationItem.rightBarButtonItem?.isEnabled = true
                } else {
                    self?.navigationItem.rightBarButtonItem?.isEnabled = false
                }
            default:
                break
            }
        }
        
        viewModel.outputProfileImageViewTapped.bind { [weak self] _ in
            let vc = ProfileImageSettingViewController()
            vc.viewModel.selectedProfileImage = self?.profileCircleWithCameraIconView.profileImageView.image
            vc.viewModel.closureForProfileImageSend = { [weak self] sender in
                self?.profileCircleWithCameraIconView.profileImageView.image = sender
            }
            self?.pushViewController(vc)
        }
        
        viewModel.outputValidationText.bind { [weak self] text in
            self?.nicknameConditionLabel.text = text
        }
        
        viewModel.outputCreateUserDataSucceed.bind { [weak self] value in
            if value {
                switch self?.viewType {
                case .setting:
                    self?.setRootViewController(TabBarController())
                
                case .edit:
                    self?.popViewController()
                    self?.tabBarController?.tabBar.isHidden = false
                default:
                    break
                }
            }
        }
        
        viewModel.outputWithdrawalButtonTapped.bind { [weak self] _ in
            self?.showWithdrawalAlert()
        }
        
        viewModel.outputWithdrawalAlertOKButtonTapped.bind { [weak self] isDeleted in
            if isDeleted {
                self?.setRootViewController(UINavigationController(rootViewController: OnboardingViewController()))
            }
        }
    }
    
    override func setupNavi() {
        switch viewType {
        case .edit:
            let right = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveBarButtonTapped))
            navigationItem.rightBarButtonItem = right
            navigationItem.largeTitleDisplayMode = .never
        default:
            break
        }
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
        
        view.addSubview(mbtiLabel)
        mbtiLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameConditionLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
        
        view.addSubview(eButton)
        eButton.snp.makeConstraints { make in
            make.top.equalTo(mbtiLabel.snp.top).offset(-3)
            make.leading.equalTo(mbtiLabel.snp.trailing).offset(60)
            make.size.equalTo(50)
        }
        
        view.addSubview(iButton)
        iButton.snp.makeConstraints { make in
            make.top.equalTo(eButton.snp.bottom).offset(8)
            make.leading.equalTo(mbtiLabel.snp.trailing).offset(60)
            make.size.equalTo(50)
        }
        
        view.addSubview(sButton)
        sButton.snp.makeConstraints { make in
            make.top.equalTo(eButton.snp.top)
            make.leading.equalTo(eButton.snp.trailing).offset(10)
            make.size.equalTo(50)
        }
        
        view.addSubview(nButton)
        nButton.snp.makeConstraints { make in
            make.top.equalTo(iButton.snp.top)
            make.leading.equalTo(iButton.snp.trailing).offset(10)
            make.size.equalTo(50)
        }
        
        view.addSubview(tButton)
        tButton.snp.makeConstraints { make in
            make.top.equalTo(eButton.snp.top)
            make.leading.equalTo(sButton.snp.trailing).offset(10)
            make.size.equalTo(50)
        }
        
        view.addSubview(fButton)
        fButton.snp.makeConstraints { make in
            make.top.equalTo(iButton.snp.top)
            make.leading.equalTo(nButton.snp.trailing).offset(10)
            make.size.equalTo(50)
        }
        
        view.addSubview(jButton)
        jButton.snp.makeConstraints { make in
            make.top.equalTo(eButton.snp.top)
            make.leading.equalTo(tButton.snp.trailing).offset(10)
            make.size.equalTo(50)
        }
        
        view.addSubview(pButton)
        pButton.snp.makeConstraints { make in
            make.top.equalTo(iButton.snp.top)
            make.leading.equalTo(fButton.snp.trailing).offset(10)
            make.size.equalTo(50)
        }
        
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(withdrawalButton)
        withdrawalButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        switch viewType {
        case .setting:
            completeButton.isHidden = false
            withdrawalButton.isHidden = true
        
        case .edit:
            completeButton.isHidden = true
            withdrawalButton.isHidden = false
        }
    }
    
    //MARK: - Actions
    
    @objc private func profileImageViewTapped() {
        viewModel.inputProfileImageViewTapped.value = ()
    }
    
    @objc private func nicknameTextFieldChanged(sender: UITextField) {
        guard let text = sender.text else { return }
        viewModel.inputNicknameTextFieldChanged.value = text.trimmingCharacters(in: .whitespaces)
    }
    
    @objc private func completeButtonTapped() {
        viewModel.inputCompleteButtonTapped.value = profileCircleWithCameraIconView.profileImageView.image
    }
    
    @objc private func withdrawalButtonTapped() {
        viewModel.inputWithdrawalButtonTapped.value = ()
    }
    
    @objc private func mbtiWordButtonTapped(sender: UIButton) {
        viewModel.inputMBTIWordButtonTapped.value = sender.tag
    }
    
    @objc private func saveBarButtonTapped() {
        viewModel.inputCompleteButtonTapped.value = profileCircleWithCameraIconView.profileImageView.image
    }
    
    @objc private func doneButtonInsideAccessoryTapped() {
        nicknameTextField.resignFirstResponder()
    }
    
    //MARK: - Methods
    
    private func updateDisplayMBTIButton(mbti: [String: String]) {
        [eButton, iButton, sButton, nButton, tButton, fButton, jButton, pButton].forEach { btn in
            if btn.alphabetLabel.text == mbti["first"] || btn.alphabetLabel.text == mbti["second"] || btn.alphabetLabel.text == mbti["third"] || btn.alphabetLabel.text == mbti["fourth"] {
                btn.updateAppearanceUI(isSelected: true)
            } else {
                btn.updateAppearanceUI(isSelected: false)
            }
        }
    }
    
    private func changeDisplayCompleteButton(conditionsSatisfied: Bool) {
        if conditionsSatisfied {
            completeButton.isEnabled = true
            completeButton.backgroundColor = Constant.Color.signatureColor
        } else {
            completeButton.isEnabled = false
            completeButton.backgroundColor = Constant.Color.primaryMediumGray
        }
    }
    
    private func showWithdrawalAlert() {
        let alert = UIAlertController(title: "회원 탈퇴", message: "회원님의 계정 정보가 영구 삭제됩니다. 정말 탈퇴 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "탈퇴하기", style: .destructive, handler: { [weak self] okAction in
            self?.viewModel.inputWithdrawalAlertOKButtonTapped.value = ()
        }))
        present(alert, animated: true)
    }
    
    private func setRootViewController(_ viewController: UIViewController) {
        if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
        let window = scene.window {
             
            window.rootViewController = viewController
            
            UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }
    }

}
