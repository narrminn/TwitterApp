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
    var onValueChanged: ((String) -> Void)?
    
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
        onValueChanged?(infoTextField.text ?? "")
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

    func configure(model: EditProfileModel) {
        titleLabel.text = model.type.description
        
        switch model.type {
        case .bio:
            infoTextField.isHidden = true
            bioTextView.isHidden = false
            bioTextView.text = model.value
            bioTextView.delegate = self
        default:
            infoTextField.isHidden = false
            bioTextView.isHidden = true
            infoTextField.text = model.value
        }
    }
}

// UITextViewDelegate
extension EditProfileCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        onValueChanged?(textView.text ?? "")
    }
}
