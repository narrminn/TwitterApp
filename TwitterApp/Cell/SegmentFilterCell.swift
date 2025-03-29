//
//  ProfileFilterCell.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 26.03.25.
//

import UIKit

class SegmentFilterCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.text = "test filter"
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ?  UIFont.boldSystemFont(ofSize: 16) : .systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureUI() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
}
