//
//  CommentCell.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 30.03.25.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
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
    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    fileprivate func configureUI() {
        backgroundColor = .white
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

    
        let underLineView = UIView()
        underLineView.backgroundColor = .systemGroupedBackground
        addSubview(underLineView)
        underLineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
    }
    
    func configure(data: Comment) {
        if let profileImage = data.profilePhotoPath {
            profileImageView.loadImage(url: profileImage)
        }
        
        fullNameLabel.text = data.name
        usernameLabel.text = "@" + data.username + " - " + data.createdAt
        captionLabel.text = data.comment
    }
}
