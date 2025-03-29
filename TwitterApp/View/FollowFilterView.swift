//
//  ProfileFilterView.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 26.03.25.
//

import UIKit

protocol FollowFilterViewDelegate: AnyObject {
    func filterView (_ view: FollowFilterView, didSelect indexPath: IndexPath)
}

class FollowFilterView: UIView {
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
    
    weak var delegate: FollowFilterViewDelegate?
    
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
        
        collectionView.register(SegmentFilterCell.self, forCellWithReuseIdentifier: "SegmentFilterCell")
    }
}

extension FollowFilterView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SegmentFilterCell.self)", for: indexPath) as! SegmentFilterCell
        
        cell.configure(title: FollowFilterOption(rawValue: indexPath.row)?.description ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.filterView(self, didSelect: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2 - 4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
