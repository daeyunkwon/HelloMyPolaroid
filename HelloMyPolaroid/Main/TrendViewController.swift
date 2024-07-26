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
    
    enum Section: Int, CaseIterable {
        case goldenhour
        case business
        case architecture
    }
    
    private var goldenhourList: [Photo] = []
    private var businessList: [Photo] = []
    private var architectureList: [Photo] = []
    
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
        //self.fetchData()
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
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global().async(group: group) {
            NetworkManager.shared.fetchData(api: .topics(topicID: TopicID.goldenhour.rawValue), model: [Photo].self) { result in
                switch result {
                case .success(let data):
                    self.goldenhourList = data
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
            NetworkManager.shared.fetchData(api: .topics(topicID: TopicID.business.rawValue), model: [Photo].self) { result in
                switch result {
                case .success(let data):
                    self.businessList = data
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
            NetworkManager.shared.fetchData(api: .topics(topicID: TopicID.architecture.rawValue), model: [Photo].self) { result in
                switch result {
                case .success(let data):
                    self.architectureList = data
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

}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension TrendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 2.9
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendCollectionTableViewCell.identifier, for: indexPath) as? TrendCollectionTableViewCell else {
            print("Failed to dequeue a TrendCollectionTableViewCell. Using default UITableViewCell.")
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0: 
            cell.cellType = .goldenhour
            cell.photoList = self.goldenhourList
            cell.photoList = TrendViewController.dummyList
        
        case 1: 
            cell.cellType = .business
            cell.photoList = self.businessList
        
        case 2: 
            cell.cellType = .architecture
            cell.photoList = self.architectureList
        default:
            break
        }
        
        return cell
    }
}

//MARK: - DummyData
extension TrendViewController {
    static var dummyList = [HelloMyPolaroid.Photo(id: "B4FHWfBI570", createdAt: "2024-07-23T19:42:35Z", width: 4002, height: 6000, urls: HelloMyPolaroid.Urls(raw: "https://images.unsplash.com/photo-1721763606433-62987548b394?ixid=M3w2MzU2MDN8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgyOTMwOXw&ixlib=rb-4.0.3", small: "https://images.unsplash.com/photo-1721763606433-62987548b394?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2MzU2MDN8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgyOTMwOXw&ixlib=rb-4.0.3&q=80&w=400"), likes: 2, user: HelloMyPolaroid.User(name: "Daniel Seßler", profileImage: HelloMyPolaroid.ProfileImage(small: "https://images.unsplash.com/profile-1634653553021-5ee00c501272image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=32&h=32", medium: "https://images.unsplash.com/profile-1634653553021-5ee00c501272image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=64&h=64", large: "https://images.unsplash.com/profile-1634653553021-5ee00c501272image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=128&h=128"))), HelloMyPolaroid.Photo(id: "JKBwvka9ocs", createdAt: "2024-07-24T11:01:44Z", width: 5960, height: 9228, urls: HelloMyPolaroid.Urls(raw: "https://images.unsplash.com/photo-1721818767842-e7a2b1b69b9a?ixid=M3w2MzU2MDN8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgyOTMwOXw&ixlib=rb-4.0.3", small: "https://images.unsplash.com/photo-1721818767842-e7a2b1b69b9a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2MzU2MDN8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgyOTMwOXw&ixlib=rb-4.0.3&q=80&w=400"), likes: 0, user: HelloMyPolaroid.User(name: "Omid Armin", profileImage: HelloMyPolaroid.ProfileImage(small: "https://images.unsplash.com/profile-1615661996885-ed8feedba9faimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=32&h=32", medium: "https://images.unsplash.com/profile-1615661996885-ed8feedba9faimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=64&h=64", large: "https://images.unsplash.com/profile-1615661996885-ed8feedba9faimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=128&h=128"))), HelloMyPolaroid.Photo(id: "0MjapO_5WP0", createdAt: "2024-07-23T19:42:35Z", width: 4002, height: 6000, urls: HelloMyPolaroid.Urls(raw: "https://images.unsplash.com/photo-1721763604562-4342b0fc6c3a?ixid=M3w2MzU2MDN8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgyOTMwOXw&ixlib=rb-4.0.3", small: "https://images.unsplash.com/photo-1721763604562-4342b0fc6c3a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2MzU2MDN8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgyOTMwOXw&ixlib=rb-4.0.3&q=80&w=400"), likes: 9, user: HelloMyPolaroid.User(name: "Daniel Seßler", profileImage: HelloMyPolaroid.ProfileImage(small: "https://images.unsplash.com/profile-1634653553021-5ee00c501272image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=32&h=32", medium: "https://images.unsplash.com/profile-1634653553021-5ee00c501272image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=64&h=64", large: "https://images.unsplash.com/profile-1634653553021-5ee00c501272image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=128&h=128"))), HelloMyPolaroid.Photo(id: "VQHKuaY2w0k", createdAt: "2024-06-07T22:41:41Z", width: 2940, height: 3675, urls: HelloMyPolaroid.Urls(raw: "https://images.unsplash.com/photo-1717800085119-b2733045f3b0?ixid=M3w2MzU2MDN8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgyOTMwOXw&ixlib=rb-4.0.3", small: "https://images.unsplash.com/photo-1717800085119-b2733045f3b0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2MzU2MDN8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgyOTMwOXw&ixlib=rb-4.0.3&q=80&w=400"), likes: 0, user: HelloMyPolaroid.User(name: "Bernard Guevara", profileImage: HelloMyPolaroid.ProfileImage(small: "https://images.unsplash.com/profile-1716000746901-18a964c06d36image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=32&h=32", medium: "https://images.unsplash.com/profile-1716000746901-18a964c06d36image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=64&h=64", large: "https://images.unsplash.com/profile-1716000746901-18a964c06d36image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=128&h=128"))), HelloMyPolaroid.Photo(id: "jQHpIdc9ZF4", createdAt: "2024-07-24T01:27:52Z", width: 3993, height: 5981, urls: HelloMyPolaroid.Urls(raw: "https://images.unsplash.com/photo-1721784391910-f41333b7f81b?ixid=M3w2MzU2MDN8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgyOTMwOXw&ixlib=rb-4.0.3", small: "https://images.unsplash.com/photo-1721784391910-f41333b7f81b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2MzU2MDN8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgyOTMwOXw&ixlib=rb-4.0.3&q=80&w=400"), likes: 0, user: HelloMyPolaroid.User(name: "Shiona Das", profileImage: HelloMyPolaroid.ProfileImage(small: "https://images.unsplash.com/profile-1682172655218-bcd2efd2e04eimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=32&h=32", medium: "https://images.unsplash.com/profile-1682172655218-bcd2efd2e04eimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=64&h=64", large: "https://images.unsplash.com/profile-1682172655218-bcd2efd2e04eimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=128&h=128"))), HelloMyPolaroid.Photo(id: "WbvOddbr0XE", createdAt: "2024-07-23T20:35:51Z", width: 5349, height: 3009, urls: HelloMyPolaroid.Urls(raw: "https://images.unsplash.com/photo-1721766828190-b5f6ae10caf0?ixid=M3w2MzU2MDN8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgyOTMwOXw&ixlib=rb-4.0.3", small: "https://images.unsplash.com/photo-1721766828190-b5f6ae10caf0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2MzU2MDN8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgyOTMwOXw&ixlib=rb-4.0.3&q=80&w=400"), likes: 1, user: HelloMyPolaroid.User(name: "Marek Piwnicki", profileImage: HelloMyPolaroid.ProfileImage(small: "https://images.unsplash.com/profile-1604758536753-68fd6f23aaf7image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=32&h=32", medium: "https://images.unsplash.com/profile-1604758536753-68fd6f23aaf7image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=64&h=64", large: "https://images.unsplash.com/profile-1604758536753-68fd6f23aaf7image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=128&h=128"))), HelloMyPolaroid.Photo(id: "MHGir2JXy24", createdAt: "2024-07-23T09:31:36Z", width: 4000, height: 3000, urls: HelloMyPolaroid.Urls(raw: "https://images.unsplash.com/photo-1721727078512-33183363f73f?ixid=M3w2MzU2MDN8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgyOTMwOXw&ixlib=rb-4.0.3", small: "https://images.unsplash.com/photo-1721727078512-33183363f73f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2MzU2MDN8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgyOTMwOXw&ixlib=rb-4.0.3&q=80&w=400"), likes: 0, user: HelloMyPolaroid.User(name: "Prajna", profileImage: HelloMyPolaroid.ProfileImage(small: "https://images.unsplash.com/profile-1720606357045-dba5aa86658dimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=32&h=32", medium: "https://images.unsplash.com/profile-1720606357045-dba5aa86658dimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=64&h=64", large: "https://images.unsplash.com/profile-1720606357045-dba5aa86658dimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=128&h=128"))), HelloMyPolaroid.Photo(id: "FiCA2zFJglQ", createdAt: "2024-07-23T10:42:13Z", width: 3000, height: 4000, urls: HelloMyPolaroid.Urls(raw: "https://images.unsplash.com/photo-1721731325736-bc475b90dad5?ixid=M3w2MzU2MDN8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgyOTMwOXw&ixlib=rb-4.0.3", small: "https://images.unsplash.com/photo-1721731325736-bc475b90dad5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2MzU2MDN8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgyOTMwOXw&ixlib=rb-4.0.3&q=80&w=400"), likes: 0, user: HelloMyPolaroid.User(name: "Prajna", profileImage: HelloMyPolaroid.ProfileImage(small: "https://images.unsplash.com/profile-1720606357045-dba5aa86658dimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=32&h=32", medium: "https://images.unsplash.com/profile-1720606357045-dba5aa86658dimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=64&h=64", large: "https://images.unsplash.com/profile-1720606357045-dba5aa86658dimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=128&h=128"))), HelloMyPolaroid.Photo(id: "zjSeuVUS5n4", createdAt: "2024-07-23T14:07:43Z", width: 7008, height: 4672, urls: HelloMyPolaroid.Urls(raw: "https://images.unsplash.com/photo-1721743576924-d93faba057e3?ixid=M3w2MzU2MDN8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgyOTMwOXw&ixlib=rb-4.0.3", small: "https://images.unsplash.com/photo-1721743576924-d93faba057e3?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2MzU2MDN8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgyOTMwOXw&ixlib=rb-4.0.3&q=80&w=400"), likes: 1, user: HelloMyPolaroid.User(name: "Wolfgang Hasselmann", profileImage: HelloMyPolaroid.ProfileImage(small: "https://images.unsplash.com/profile-1516997253075-2a25da8007e7?ixlib=rb-4.0.3&crop=faces&fit=crop&w=32&h=32", medium: "https://images.unsplash.com/profile-1516997253075-2a25da8007e7?ixlib=rb-4.0.3&crop=faces&fit=crop&w=64&h=64", large: "https://images.unsplash.com/profile-1516997253075-2a25da8007e7?ixlib=rb-4.0.3&crop=faces&fit=crop&w=128&h=128"))), HelloMyPolaroid.Photo(id: "bPl0NDthNoc", createdAt: "2024-07-23T14:07:01Z", width: 6240, height: 4160, urls: HelloMyPolaroid.Urls(raw: "https://images.unsplash.com/photo-1721743481627-ba25201c45f8?ixid=M3w2MzU2MDN8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgyOTMwOXw&ixlib=rb-4.0.3", small: "https://images.unsplash.com/photo-1721743481627-ba25201c45f8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2MzU2MDN8MHwxfHRvcGljfHxqMnplYzZrZDlWa3x8fHx8Mnx8MTcyMTgyOTMwOXw&ixlib=rb-4.0.3&q=80&w=400"), likes: 1, user: HelloMyPolaroid.User(name: "Francesco Ungaro", profileImage: HelloMyPolaroid.ProfileImage(small: "https://images.unsplash.com/profile-1657962511013-5534a14fcb1cimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=32&h=32", medium: "https://images.unsplash.com/profile-1657962511013-5534a14fcb1cimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=64&h=64", large: "https://images.unsplash.com/profile-1657962511013-5534a14fcb1cimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=128&h=128")))]
}
