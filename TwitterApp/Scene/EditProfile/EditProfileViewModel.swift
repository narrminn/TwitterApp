//
//  EditProfileViewModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 11.04.25.
//

import Foundation
import UIKit

class EditProfileViewModel {
    var fileManager = FileNetworkManager()
    var manager = ProfileManager()
    
    var fileUploadSuccess: ((FileUploadModel) -> Void)?
    var updateSuccess: (() -> Void)?
    var errorHandling: ((String) -> Void)?
    
    var profilePhoto: [String : String]?
    var bannerPhoto: [String : String]?
    
    var name: String {
        items.first(where: { $0.type == .fullName })?.value ?? ""
    }
        
    var username: String {
        items.first(where: { $0.type == .username })?.value ?? ""
    }
    
    var bio: String {
        items.first(where: { $0.type == .bio })?.value ?? ""
    }
    
    var link: String {
        items.first(where: { $0.type == .website })?.value ?? ""
    }
    
    // MARK: - Data
    var items: [EditProfileModel] = []
        
    // MARK: - Init
    init() {
        loadFromKeychain()
    }
    
    // MARK: - Yaddaşdan yükləmə
    func loadFromKeychain() {
        items = EditProfileOption.allCases.map {
            var model = EditProfileModel(type: $0, value: "")
            model.value = KeychainManager.shared.retrieve(key: model.keychainKey) ?? ""
            return model
        }
    }
    
    // MARK: - Item yenilə (cell dəyərləri dəyişəndə)
    func updateItem(at index: Int, with value: String) {
        guard items.indices.contains(index) else { return }
        items[index].value = value
    }
    
    func uploadImage(image: UIImage) {
        fileManager.fileUpload(file: image) { response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.fileUploadSuccess?(response)
            }
        }
    }
    
    func updateProfile() async {
        do {
            _ = try await manager.updateProfile(name: name, username: username, bio: bio, link: link, profilePhoto: profilePhoto, profileBanner: bannerPhoto)
            
            // Yaddaşa yaz
            saveDataToKeychain()
                        
            Task { @MainActor in
                loadFromKeychain()
                updateSuccess?()
            }
        } catch {
            Task { @MainActor in
                errorHandling?(error.localizedDescription)
            }
        }
    }
    
    private func saveDataToKeychain() {
        // Bütün sahələri Keychain-ə saxladığınızdan əmin olun
            _ = KeychainManager.shared.save(key: "name", value: name)
            _ = KeychainManager.shared.save(key: "username", value: username)
            _ = KeychainManager.shared.save(key: "bio", value: bio)
            _ = KeychainManager.shared.save(key: "link", value: link)
        
        
        savePhotosToKeychain()
    }
    
    private func savePhotosToKeychain() {
        if let profilePhoto = self.profilePhoto {
            _ = KeychainManager.shared.save(key: "profilePhotoPath", value: profilePhoto["file_path"] ?? "")
        }
        
        if let bannerPhoto = self.bannerPhoto {
            _ = KeychainManager.shared.save(key: "bannerPhotoPath", value: bannerPhoto["file_path"] ?? "")
        }
    }
}
