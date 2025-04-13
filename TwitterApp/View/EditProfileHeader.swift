//
//  EditProfileHeader.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 11.04.25.
//

import UIKit
import PhotosUI

class EditProfileHeader: UIView {
    //MARK: UI Elements
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    let headerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .twitterBlue
        iv.isUserInteractionEnabled = true

        if let bannerPhoto = KeychainManager.shared.retrieve(key: "bannerPhotoPath") {
            iv.loadImage(url: bannerPhoto)
        }
        
        return iv
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        iv.image = UIImage(systemName: "person.circle.fill")
        iv.isUserInteractionEnabled = true
        
        if let photo = KeychainManager.shared.retrieve(key: "profilePhotoPath") {
            iv.loadImage(url: photo)
        }
        
        return iv
    }()
    
    private let cameraOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.layer.cornerRadius = 35 // yarısı olmalıdır
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true

        let imageView = UIImageView(image: UIImage(systemName: "camera.fill"))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20)
        ])

        return view
    }()
    
    //MARK: - Properties
    private var currentTarget: editProfileHeaderTarget?
    var changeImageHandler: ((UIImage, editProfileHeaderTarget) -> Void)?
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .twitterBlue
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func changeHeaderTapped() {
        currentTarget = .header
        presentImagePicker()
    }
    
    @objc func changeProfileTapped() {
        currentTarget = .profile
        presentImagePicker()
    }
        
    // MARK: - Helpers
    
    private func presentImagePicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        
        parentViewController()?.present(picker, animated: true)
    }
        
    fileprivate func configureConstraints() {
        addSubview(containerView)
        containerView.addSubview(headerImageView)
        addSubview(profileImageView)
        addSubview(cameraOverlayView)
        
        let tapGestureHeaderView = UITapGestureRecognizer(target: self, action: #selector(changeHeaderTapped))
        headerImageView.addGestureRecognizer(tapGestureHeaderView)
        
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 108)
        
        headerImageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor)
        
//        let tapGestureProfileView = UITapGestureRecognizer(target: self, action: #selector(changeProfileTapped))
//        profileImageView.addGestureRecognizer(tapGestureProfileView)
        
        profileImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor, paddingTop: -24, paddingLeft: 8)
        profileImageView.setDimensions(width: 70, height: 70)
        profileImageView.layer.cornerRadius = 70 / 2
        
        let tapGestureCamera = UITapGestureRecognizer(target: self, action: #selector(changeProfileTapped))
        cameraOverlayView.addGestureRecognizer(tapGestureCamera)
        
        cameraOverlayView.anchor(
            top: profileImageView.topAnchor,
            left: profileImageView.leftAnchor,
            bottom: profileImageView.bottomAnchor,
            right: profileImageView.rightAnchor
        )
    }
}

extension UIView {
    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

// MARK: - PHPickerViewControllerDelegate

extension EditProfileHeader: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            DispatchQueue.main.async {
                guard let self = self, let image = image as? UIImage else { return }
                
                if let currentTarget = self.currentTarget {
                    self.changeImageHandler?(image, currentTarget)
                }
                
                switch self.currentTarget {
                case .profile:
                    self.profileImageView.image = image
                case .header:
                    self.headerImageView.image = image
                default:
                    break
                }
            }
        }
    }
}
