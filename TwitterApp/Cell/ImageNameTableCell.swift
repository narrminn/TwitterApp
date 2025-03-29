//
//  ImageNameTableCell.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 29.03.25.
//

import UIKit

protocol ImageNameTableProtocol {
    var profileImage: String? { get }
    var name: String { get }
    var username: String { get }
}

class ImageNameTableCell: UITableViewCell {
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
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@maxjacobson · 3h"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureUI() {
    
        configureConstraints()
    }
    
    fileprivate func configureConstraints() {
        contentView.addSubview(profileImageView)
        profileImageView.anchor(left: contentView.leftAnchor, paddingLeft: 12)
        profileImageView.centerY(inView: contentView)

        let nameStack = UIStackView(arrangedSubviews: [fullNameLabel, usernameLabel])
        nameStack.axis = .horizontal
        nameStack.spacing = 2
        nameStack.alignment = .leading

        contentView.addSubview(nameStack)
        nameStack.anchor(left: profileImageView.rightAnchor, right: contentView.rightAnchor, paddingLeft: 12, paddingRight: 12)
        nameStack.centerY(inView: profileImageView)

        let underLineView = UIView()
        underLineView.backgroundColor = .systemGroupedBackground
        contentView.addSubview(underLineView)
        underLineView.anchor(left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, height: 1)
    }
    
    func configure(data: ImageNameTableProtocol) {
        if let profileImage = data.profileImage {
            profileImageView.loadImage(url: profileImage)
        }
        
        fullNameLabel.text = data.name
        usernameLabel.text = "@\(data.username)"
    }

}
