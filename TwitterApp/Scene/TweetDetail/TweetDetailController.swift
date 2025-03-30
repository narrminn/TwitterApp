//
//  TweetDetailController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 30.03.25.
//

import UIKit

class TweetDetailController: UIViewController {
    //MARK: - UI Elements
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
    
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private var replyTextView: UITextView = {
            let textView = UITextView()
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.layer.borderColor = UIColor.lightGray.cgColor
            textView.layer.borderWidth = 1
            textView.layer.cornerRadius = 8
            textView.font = UIFont.systemFont(ofSize: 16)
            textView.text = "Tweet your reply"
            textView.textColor = .lightGray
            return textView
        }()
    
    private var replyTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.placeholder = " Tweet your reply"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
        
    private var replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal) // Using the system "paperplane.fill" icon
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .twitterBlue // Set the image color to white
        
        button.frame = CGRect(x: 0, y: 0, width: 12, height: 12) // Adjust the size for the icon
        button.layer.cornerRadius = 12 / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Properties
    
    var viewModel: TweetDetailViewModel
    var baseViewModel = TweetBaseViewModel()
    
    //MARK: - Selectors
    
    @objc private func handleCommentReply() {
        viewModel.tweetCommentStore(comment: replyTextField.text ?? "")
    }
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBar = self.tabBarController as? MainTabController {
            tabBar.setCreateTweetButton(hidden: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tabBar = self.tabBarController as? MainTabController {
            tabBar.setCreateTweetButton(hidden: false)
        }
    }
    
    init(tweetId: Int) {
        self.viewModel = TweetDetailViewModel(tweetId: tweetId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    fileprivate func configureViewModel() {
        
        viewModel.getTweetDetailSuccess = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.getTweetCommentsSuccess = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.tweetCommentStoreSuccess = { [weak self] in
            self?.viewModel.getTweetComments()
            self?.replyTextField.text = ""
        }
        
        viewModel.errorHandling = { error in
            self.present(Alert.showAlert(title: "Error", message: error), animated: true)
        }
        
        viewModel.getTweetDetail()
        viewModel.getTweetComments()
    }
    
    fileprivate func configureUI() {
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        
        navigationController?.navigationBar.tintColor = .twitterBlue
        
        configureCollectionView()
        configureConstraints()
    }
    
    fileprivate func configureConstraints() {
        
        view.addSubview(collectionView)
        view.addSubview(replyTextField)
        view.addSubview(replyButton)
        
        replyButton.addTarget(self, action: #selector(handleCommentReply), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: replyTextField.topAnchor, constant: -4),
            
            replyTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            replyTextField.trailingAnchor.constraint(equalTo: replyButton.leadingAnchor, constant: -16),
            replyTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            replyTextField.heightAnchor.constraint(equalToConstant: 40),
                        
            replyButton.leadingAnchor.constraint(equalTo: replyTextField.trailingAnchor, constant: 16),
            replyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            replyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            replyButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    fileprivate func configureCollectionView() {
        
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: "CommentCell")
        collectionView.register(TweetDetailHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(TweetDetailHeader.self)")
        
    }
}

extension TweetDetailController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tweetComments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CommentCell.self)", for: indexPath) as! CommentCell
        cell.configure(data: viewModel.tweetComments[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let caption = viewModel.tweetDetail?.caption ?? ""
            let horizontalPadding: CGFloat = 32
            let labelWidth = collectionView.frame.width - horizontalPadding
            
            let estimatedTextSize = UILabel.estimatedSize(caption, width: labelWidth)
            
            var baseHeight: CGFloat = 75
            baseHeight += estimatedTextSize.height
            
            return CGSize(width: collectionView.frame.width, height: baseHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(TweetDetailHeader.self)", for: indexPath) as! TweetDetailHeader
        
        if let tweetDetail = viewModel.tweetDetail {
            header.configure(data: tweetDetail)
        }
        
        header.likeButtonTapAction = { [weak self] in
            self?.baseViewModel.likeTweet(tweetId: self?.viewModel.tweetDetail?.id ?? 0)
        }
        
        header.likeLabelButtonTapAction = { [weak self] in
            let coordinator = LikedUserCoordinator(navigationController: self?.navigationController ?? UINavigationController(), tweetId: self?.viewModel.tweetDetail?.id ?? 0)
            
            coordinator.start()
        }
        
        header.bookmarkButtonTapAction = { [weak self] in
            self?.baseViewModel.bookmarkTweet(tweetId: self?.viewModel.tweetDetail?.id ?? 0)
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let caption = viewModel.tweetDetail?.caption ?? ""
        let horizontalPadding: CGFloat = 32
        let labelWidth = collectionView.frame.width - horizontalPadding
        let estimatedTextSize = UILabel.estimatedSize(caption, width: labelWidth)
        
        var baseHeight: CGFloat = 90
        baseHeight += estimatedTextSize.height
        
        if let tweetFiles = viewModel.tweetDetail?.tweetFiles,
           tweetFiles.count > 0 {
            baseHeight += 200
        }
        
        return CGSize(width: collectionView.frame.width, height: baseHeight)
    }
}

extension UILabel {
    static func estimatedSize(_ text: String, width: CGFloat, font: UIFont = UIFont.systemFont(ofSize: 16)) -> CGSize {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let rect = (text as NSString).boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
                                                   options: .usesLineFragmentOrigin,
                                                   attributes: attributes,
                                                   context: nil)
        return rect.size
    }
}

