//
//  CreateTweetController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 22.03.25.
//

import UIKit
import PhotosUI

class CreateTweetController: UIViewController {
    //MARK: UI Elements
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2

        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.gray, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2

        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 48, height: 48)
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.layer.cornerRadius = 48 / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
//    let imagePickerButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "photo"), for: .normal)
//        button.tintColor = .systemBlue
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    private let imagePickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pick Images", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 8

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captionTextView.becomeFirstResponder()
    }
    
    //MARK: - Properties
    
    private let captionTextView = CaptionTextView()
    
    var selectedImages: [UIImage] = []
    
    // MARK: - Selectors
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc func handleCreateTweet() {
        
    }
    
    @objc func handleImagePicker() {
        print("✅ handleImagePicker called")
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 5 // neçə şəkil seçilə bilər
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func updateImagePreviews() {
        imagesCollectionView.reloadData()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(actionButton)
        view.addSubview(cancelButton)
        view.addSubview(profileImageView)
        view.addSubview(captionTextView)
        view.addSubview(imagePickerButton)
        view.addSubview(imagesCollectionView)
        
        configureNavigationBar()
        configureConstraints()
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
//        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        actionButton.addTarget(self, action: #selector(handleCreateTweet), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        imagePickerButton.addTarget(self, action: #selector(handleImagePicker), for: .touchUpInside)
    }
    
    func configureConstraints() {
        captionTextView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 48),
            profileImageView.heightAnchor.constraint(equalToConstant: 48),
        
            captionTextView.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            captionTextView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8),
            captionTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            captionTextView.heightAnchor.constraint(equalToConstant: 200),
        
//            imagePickerButton.topAnchor.constraint(equalTo: captionTextView.bottomAnchor, constant: 12),
//            imagePickerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
//            imagePickerButton.widthAnchor.constraint(equalToConstant: 32),
//            imagePickerButton.heightAnchor.constraint(equalToConstant: 32),
            
            imagePickerButton.topAnchor.constraint(equalTo: captionTextView.bottomAnchor, constant: 16),
            imagePickerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
                    
            imagesCollectionView.topAnchor.constraint(equalTo: captionTextView.bottomAnchor, constant: 12),
            imagesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            imagesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            imagesCollectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}

extension CreateTweetController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.imageView.image = selectedImages[indexPath.item]
        return cell
    }
}

extension CreateTweetController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        selectedImages.removeAll()
        let group = DispatchGroup()
        
        for result in results {
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                defer { group.leave() }
                if let image = reading as? UIImage {
                    self.selectedImages.append(image)
                }
            }
        }
        
        group.notify(queue: .main) {
            self.imagesCollectionView.reloadData()
        }
    }
}
