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
    
    func uploadImage(image: UIImage) {
        fileManager.fileUpload(file: image) { response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.fileUploadSuccess?(response)
            }
        }
    }
    
    func updateProfile(name: String, username: String, bio: String, link: String) async {
        do {
            _ = try await manager.updateProfile(name: name, username: username, bio: bio, link: link, profilePhoto: profilePhoto, profileBanner: bannerPhoto)
            
            Task { @MainActor in
                updateSuccess?()
            }
        } catch {
            Task { @MainActor in
                errorHandling?(error.localizedDescription)
            }
        }
    }
}
