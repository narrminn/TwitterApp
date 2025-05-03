//
//  ProfileHeader.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 26.03.25.
//

import UIKit

protocol ProfileHeaderProtocol {
    var headerImage: String? { get }
    var profileImage: String? { get }
    var fullName: String { get }
    var username: String { get }
    var bio: String? { get }
    var link: String? { get }
    var following: Int { get }
    var follower: Int { get }
    var isFollowing: Bool? { get }
    
}

class ProfileHeader: UICollectionReusableView {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    private let headerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .twitterBlue
        return iv
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "baseline_arrow_back_white_24dp")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleDissmissal), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        iv.image = UIImage(systemName: "person.circle.fill")
        return iv
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setTitle("Edit Profile", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Narmin Alasova"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "@narmin_a"
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textColor = .black
        label.text = "Ios Developer | Swift | UIKit. | Mobile App Developer."
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var linkLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .systemCyan
        label.text = "https://www.google.com"
        label.font = UIFont.systemFont(ofSize: 12)
        
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "200 Following"
        label.font = UIFont.systemFont(ofSize: 12)
        
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private let followerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.text = "300 Followers"
        label.font = UIFont.systemFont(ofSize: 12)
        
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    //MARK: - Properties
    
    private let filterBar = ProfileFilterView()
    var selectedFilterbarIndex = 0
    
    var followListButtonTapped: (() -> Void)?
    var followButtonTapped: (() -> Void)?
    var selectedProfileChangedAction: ((ProfileFilterOption) -> Void)?
    var isMyProfile = false
    var editProfileButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let defaultIndexPath = IndexPath(row: selectedFilterbarIndex, section: 0)
        guard let cell = filterBar.collectionView.cellForItem(at: defaultIndexPath) as? SegmentFilterCell else {
            return
        }

        underLine.frame.origin.x = cell.frame.origin.x
        underLine.frame.size.width = cell.frame.width
    }
    
    @objc func handleDissmissal() {
        print("Dismissal")
    }
    
    @objc func handleEditProfileFollow() {
        if !isMyProfile { // Follow Button Tapped
            followButtonTapped?()
            
            let title = editProfileFollowButton.titleLabel?.text == "Follow" ? "Unfollow" : "Follow"
            
            editProfileFollowButton.setTitle(title, for: .normal)
        } else { // Edit Button Tapped
            editProfileButtonTapped?()
        }
    }
    
    @objc func handleLinkTap() {
        guard let urlString = linkLabel.text,
              let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func handleFollowTapped() {
        followListButtonTapped?()
    }
    
    fileprivate func configureConstraints() {
        addSubview(containerView)
        containerView.addSubview(headerImageView)
        addSubview(profileImageView)
        addSubview(editProfileFollowButton)
        addSubview(filterBar)
        addSubview(underLine)
        
        filterBar.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLinkTap))
        linkLabel.addGestureRecognizer(tapGesture)
        
        let userDetailStack = UIStackView(arrangedSubviews: [fullNameLabel, usernameLabel, bioLabel, linkLabel])
        userDetailStack.axis = .vertical
        userDetailStack.distribution = .fillProportionally
        userDetailStack.spacing = 4
        
        addSubview(userDetailStack)
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel, followerLabel])
        followStack.axis = .horizontal
        followStack.spacing = 12
        followStack.distribution = .fillProportionally
        
        addSubview(followStack)
        
        let tapGestureFollow = UITapGestureRecognizer(target: self, action: #selector(handleFollowTapped))
        followStack.addGestureRecognizer(tapGestureFollow)
        
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 108)
        
        headerImageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor)
        
        profileImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor, paddingTop: -24, paddingLeft: 8)
        profileImageView.setDimensions(width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        editProfileFollowButton.anchor(top: containerView.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
        editProfileFollowButton.setDimensions(width: 100, height: 36)
        editProfileFollowButton.layer.cornerRadius = 36 / 2
        
        userDetailStack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
        followStack.anchor(top: userDetailStack.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        underLine.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width / 4.5, height: 2)
    }
    
    func configure(data: ProfileHeaderProtocol, isMyProfile: Bool) {
        if let headerImage = data.headerImage {
            headerImageView.loadImage(url: headerImage)
        }
        
        if let profileImage = data.profileImage {
            profileImageView.loadImage(url: profileImage)
        }
        
        fullNameLabel.text = data.fullName
        usernameLabel.text = "@\(data.username)"
        bioLabel.text = data.bio ?? ""
        linkLabel.text = data.link ?? ""
        followerLabel.text = "\(data.follower) followers"
        followingLabel.text = "\(data.following) following"
        
        self.isMyProfile = isMyProfile
        
        if isMyProfile {
            editProfileFollowButton.setTitle("Edit profile", for: .normal)
        }
        else {
            var title = "Follow"
            if let isFollowing = data.isFollowing, isFollowing == true {
                title = "Unfollow"
            }
            
            editProfileFollowButton.setTitle(title, for: .normal)
        }
    }
}

extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? SegmentFilterCell else { return }
        
        let selectedFilter = ProfileFilterOption.allCases[indexPath.row]
        
        selectedProfileChangedAction?(selectedFilter)
        selectedFilterbarIndex = indexPath.row
        
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underLine.frame.origin.x = xPosition
        }
    }
}
