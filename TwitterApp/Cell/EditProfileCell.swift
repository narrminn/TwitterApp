//
//  EditProfileCell.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 11.04.25.
//

import UIKit

class EditProfileCell: UITableViewCell {
    //MARK: - UI Elements
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "Test title"
        return label
    }()
    
    lazy var infoTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.textAlignment = .left
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
//        textField.text = "Test User Attributes"
        return textField
    }()
    
    let bioTextView: CaptionTextView = {
        let textView = CaptionTextView()
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .black
        textView.placeholderLabel.text = ""
//        textView.text = "Add a bio"
        return textView
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
    
    @objc func handleUpdateUserInfo() {
        
    }
    
    //MARK: - Helpers
    
    fileprivate func configureUI() {
        selectionStyle = .none
        
        configureConstraints()
    }
    
    fileprivate func configureConstraints() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoTextField)
        contentView.addSubview(bioTextView)
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 16)
        
        infoTextField.anchor(top: topAnchor, left: titleLabel.rightAnchor, bottom: bottomAnchor ,right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 8)
        
        bioTextView.anchor(top: topAnchor, left: titleLabel.rightAnchor, bottom: bottomAnchor ,right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 8)
    }
    
    func configure(editProfileOption: EditProfileOption) {
        titleLabel.text = editProfileOption.description
        
        switch editProfileOption {
        case .fullName:
            infoTextField.isHidden = false
            bioTextView.isHidden = true
            infoTextField.text = KeychainManager.shared.retrieve(key: "name") ?? ""
        case .username:
            infoTextField.isHidden = false
            bioTextView.isHidden = true
            infoTextField.text = KeychainManager.shared.retrieve(key: "username") ?? ""
        case .bio:
            infoTextField.isHidden = true
            bioTextView.isHidden = false
            bioTextView.text = KeychainManager.shared.retrieve(key: "bio") ?? ""
        case .website:
            infoTextField.isHidden = false
            bioTextView.isHidden = true
            infoTextField.text = KeychainManager.shared.retrieve(key: "link") ?? ""
        }
    }
}
