//
//  ProfileController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 17.03.25.
//

import UIKit

class OtherProfileController: UIViewController {
    //MARK: - UI Elements
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
    
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    //MARK: - Properties
    
    var viewModel: OtherProfileViewModel
    var baseViewModel = TweetBaseViewModel()
    var selectedFilterbar = ProfileFilterOption.tweets
    
    var refreshController = UIRefreshControl()
    
    //MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationBar.isHidden = true
    }
    
    init(userId: Int) {
        self.viewModel = OtherProfileViewModel(userId: userId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViewModel() {
        viewModel.profileGetSuccess = {
            self.collectionView.reloadData()
            self.refreshController.endRefreshing()
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
        
        viewModel.followProfileSuccess = {
            
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
        
        viewModel.getOtherProfile()
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

extension OtherProfileController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
            data = viewModel.tweetAllOwnData[indexPath.row]
        } else if selectedFilterbar == .replies {
            data = viewModel.tweetAllRepliesData[indexPath.row]
        } else if selectedFilterbar == .likes {
            data = viewModel.tweetAllLikedData[indexPath.row]
        } else if selectedFilterbar == .savedTweets {
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
        if selectedFilterbar == .tweets {
            viewModel.paginationAllOwn(index: indexPath.row)
        } else if selectedFilterbar == .replies {
            viewModel.paginationAllReplies(index: indexPath.row)
        } else if selectedFilterbar == .likes {
            viewModel.paginationAllLiked(index: indexPath.row)
        } else if selectedFilterbar == .savedTweets {
            viewModel.paginationAllSaved(index: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(ProfileHeader.self)", for: indexPath) as! ProfileHeader
        
        if let profile = viewModel.profile {
            header.configure(data: profile, isMyProfile: false)
            
            header.followListButtonTapped = { [weak self] in
                let coordinator = FollowUserCoordinator(navigationController: self?.navigationController ?? UINavigationController() , userId: profile.id ?? 0)
                
                coordinator.start()
            }
            
            header.followButtonTapped = { [weak self] in
                self?.viewModel.followProfile()
            }
        }
        
        header.selectedProfileChangedAction = { selectedFilter in
            self.selectedFilterbar = selectedFilter
            self.collectionView.reloadData()
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 330)
    }
}

