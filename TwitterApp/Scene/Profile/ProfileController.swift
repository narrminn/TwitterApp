//
//  ProfileController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 17.03.25.
//

import UIKit

class ProfileController: UIViewController {
    //MARK: - UI Elements
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
    
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    //MARK: - Properties
    
    var viewModel = ProfileViewModel()
    var baseViewModel = TweetBaseViewModel()
    var selectedFilterbar = ProfileFilterOption.tweets
    
    var refreshController = UIRefreshControl()
    
    //MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureViewModel()
        
        getMyProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("profileUpdated"),
                                               object: nil,
                                               queue: nil) { [weak self] _ in
            self?.pullToRefresh()
        }
        
//        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func configureViewModel() {
        viewModel.profileGetSuccess = {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.refreshController.endRefreshing()
            }
        }
        
        viewModel.getTweetAllOwnSuccess = {
            self.collectionView.reloadData()
            self.refreshController.endRefreshing()
        }
        
        viewModel.getTweetAllRepliesSuccess = {
            self.collectionView.reloadData()
            self.refreshController.endRefreshing()
        }
        
        viewModel.getTweetAllLikedSuccess = {
            self.collectionView.reloadData()
            self.refreshController.endRefreshing()
        }
        
        viewModel.getTweetAllSavedSuccess = {
            self.collectionView.reloadData()
            self.refreshController.endRefreshing()
        }
        
        viewModel.errorHandling = { error in
            self.present(Alert.showAlert(title: "Error", message: error), animated: true)
            self.refreshController.endRefreshing()
        }
        
        baseViewModel.errorHandling = { error in
            self.present(Alert.showAlert(title: "Error", message: error), animated: true)
            self.refreshController.endRefreshing()
        }
    }
    
    @objc func pullToRefresh() {
        viewModel.resetAllOwn()
        viewModel.resetAllReplies()
        viewModel.resetAllLiked()
        viewModel.resetAllSaved()
                
        getMyProfile()
    }
    
    func getMyProfile() {
        Task { @MainActor in
            await viewModel.getMyProfile()
        }
    }
    
    func configureUI() {
        configureCollectionView()
        configureConsraints()
    }
    
    func configureConsraints() {
        view.addSubview(collectionView)
        
        refreshController.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshController
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func configureCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: "TweetCell")
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(ProfileHeader.self)")
    }
}

extension ProfileController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedFilterbar == .tweets {
            return viewModel.tweetAllOwnData.count
        } else if selectedFilterbar == .replies {
            return viewModel.tweetAllRepliesData.count
        } else if selectedFilterbar == .likes {
            return viewModel.tweetAllLikedData.count
        } else if selectedFilterbar == .savedTweets {
            return viewModel.tweetAllSavedData.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TweetCell.self)", for: indexPath) as! TweetCell
        
        var data: TweetCellProtocol?
        
        if selectedFilterbar == .tweets {
            guard indexPath.row < viewModel.tweetAllOwnData.count else { return cell }

            data = viewModel.tweetAllOwnData[indexPath.row]
        } else if selectedFilterbar == .replies {
            guard indexPath.row < viewModel.tweetAllRepliesData.count else { return cell }
            
            data = viewModel.tweetAllRepliesData[indexPath.row]
        } else if selectedFilterbar == .likes {
            guard indexPath.row < viewModel.tweetAllLikedData.count else { return cell }
            
            data = viewModel.tweetAllLikedData[indexPath.row]
        } else if selectedFilterbar == .savedTweets {
            guard indexPath.row < viewModel.tweetAllSavedData.count else { return cell }
            
            data = viewModel.tweetAllSavedData[indexPath.row]
        }
        
        if let data = data {
            cell.configure(data: data)
            
            cell.likeButtonTapAction = { [weak self] in
                self?.baseViewModel.likeTweet(tweetId: data.id ?? 0)
            }
            
            cell.likeLabelButtonTapAction = { [weak self] in
                let coordinator = LikedUserCoordinator(navigationController: self?.navigationController ?? UINavigationController(), tweetId: data.id ?? 0)
                
                coordinator.start()
            }
            
            cell.bookmarkButtonTapAction = { [weak self] in
                self?.baseViewModel.bookmarkTweet(tweetId: data.id ?? 0)
            }
            
            cell.profileButtonTapAction = { [weak self] in
                let coordinator = OtherProfileCoordinator(navigationController: self?.navigationController ?? UINavigationController(), userId: data.createdBy ?? 0)
                
                coordinator.start()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var caption = ""
        var tweetFiles: [TweetFile] = []
        
        if selectedFilterbar == .tweets {
            caption = viewModel.tweetAllOwnData[indexPath.row].caption
            tweetFiles = viewModel.tweetAllOwnData[indexPath.row].tweetFiles ?? []
        } else if selectedFilterbar == .replies {
            caption = viewModel.tweetAllRepliesData[indexPath.row].caption
            tweetFiles = viewModel.tweetAllRepliesData[indexPath.row].tweetFiles ?? []
        } else if selectedFilterbar == .likes {
            caption = viewModel.tweetAllLikedData[indexPath.row].caption
            tweetFiles = viewModel.tweetAllLikedData[indexPath.row].tweetFiles ?? []
        } else if selectedFilterbar == .savedTweets {
            caption = viewModel.tweetAllSavedData[indexPath.row].caption
            tweetFiles = viewModel.tweetAllSavedData[indexPath.row].tweetFiles ?? []
        } else {
            return CGSize(width: collectionView.frame.width, height: 120)
        }
        
        let horizontalPadding: CGFloat = 32
        let labelWidth = collectionView.frame.width - horizontalPadding
        let estimatedTextSize = UILabel.estimatedSize(caption, width: labelWidth)
        
        var baseHeight: CGFloat = 85
        baseHeight += estimatedTextSize.height
        
        if tweetFiles.count > 0 {
            baseHeight += 200
        }
        
        return CGSize(width: collectionView.frame.width, height: baseHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var data: TweetCellProtocol?
        
        if selectedFilterbar == .tweets {
            data = viewModel.tweetAllOwnData[indexPath.row]
        } else if selectedFilterbar == .replies {
            data = viewModel.tweetAllRepliesData[indexPath.row]
        } else if selectedFilterbar == .likes {
            data = viewModel.tweetAllLikedData[indexPath.row]
        } else if selectedFilterbar == .savedTweets {
            data = viewModel.tweetAllSavedData[indexPath.row]
        }
        
        let coordinator = TweetDetailCoordinator(navigationController: navigationController ?? UINavigationController(), tweetId: data?.id ?? 0)
        coordinator.start()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        Task { @MainActor in
            if selectedFilterbar == .tweets {
                await viewModel.paginationAllOwn(index: indexPath.row)
            } else if selectedFilterbar == .replies {
                await viewModel.paginationAllReplies(index: indexPath.row)
            } else if selectedFilterbar == .likes {
                await viewModel.paginationAllLiked(index: indexPath.row)
            } else if selectedFilterbar == .savedTweets {
                await viewModel.paginationAllSaved(index: indexPath.row)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(ProfileHeader.self)", for: indexPath) as! ProfileHeader
        
        if let profile = viewModel.profile {
            header.configure(data: profile, isMyProfile: true)
            
            header.followListButtonTapped = { [weak self] in
                let coordinator = FollowUserCoordinator(navigationController: self?.navigationController ?? UINavigationController() , userId: profile.id ?? 0)
                
                coordinator.start()
            }
        }
        
        header.selectedProfileChangedAction = { selectedFilter in
            self.selectedFilterbar = selectedFilter
            self.collectionView.reloadData()
        }
        
        header.editProfileButtonTapped = { [weak self] in
            let coordinator = EditProfileCoordinator(navigationController: self?.navigationController ?? UINavigationController(), viewController: self)
            coordinator.start()
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 330)
    }
}

