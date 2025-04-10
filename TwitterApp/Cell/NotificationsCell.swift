//
//  NotificationsCell.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 07.04.25.
//

import UIKit

class NotificationsCell: UITableViewCell {
    //MARK: - UI Elements
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40 / 2
        iv.backgroundColor = .white
        iv.image = UIImage(systemName: "person.circle.fill")
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@maxjacobson"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "liked your tweet"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    //MARK: - Helpers
    
    fileprivate func configureUI() {
    
        configureConstraints()
    }
    
    fileprivate func configureConstraints() {
        contentView.addSubview(profileImageView)
        profileImageView.anchor(left: contentView.leftAnchor, paddingLeft: 12)
        profileImageView.centerY(inView: contentView)

        let nameStack = UIStackView(arrangedSubviews: [usernameLabel, notificationLabel])
        nameStack.axis = .horizontal
        nameStack.spacing = 8
        nameStack.alignment = .leading

        contentView.addSubview(nameStack)
        nameStack.anchor(left: profileImageView.rightAnchor, right: contentView.rightAnchor, paddingLeft: 4, paddingRight: 12)
        nameStack.centerY(inView: profileImageView)

        let underLineView = UIView()
        underLineView.backgroundColor = .systemGroupedBackground
        contentView.addSubview(underLineView)
        underLineView.anchor(left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, height: 1)
    }
    
    func configure(data: NotificationItem) {
        if let profileImage = data.profilePhotoPath {
            profileImageView.loadImage(url: profileImage)
        }
        
        usernameLabel.text = "@" + (data.username ?? "")
        notificationLabel.text = (data.description ?? "")
    }
}
