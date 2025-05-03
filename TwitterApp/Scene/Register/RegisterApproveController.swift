//
//  RegisterApproveController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import UIKit

class RegisterApproveController: UIViewController {
    // MARK: - UI Elements
    
    private let iconImageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 44, weight: .regular, scale: .medium)
        let image = UIImage(systemName: "lock.circle", withConfiguration: config)
        
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.twitterBlue
        imageView.backgroundColor = UIColor.white
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Verification Code"
            label.font = UIFont.boldSystemFont(ofSize: 22)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "We have sent the verification code to your email\n"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
//        textField.backgroundColor = UIColor(white: 1, alpha: 0.2)
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter code",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        return textField
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Verify", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    private var viewModel: RegisterApproveViewModel
    private var email: String


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureViewModel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        descriptionLabel.text = (descriptionLabel.text ?? "") + " \(email)"
    }
    
    init(userId: Int, email: String) {
        self.viewModel = RegisterApproveViewModel(userId: userId)
        self.email = email
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let bottomPadding = view.safeAreaInsets.bottom
            let keyboardHeight = keyboardFrame.height - bottomPadding
            self.view.frame.origin.y = -keyboardHeight / 2
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        self.view.frame.origin.y = 0
    }

    
    private func configureViewModel() {
        viewModel.registerApproveSuccess = {
            if let viewControllers = self.navigationController?.viewControllers, viewControllers.count >= 3 {
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            }
        }
        
        viewModel.errorHandling = { error in
            self.present(Alert.showAlert(title: "Error", message: "Code is wrong or expired"), animated: true)
        }
    }
    
    @objc func submitTapped() {
        if let code = codeField.text, !code.isEmpty {
            viewModel.registerApprove(code: code)
        } else {
            self.present(Alert.showAlert(title: "Error", message: "Please enter code"), animated: true)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .twitterBlue
        
        view.addSubview(iconImageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(codeField)
        view.addSubview(submitButton)
        
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 100),
            iconImageView.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            codeField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
            codeField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            codeField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            codeField.heightAnchor.constraint(equalToConstant: 50),

            submitButton.topAnchor.constraint(equalTo: codeField.bottomAnchor, constant: 30),
            submitButton.leadingAnchor.constraint(equalTo: codeField.leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: codeField.trailingAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
