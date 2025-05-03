//
//  EditProfileController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 10.04.25.
//

import UIKit

class EditProfileController: UIViewController {
    //MARK: - UI Elements
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(EditProfileCell.self, forCellReuseIdentifier: "\(EditProfileCell.self)")
        tv.backgroundColor = .systemBackground
        tv.dataSource = self
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    //MARK: - Properties
    private var headerView = EditProfileHeader()
    private var viewModel = EditProfileViewModel()
    private var currentProfileHeaderTarget: EditProfileHeaderTarget?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurenavigationBar()
        configureTableView()
        configureConstraints()
        configureViewModel()
    }
    
    //MARK: - Selectors
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc func handleSave() {
        Task { @MainActor in
            await viewModel.updateProfile()
        }
    }
    
    //MARK: - Helpers
    
    fileprivate func configureViewModel() {
        viewModel.fileUploadSuccess = { responseData in
            print("file upload success")
            if self.currentProfileHeaderTarget == .profile {
                print("profile upload success")
                self.viewModel.profilePhoto = [
                    "file_uuid": responseData.data?.file?.id ?? "",
                    "file_path": responseData.data?.file?.path ?? ""
                ]
            }
            else {
                self.viewModel.bannerPhoto = [
                    "file_uuid": responseData.data?.file?.id ?? "",
                    "file_path": responseData.data?.file?.path ?? ""
                ]
            }
        }
        
        viewModel.updateSuccess = {
            NotificationCenter.default.post(name: NSNotification.Name("profileUpdated"), object: nil)
            self.tableView.reloadData()
        }
        
        viewModel.errorHandling = { error in
            self.present(Alert.showAlert(title: "Error", message: error), animated: true)
        }
    }
    
    fileprivate func configureHeaderView() {
        headerView.changeImageHandler = { image, editProfileHeaderTarget  in
            print("changed photo")
            self.currentProfileHeaderTarget = editProfileHeaderTarget
            self.viewModel.uploadImage(image: image)
        }
    }
    
    fileprivate func configurenavigationBar() {
        let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.tintColor = .systemBlue // Cancel/Save rəngi
            
            navigationItem.title = "Edit Profile"
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
//            navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    fileprivate func configureTableView() {
        tableView.tableHeaderView = headerView
        
        configureHeaderView()
                
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func configureConstraints() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//extension EditProfileController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        EditProfileOption.allCases.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "\(EditProfileCell.self)") as! EditProfileCell
//        
//        guard let option = EditProfileOption(rawValue: indexPath.row) else { return cell }
//        
//        cell.configure(editProfileOption: option)
//                
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let option = EditProfileOption(rawValue: indexPath.row) else { return 0 }
//        
//        return option == .bio ? 100 : 48
//    }
//}

extension EditProfileController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(EditProfileCell.self)", for: indexPath) as! EditProfileCell
        
        let model = viewModel.items[indexPath.row]
        cell.configure(model: model)
        
        // live update ViewModel
        cell.onValueChanged = { [weak self] newValue in
            self?.viewModel.updateItem(at: indexPath.row, with: newValue)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = viewModel.items[indexPath.row]
        return model.type == .bio ? 100 : 48
    }
}
