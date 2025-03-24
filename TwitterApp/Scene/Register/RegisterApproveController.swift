//
//  RegisterApproveController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import UIKit

class RegisterApproveController: UIViewController {
    // MARK: - UI Elements
    private let codeField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 1, alpha: 0.2)
        textField.textColor = .black
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.attributedPlaceholder = NSAttributedString(
            string: "enter code",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        return textField
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = UIColor.systemCyan
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    private var viewModel: RegisterApproveViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureViewModel()
    }
    
    init(userId: Int) {
        self.viewModel = RegisterApproveViewModel(userId: userId)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        view.backgroundColor = UIColor.white
        
        view.addSubview(codeField)
        view.addSubview(submitButton)
        
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            codeField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 280),
            codeField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            codeField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            submitButton.topAnchor.constraint(equalTo: codeField.bottomAnchor, constant: 30),
            submitButton.leadingAnchor.constraint(equalTo: codeField.leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: codeField.trailingAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
