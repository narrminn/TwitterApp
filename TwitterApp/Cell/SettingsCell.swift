//
//  SettingsCell.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 13.04.25.
//

import UIKit

class SettingsCell: UITableViewCell {
    //MARK: - UI Elements
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .gray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let optionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Properties
    
    var onTap: (() -> Void)?
    
   
    //MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc private func labelTapped() {
        onTap?()
    }
    
    //MARK: - Helpers
    
    fileprivate func configureUI() {
        backgroundColor = .white
        
        addSubview(iconImageView)
        addSubview(optionLabel)
        
        configureConstraints()
    }
    
    fileprivate func configureConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            optionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            optionLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        optionLabel.addGestureRecognizer(tap)
    }

    func configure(with option: SettingsOption) {
        optionLabel.text = option.title
        optionLabel.textColor = option.titleColor
        
        iconImageView.image = UIImage(systemName: option.iconName)
        iconImageView.tintColor = option.iconTintColor
    }
}

