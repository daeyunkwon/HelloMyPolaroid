//
//  SearchPhotoViewController.swift
//  HelloMyPolaroid
//
//  Created by 권대윤 on 7/25/24.
//

import UIKit

import SnapKit

final class SearchPhotoViewController: BaseViewController {
    
    //MARK: - Properties
    
    private var page: Int = 1
    
    private enum OrderType: String {
        case relevant
        case latest
    }
    private var orderType: OrderType = .relevant
    
    private enum ColorType: String {
        case black
        case white
        case yellow
        case red
        case purple
        case green
        case blue
    }
    private var colorType: ColorType?
    
    private var recentSearchKeyword: String = "" //검색한 상태에서 관련순&최신순 정렬 기능용으로 사용
    
    private var isFetchExecuted = false //과도한 prefetch 작업 실행 방지용으로 사용
    
    private let colorOptions: [Color] = [
        Color(name: "블랙", uiColor: .black),
        Color(name: "화이트", uiColor: .white),
        Color(name: "옐로우", uiColor: .yellow),
        Color(name: "레드", uiColor: .red),
        Color(name: "퍼플", uiColor: .purple),
        Color(name: "그린", uiColor: .green),
        Color(name: "블루", uiColor: .blue),
    ]
    
    private var photos: [Photo] = []
    
    //MARK: - UI Components
    
    private let photoView = PhotoListWithColorOptionView()
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController()
        sc.searchBar.placeholder = "검색"
        sc.searchBar.delegate = self
        sc.searchBar.autocapitalizationType = .none
        sc.searchBar.autocorrectionType = .no
        return sc
    }()

    //MARK: - Life Cycle
    
    override func loadView() {
        view = self.photoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupAction()
    }
    
    //MARK: - Configurations
    
    private func setupCollectionView() {
        setupColorOptionCollectionView()
        setupPhotoCollectionView()
    }
    
    private func setupColorOptionCollectionView() {
        photoView.colorOptionCollectionView.dataSource = self
        photoView.colorOptionCollectionView.delegate = self
        photoView.colorOptionCollectionView.register(ColorOptionCollectionViewCell.self, forCellWithReuseIdentifier: ColorOptionCollectionViewCell.identifier)
    }
    
    private func setupPhotoCollectionView() {
        photoView.photoCollectionView.keyboardDismissMode = .onDrag
        photoView.photoCollectionView.prefetchDataSource = self
        photoView.photoCollectionView.dataSource = self
        photoView.photoCollectionView.delegate = self
        photoView.photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    }
    
    private func setupAction() {
        photoView.sortToggleButton.addTarget(self, action: #selector(sortToggleButtonTapped), for: .touchUpInside)
    }
    
    override func setupNavi() {
        navigationItem.title = "SEARCH PHOTO"
        navigationItem.searchController = searchController
    }
    
    override func configureUI() {
        super.configureUI()
        
        DispatchQueue.main.async {
            self.photoView.backView.layer.cornerRadius = self.photoView.backView.frame.size.height / 2
        }
    }
    
    //MARK: - Actions
    
    @objc private func sortToggleButtonTapped() {
        photoView.isSortButtonSelected.toggle()
        
        if photoView.isSortButtonSelected {
            self.orderType = .latest
        } else {
            self.orderType = .relevant
        }
        
        self.page = 1
        self.photos = []
        self.photoView.photoCollectionView.reloadData() //즉시반영(Index out of range 에러 방지를 위해)
        fetchData(isPrefetch: false)
    }
    
    //MARK: - Methods
    
    private func fetchData(isPrefetch: Bool) {
        var keyword: String
        
        if !recentSearchKeyword.isEmpty {
            keyword = recentSearchKeyword.trimmingCharacters(in: .whitespaces)
        } else {
            return
        }
        
        NetworkManager.shared.fetchData(api: .search(keyword: keyword, page: self.page, order: self.orderType.rawValue, color: self.colorType?.rawValue), model: Search.self) { result in
            switch result {
            case .success(let value):
                self.photos.append(contentsOf: value.results)
                self.photoView.photoCollectionView.reloadData()
                print("fetch 작업 실행됨")
                
                if !isPrefetch && !self.photos.isEmpty {
                    self.photoView.photoCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
                
            case .failure(let error):
                print(error.errorDescription)
                self.showNetworkResponseFailAlert()
            }
            
            self.isFetchExecuted = false
            
            if self.photos.isEmpty {
                self.photoView.showEmptySearchResultLabel()
            } else {
                self.photoView.hideEmptySearchResultLabel()
            }
        }
    }
    
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension SearchPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case photoView.colorOptionCollectionView:
            return colorOptions.count
            
        case photoView.photoCollectionView:
            return photos.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case photoView.colorOptionCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorOptionCollectionViewCell.identifier, for: indexPath) as? ColorOptionCollectionViewCell else {
                print("Failed to dequeue a ColorOptionCollectionViewCell. Using default UICollectionViewCell.")
                return UICollectionViewCell()
            }
            
            let data = self.colorOptions[indexPath.row]
            cell.cellConfig(color: data)
            
            return cell
            
        case photoView.photoCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
                print("Failed to dequeue a PhotoCollectionViewCell. Using default UICollectionViewCell.")
                return UICollectionViewCell()
            }
            
            cell.delegate = self
            cell.cellType = .searchAndLike
            cell.cellConfig(photo: self.photos[indexPath.row])
            
            return cell
        default:
            return UICollectionViewCell()
         }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SearchPhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == photoView.colorOptionCollectionView {
            let text = colorOptions[indexPath.item].name
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = text
            let size = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            return CGSize(width: size.width + 55, height: 50)
        }
        
        if collectionView == photoView.photoCollectionView {
            let cellSpacing: CGFloat = 3
            let cellCount: CGFloat = 2
            let width = UIScreen.main.bounds.width - ((cellSpacing * (cellCount - 1)))
            return CGSize(width: width / cellCount, height: width / cellCount * 1.3)
        }
        
        return CGSize(width: 0, height: 0)
    }
}

//MARK: - UICollectionViewDataSourcePrefetching

extension SearchPhotoViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for item in indexPaths {
            if item.row >= self.photos.count - 1 {
                if !isFetchExecuted {
                    self.isFetchExecuted = true
                    self.page += 1
                    fetchData(isPrefetch: true)
                }
            }
        }
    }
}

//MARK: - UISearchBarDelegate

extension SearchPhotoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        self.recentSearchKeyword = text
        self.page = 1
        self.photos = []
        self.photoView.photoCollectionView.reloadData() //즉시반영(Index out of range 에러 방지를 위해)
        self.fetchData(isPrefetch: false)
    }
}

//MARK: - PhotoCollectionViewCellDelegate

extension SearchPhotoViewController: PhotoCollectionViewCellDelegate {
    
    func likeButtonTapped(senderCell: PhotoCollectionViewCell) {
        senderCell.isLikeButtonSelected.toggle()
    }
}
