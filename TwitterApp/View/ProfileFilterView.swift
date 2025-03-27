//
//  ProfileFilterView.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 26.03.25.
//

import UIKit

protocol ProfileFilterViewDelegate: AnyObject {
    func filterView (_ view: ProfileFilterView, didSelect indexPath: IndexPath)
}

class ProfileFilterView: UIView {
    //MARK: - UI Elements
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    //MARK: - Properties
    
    weak var delegate: ProfileFilterViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
        
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: "ProfileFilterCell")
    }
}

extension ProfileFilterView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ProfileFilterCell.self)", for: indexPath) as! ProfileFilterCell
        
        cell.configure(title: ProfileFilterOption(rawValue: indexPath.row)?.description ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.filterView(self, didSelect: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4 - 8, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
