//
//  TweetDetailHeader.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 30.03.25.
//

import UIKit

class TweetDetailHeader: UICollectionReusableView {
    //MARK: - UI Elements
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .white
        iv.image = UIImage(systemName: "person.circle.fill")
        return iv
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Maximmilian"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@maxjacobson · 3h"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Some test Caption "
        return label
    }()
    
    private let commentImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bubble.left")
        iv.setDimensions(width: 20, height: 20)
        iv.tintColor = .gray
        return iv
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.text = "46"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let likeImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "heart")
        iv.setDimensions(width: 20, height: 20)
        iv.tintColor = .gray
        return iv
    }()

    private let likeLabel: UILabel = {
        let label = UILabel()
        label.text = "363"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    private let bookmarkImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bookmark")
        iv.setDimensions(width: 20, height: 20)
        iv.tintColor = .gray
        return iv
    }()
    
    private let shareImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "square.and.arrow.up")
        iv.setDimensions(width: 20, height: 20)
        iv.tintColor = .gray
        return iv
    }()
    
    private let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    private let repliesLabel: UILabel = {
        let label = UILabel()
        label.text = "Replies"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 200)
        layout.minimumInteritemSpacing = 8

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    //MARK: - Properties
    
    var likeButtonTapAction: (() -> Void)?
    var bookmarkButtonTapAction: (() -> Void)?
    var likeLabelButtonTapAction: (() -> Void)?
    
    private var isLiked = false
    private var isBookmarked = false
    
    var tweetFiles : [TweetFile] = []
    
    @objc private func handleCommentTapped() {
        print("Comment Tapped")
    }

    @objc private func handleLikeTapped() {
        isLiked.toggle()

        let imageName = isLiked ? "heart.fill" : "heart"
        let tintColor: UIColor = isLiked ? .systemRed : .gray

        likeImageView.image = UIImage(systemName: imageName)
        likeImageView.tintColor = tintColor
        
        animateReaction(icon: likeImageView, label: likeLabel, increaseBy: isLiked ? 1 : -1)
        
        likeButtonTapAction?()
    }

    @objc private func handleBookmarkTapped() {
        isBookmarked.toggle()

        let imageName = isBookmarked ? "bookmark.fill" : "bookmark"
        let tintColor: UIColor = isBookmarked ? .twitterBlue : .gray

        bookmarkImageView.image = UIImage(systemName: imageName)
        bookmarkImageView.tintColor = tintColor

        // sadəcə animasiya — label olmadığından say dəyişmir
        UIView.animate(withDuration: 0.1,
                       animations: {
                           self.bookmarkImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                       }, completion: { _ in
                           UIView.animate(withDuration: 0.1) {
                               self.bookmarkImageView.transform = .identity
                           }
                       })
        
        bookmarkButtonTapAction?()
    }


    @objc private func handleShareTapped() {
        print("Share tapped")
    }
    
    @objc private func handleLikeLabelTapped() {
        likeLabelButtonTapAction?()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func animateReaction(icon: UIImageView, label: UILabel, increaseBy: Int = 1) {
        // Scale animation
        UIView.animate(withDuration: 0.1,
                       animations: {
                           icon.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                           label.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                       }, completion: { _ in
                           UIView.animate(withDuration: 0.1) {
                               icon.transform = .identity
                               label.transform = .identity
                           }
                       })

        // Increment label count
        if let currentText = label.text, let count = Int(currentText) {
            label.text = "\(count + increaseBy)"
        }
    }
    
    fileprivate func configureUI() {
        backgroundColor = .white
        
        configureConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isLiked = false
        isBookmarked = false
        
        likeImageView.image = UIImage(systemName: "heart")
        likeImageView.tintColor = .gray
        
        bookmarkImageView.image = UIImage(systemName: "bookmark")
        bookmarkImageView.tintColor = .gray
        
        tweetFiles.removeAll()
    }
    
    fileprivate func configureConstraints() {
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        let nameStack = UIStackView(arrangedSubviews: [fullNameLabel, usernameLabel])
        nameStack.axis = .horizontal
        nameStack.spacing = 2
        nameStack.alignment = .leading

        fullNameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        usernameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        addSubview(nameStack)
        nameStack.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: nameStack.bottomAnchor, left: nameStack.leftAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 2)
        
        addSubview(imagesCollectionView)
        imagesCollectionView.anchor(top: captionLabel.bottomAnchor, left: captionLabel.leftAnchor, right: rightAnchor, paddingTop: 4, height: 200)
        
        let commentStack = UIStackView(arrangedSubviews: [commentImageView, commentLabel])
        commentStack.axis = .horizontal
        commentStack.spacing = 4
        
        // Comment Tap
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(handleCommentTapped))
        commentStack.isUserInteractionEnabled = true
        commentStack.addGestureRecognizer(commentTap)

        let likeStack = UIStackView(arrangedSubviews: [likeImageView, likeLabel])
        likeStack.axis = .horizontal
        likeStack.spacing = 4
        
        // Like Tap
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handleLikeTapped))
        likeImageView.isUserInteractionEnabled = true
        likeImageView.addGestureRecognizer(likeTap)
        
        let likeLabelTap = UITapGestureRecognizer(target: self, action: #selector(handleLikeLabelTapped))
        likeLabel.isUserInteractionEnabled = true
        likeLabel.addGestureRecognizer(likeLabelTap)
        
        let bookmarkStack = UIStackView(arrangedSubviews: [bookmarkImageView])
        bookmarkStack.axis = .horizontal
        bookmarkStack.spacing = 4
        
        // Bookmark Tap
        let bookmarkTap = UITapGestureRecognizer(target: self, action: #selector(handleBookmarkTapped))
        bookmarkStack.isUserInteractionEnabled = true
        bookmarkStack.addGestureRecognizer(bookmarkTap)
        
        let shareStack = UIStackView(arrangedSubviews: [shareImageView])
        shareStack.axis = .horizontal
        shareStack.spacing = 4
        
        // Share Tap
        let shareTap = UITapGestureRecognizer(target: self, action: #selector(handleShareTapped))
        shareStack.isUserInteractionEnabled = true
        shareStack.addGestureRecognizer(shareTap)
        
        let bottomStack = UIStackView(arrangedSubviews: [commentStack, likeStack, bookmarkStack, shareStack])
        bottomStack.axis = .horizontal
        bottomStack.distribution = .equalSpacing
        bottomStack.alignment = .center
        
        addSubview(repliesLabel)
        repliesLabel.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 12)
        
        addSubview(underLineView)
        underLineView.anchor(left: leftAnchor, bottom: repliesLabel.topAnchor, right: rightAnchor, paddingBottom: 4, height: 1)
        
        addSubview(bottomStack)
        bottomStack.anchor(left: captionLabel.leftAnchor, bottom: underLineView.topAnchor, right: rightAnchor, paddingBottom: 4, paddingRight: 12, height: 20
        )
        
        
    }
    
    func configure(data: TweetCellProtocol) {
        if let profileImage = data.profileImage {
            profileImageView.loadImage(url: profileImage)
        }
        
        fullNameLabel.text = data.fullName
        usernameLabel.text = "@" + data.username + " - " + data.createdAt
        captionLabel.text = data.caption
        commentLabel.text = "\(data.commentCount)"
        likeLabel.text = "\(data.likeCount)"
        
        tweetFiles = data.tweetFiles ?? []
        
        imagesCollectionView.reloadData()
        
        if data.isLiked {
            isLiked = true

            likeImageView.image = UIImage(systemName: "heart.fill")
            likeImageView.tintColor = .systemRed
        }
        
        if data.isSavedBookmarked {
            isBookmarked = true
            
            bookmarkImageView.image = UIImage(systemName: "bookmark.fill")
            bookmarkImageView.tintColor = .twitterBlue
        }
    }
        
}

extension TweetDetailHeader: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweetFiles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ImageCell.self)", for: indexPath) as! ImageCell
        
        if let imagePath = tweetFiles[indexPath.item].filePath {
            cell.configure(imagePath: imagePath)
        }
        
        return cell
    }
}
