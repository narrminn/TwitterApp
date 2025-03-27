//
//  FeedController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 17.03.25.
//

import UIKit

class FeedController: UIViewController {
    // MARK: - Properties

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.register(TweetCell.self, forCellWithReuseIdentifier: "TweetCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    //MARK: - Properties
    
    var viewModel = FeedViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("tweetCreated"),
                                               object: nil,
                                               queue: nil) { [weak self] _ in
            self?.viewModel.reset()
            self?.collectionView.reloadData()
            self?.viewModel.getTweetAll()
        }
    }
    
    // MARK: - Helpers
    
    func configureViewModel() {
        
        viewModel.tweetGetSuccess = {
            self.collectionView.reloadData()
        }
        
        viewModel.errorHandling = { error in
            self.present(Alert.showAlert(title: "Error", message: error), animated: true)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        
        configureConstraints()
    }
    
    func configureConstraints() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FeedController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tweetAllData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.configure(data: viewModel.tweetAllData[indexPath.row])
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 140)
    }
}

