//
//  FeedController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 17.03.25.
//

import UIKit

class FeedController: UIViewController {
    // MARK: - Properties

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.register(TweetCell.self, forCellWithReuseIdentifier: "TweetCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    //MARK: - Properties
    
    var viewModel = FeedViewModel(manager: TweetManager())
    var baseViewModel = TweetBaseViewModel()
    
    var refreshController = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureViewModel()
        configurenavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("tweetCreated"),
                                               object: nil,
                                               queue: nil) { [weak self] _ in
            self?.refreshAction()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Selectors
    
    @objc func handleSettingsLogoTapped() {
        let coordinator = SettingCoordinator(navigationController: navigationController!, viewController: self)
        coordinator.start()
    }
    
    // MARK: - Helpers
    
    func configureViewModel() {
        
        viewModel.tweetGetSuccess = {
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
        refreshAction()
    }
    
    func refreshAction() {
        viewModel.reset()
        collectionView.reloadData()
        viewModel.getTweetAll()
    }
    
    fileprivate func configurenavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

        // Apply the appearance configurations to the navigation bar
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.isNavigationBarHidden = false
        
        // Set a custom logo as the left bar button item
        if let logoImage = UIImage(named: "settingsLogo") {
            // Resize the image to a suitable size
            let resizedImage = logoImage.resized(to: CGSize(width: 24, height: 24)) // Adjust size as needed
            let logoButton = UIBarButtonItem(image: resizedImage, style: .plain, target: self, action: #selector(handleSettingsLogoTapped))
            
            // Set the custom logo as the left bar button item
            navigationItem.leftBarButtonItem = logoButton
            // Ensure the logo is aligned correctly to the left
            navigationItem.rightBarButtonItem?.tintColor = .systemBlue
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIView()) // boş görünməz view
        }
    }

    
    func configureUI() {
        view.backgroundColor = .white

        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let containerView = UIView()
        containerView.addSubview(imageView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 48), // ölçüləri tənzimlə
            imageView.widthAnchor.constraint(equalToConstant: 48)
        ])

        navigationItem.titleView = containerView
        
        configureConstraints()
    }
    
    func configureConstraints() {
        view.addSubview(collectionView)
        
        refreshController.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshController

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FeedController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tweetAllData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.configure(data: viewModel.tweetAllData[indexPath.row])
        
        cell.likeButtonTapAction = { [weak self] in
            self?.baseViewModel.likeTweet(tweetId: self?.viewModel.tweetAllData[indexPath.row].id ?? 0)
        }
        
        cell.likeLabelButtonTapAction = { [weak self] in
            let coordinator = LikedUserCoordinator(navigationController: self?.navigationController ?? UINavigationController(), tweetId: self?.viewModel.tweetAllData[indexPath.row].id ?? 0)
            
            coordinator.start()
        }
        
        cell.bookmarkButtonTapAction = { [weak self] in
            self?.baseViewModel.bookmarkTweet(tweetId: self?.viewModel.tweetAllData[indexPath.row].id ?? 0)
        }
        
        cell.profileButtonTapAction = { [weak self] in
            let coordinator = OtherProfileCoordinator(navigationController: self?.navigationController ?? UINavigationController(), userId: self?.viewModel.tweetAllData[indexPath.row].createdBy ?? 0)
            
            coordinator.start()
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let caption = viewModel.tweetAllData[indexPath.row].caption
        let horizontalPadding: CGFloat = 32
        let labelWidth = collectionView.frame.width - horizontalPadding
        let estimatedTextSize = UILabel.estimatedSize(caption, width: labelWidth)
        
        var baseHeight: CGFloat = 85
        baseHeight += estimatedTextSize.height
        
        if let tweetFiles = viewModel.tweetAllData[indexPath.row].tweetFiles,
           tweetFiles.count > 0 {
            baseHeight += 200
        }
        
        return CGSize(width: collectionView.frame.width, height: baseHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let coordinator = TweetDetailCoordinator(navigationController: navigationController ?? UINavigationController(), tweetId: viewModel.tweetAllData[indexPath.row].id ?? 0)
        coordinator.start()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.pagination(index: indexPath.row)
    }
}

extension UILabel {
    public static func estimatedSize(_ text: String, width: CGFloat) -> CGSize {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = text
        let targetSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        return label.sizeThatFits(targetSize)
    }
}

// Extension to resize UIImage
extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }
}


