//
//  RegisterController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import UIKit

class RegisterController: UIViewController {
    // MARK: - UI Elements
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "TwitterLogo")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 150, height: 150)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
      }()
    
    private lazy var emailContainerView: UIView = {
        let image = UIImage(named: "ic_mail_outline_white_2x-1")
        
        let view = Utilities().inputContainerView(withImage: image ?? UIImage(), textField: emailField)
        
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = UIImage(named: "ic_lock_outline_white_2x")
        
        let view = Utilities().inputContainerView(withImage: image ?? UIImage(), textField: passwordField)
        
        return view
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let image = UIImage(named: "ic_person_outline_white_2x")
        
        let view = Utilities().inputContainerView(withImage: image ?? UIImage(), textField: nameField)
        
        return view
    }()
    
    private lazy var usernameContainerView: UIView = {
        let image = UIImage(named: "ic_person_outline_white_2x")
        
        let view = Utilities().inputContainerView(withImage: image ?? UIImage(), textField: userNameField)
        
        return view
    }()
    
    
    private let emailField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Email")
        
        return textField
    }()

    private let passwordField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let nameField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Full name")
        
        return textField
    }()
    
    private let userNameField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Username")
        
        return textField
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Already have an account?", " Log In")
        return button
    }()
    
    // MARK: - Properties
    private var viewModel = RegisterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureViewModel()
    }
    
    func configureViewModel() {
        viewModel.registerSuccess = { userId in
            let coordinator = RegisterApproveCoordinator(userId: userId, email: self.emailField.text ?? "", navigationController: self.navigationController ?? UINavigationController())
            coordinator.start()
        }
        
        viewModel.errorHandling = { error in
            self.present(Alert.showAlert(title: "Error", message: "Email already exists"), animated: true)
        }
    }

    @objc func signUpTapped() {
        if let email = emailField.text, let name = nameField.text, let userName = userNameField.text, let password = passwordField.text, !email.isEmpty, !name.isEmpty, !userName.isEmpty, !password.isEmpty {
            print("tapped")
            
            viewModel.register(username: userName, name: name, email: email, password: password)
            
        } else {
            self.present(Alert.showAlert(title: "Error", message: "Please fill all inputs"), animated: true)
        }
    }
    
   @objc func signInTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func configureUI() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(registerButton)
        view.addSubview(alreadyHaveAccountButton)
        
        registerButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        alreadyHaveAccountButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView,fullnameContainerView, usernameContainerView, registerButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor, paddingLeft: 40, paddingRight: 40)
    }
}
