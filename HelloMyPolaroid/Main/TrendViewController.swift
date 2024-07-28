//
//  TrendViewController.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/24/24.
//

import UIKit

import SnapKit

final class TrendViewController: BaseViewController {
    
    //MARK: - Properties
    
    private var firstRandomTopic: TopicID?
    private var secondRandomTopic: TopicID?
    private var thirdRandomTopic: TopicID?
    
    private var firstTopicList: [Photo] = []
    private var secondTopicList: [Photo] = []
    private var thirdTopicList: [Photo] = []
    
    //MARK: - UI Components
    
    private lazy var profileView: UIImageView = {
        let imageName = UserDefaultsManager.shared.profile ?? "profile_0"
        let iv = ProfileCircle(radius: 20, imageName: imageName)
        iv.layer.borderColor = Constant.Color.signatureColor.cgColor
        iv.layer.borderWidth = 2.5
        iv.alpha = 1
        iv.backgroundColor = Constant.Color.primaryLightGray
        iv.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileViewTapped))
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrendCollectionTableViewCell.self, forCellReuseIdentifier: TrendCollectionTableViewCell.identifier)
        return tableView
    }()
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "OUR TOPIC"
        fetchProfileImage()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
    }
    
    //MARK: - Configurations
    
    override func setupNavi() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileView)
    }
    
    override func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    //MARK: - Actions
    
    @objc private func profileViewTapped() {
        let vc = ProfileSettingViewController(viewType: .edit)
        pushViewController(vc)
    }
    
    //MARK: - Methods
    
    private func fetchData() {
        self.setupRandomTopics()
        
        guard let firstRandomTopic = self.firstRandomTopic else { return }
        guard let secondRandomTopic = self.secondRandomTopic else { return }
        guard let thirdRandomTopic = self.thirdRandomTopic else { return }
        
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global().async(group: group) {
            NetworkManager.shared.fetchData(api: .topics(topicID: firstRandomTopic.rawValue), model: [Photo].self) { result in
                switch result {
                case .success(let data):
                    self.firstTopicList = data
                    group.leave()
                    
                case .failure(let error):
                    print(error.errorDescription)
                    self.showNetworkResponseFailAlert()
                    group.leave()
                }
            }
        }
        
        group.enter()
        DispatchQueue.global().async(group: group) {
            NetworkManager.shared.fetchData(api: .topics(topicID: secondRandomTopic.rawValue), model: [Photo].self) { result in
                switch result {
                case .success(let data):
                    self.secondTopicList = data
                    group.leave()
                    
                case .failure(let error):
                    print(error.errorDescription)
                    self.showNetworkResponseFailAlert()
                    group.leave()
                }
            }
        }
        
        group.enter()
        DispatchQueue.global().async(group: group) {
            NetworkManager.shared.fetchData(api: .topics(topicID: thirdRandomTopic.rawValue), model: [Photo].self) { result in
                switch result {
                case .success(let data):
                    self.thirdTopicList = data
                    group.leave()
                    
                case .failure(let error):
                    print(error.errorDescription)
                    self.showNetworkResponseFailAlert()
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
    private func fetchProfileImage() {
        let name = UserDefaultsManager.shared.profile ?? "profile_0"
        self.profileView.image = UIImage(named: name)
    }
    
    private func setupRandomTopics() {
        var list = TopicID.allCases
        list.shuffle()
        self.firstRandomTopic = list[0]
        self.secondRandomTopic = list[1]
        self.thirdRandomTopic = list[2]
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension TrendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 2.9
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendCollectionTableViewCell.identifier, for: indexPath) as? TrendCollectionTableViewCell else {
            print("Failed to dequeue a TrendCollectionTableViewCell. Using default UITableViewCell.")
            return UITableViewCell()
        }
        
        cell.closureForDidSelected = { [weak self] sender in
            let vc = PhotoDetailViewController()
            vc.photo = sender
            self?.pushViewController(vc)
        }
        
        switch indexPath.section {
        case 0: 
            cell.cellType = self.firstRandomTopic
            cell.photoList = self.firstTopicList
        
        case 1: 
            cell.cellType = self.secondRandomTopic
            cell.photoList = self.secondTopicList
        
        case 2: 
            cell.cellType = self.thirdRandomTopic
            cell.photoList = self.thirdTopicList
        default:
            break
        }
        
        return cell
    }
}
