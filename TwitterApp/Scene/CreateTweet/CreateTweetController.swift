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
  //      button.isEnabled = (success != nil) ? true : false
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 34)
        button.layer.cornerRadius = 32 / 2
//        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.gray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let photo = KeychainManager.shared.retrieve(key: "profilePhotoPath") {
            imageView.loadImage(url: photo)
        }
        
        imageView.layer.cornerRadius = 48 / 2
        
        return imageView
    }()
    
    let imagePickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
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

    //MARK: - Properties
    
    var viewModel = CreateTweetViewModel()
    
    private let captionTextView = CaptionTextView()
    
    var selectedImages: [UIImage] = []
    
    var imagePickerButtonBottomConstraint: NSLayoutConstraint!
    
    var homeCollectionReloadAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captionTextView.becomeFirstResponder()
    }
    
    func configureViewModel() {
        viewModel.fileUploadSuccess = { responseData in
            let dict = [
                "file_uuid" : responseData.data?.file?.id,
                "file_path" : responseData.data?.file?.path
            ]
            
            self.viewModel.tweetFiles.append(dict)
        }
        
        viewModel.tweetStoreSuccess = { [weak self] in
            self?.dismiss(animated: true)
            self?.tabBarController?.selectedIndex = 0
            NotificationCenter.default.post(name: NSNotification.Name("tweetCreated"), object: nil)
            //Ana sehife collectionView.reload
            self?.homeCollectionReloadAction?()
        }
        
        viewModel.errorHandling = { error in
            self.present(Alert.showAlert(title: "Error", message: error), animated: true)
        }
    }
    
    // MARK: - Selectors
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc func handleCreateTweet() {
        if let tweet = captionTextView.text, !tweet.isEmpty {
            viewModel.tweetStore(description: tweet)
        }
    }
    
    @objc func handleImagePicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 10
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func updateImagePreviews() {
        imagesCollectionView.reloadData()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            imagePickerButtonBottomConstraint.constant = -keyboardHeight + 28
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        imagePickerButtonBottomConstraint.constant = -4
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Helpers
    fileprivate func configureUI() {
        view.backgroundColor = .white
        
        imagePickerButton.addTarget(self, action: #selector(handleImagePicker), for: .touchUpInside)
        
        configureNavigationBar()
        configureConstraints()
    }
    
    fileprivate func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
//        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        actionButton.addTarget(self, action: #selector(handleCreateTweet), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    }
    
    fileprivate func configureConstraints() {
        
        view.addSubview(imagePickerButton)
        view.addSubview(actionButton)
        view.addSubview(cancelButton)
        view.addSubview(profileImageView)
        view.addSubview(captionTextView)
        view.addSubview(captionTextView)
        view.addSubview(imagesCollectionView)
        
//        [imagePickerButton, actionButton, cancelButton, profileImageView, captionTextView, imagesCollectionView].forEach{ view.addSubview($0)
//            $0.translatesAutoresizingMaskIntoConstraints = false
//        }
        
        captionTextView.translatesAutoresizingMaskIntoConstraints = false
        imagePickerButtonBottomConstraint = imagePickerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4)
        imagePickerButtonBottomConstraint.isActive = true

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 48),
            profileImageView.heightAnchor.constraint(equalToConstant: 48),
        
            captionTextView.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            captionTextView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8),
            captionTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            captionTextView.heightAnchor.constraint(equalToConstant: 360),

            imagePickerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
                    
            imagesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            imagesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            imagesCollectionView.bottomAnchor.constraint(equalTo: imagePickerButton.topAnchor, constant: -4),
            imagesCollectionView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
}

extension CreateTweetController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        cell.configure(image: selectedImages[indexPath.item])
        
        return cell
    }
}
