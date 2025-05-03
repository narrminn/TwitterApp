//
//  LoginController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import UIKit

class LoginController: UIViewController {
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
    
    private let emailField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Email")
        
        return textField
    }()

    private let passwordField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Don't have an account?", " Sign Up")
        return button
    }()
    
    // MARK: - Properties
    var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureViewModel()
    }
    
    func configureViewModel() {
        viewModel.loginSuccess = { loginModel in
            self.loginSuccess(loginModel: loginModel)
        }
        
        viewModel.errorHandling = { error in
            self.present(Alert.showAlert(title: "Error", message: "Email or password is wrong. Please try again"), animated: true)
        }
        
        bindViewModel()
    }
    
    func loginSuccess(loginModel: LoginModel) {
        _ = KeychainManager.shared.save(key: "token", value: loginModel.data?.token ?? "")
        _ = KeychainManager.shared.save(key: "userId", value: String(loginModel.data?.user?.id ?? 0))
        _ = KeychainManager.shared.save(key: "email", value: loginModel.data?.user?.email ?? "")
        _ = KeychainManager.shared.save(key: "name", value: loginModel.data?.user?.name ?? "")
        _ = KeychainManager.shared.save(key: "username", value: loginModel.data?.user?.username ?? "")
        _ = KeychainManager.shared.save(key: "profilePhotoPath", value: loginModel.data?.user?.profilePhotoPath ?? "")
        _ = KeychainManager.shared.save(key: "bannerPhotoPath", value: loginModel.data?.user?.profileBannerPath ?? "")
        _ = KeychainManager.shared.save(key: "link", value: loginModel.data?.user?.link ?? "")
        _ = KeychainManager.shared.save(key: "bio", value: loginModel.data?.user?.bio ?? "")
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            
            let coordinator = AppCoordinator(window: sceneDelegate.window, navigationController: self.navigationController ?? UINavigationController())
            coordinator.start()
        }
    }
    
    func bindViewModel() {
        Task { @MainActor in
            viewModel.stateUpdated = { [weak self] state in
                switch state {
                case .loginSuccess(let loginModel):
                    self?.loginSuccess(loginModel: loginModel)
                case .loading:
                    break
                case .loaded:
                    break
                case .errorHandling(_):
                    self?.present(Alert.showAlert(title: "Error", message: "Email or password is wrong. Please try again"), animated: true)
                case .idle:
                    break;
                }
            }
        }
    }

    @objc func loginTapped() {
        if let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty {
        
        Task { @MainActor in
                await viewModel.loginAsync(email: email, password: password)
            }
        } else {
            self.present(Alert.showAlert(title: "Error", message: "Please fill all inputs"), animated: true)
        }
    }
    
    @objc func signUpTapped() {
        let coordinator = RegisterCoordinator(navigationController: self.navigationController ?? UINavigationController())
        coordinator.start()
    }
    
    private func configureUI() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true

        view.addSubview(loginButton)
//        view.addSubview(dontHaveAccountButton)
        
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        dontHaveAccountButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor, paddingLeft: 40, paddingRight: 40)
    }
}
