//
//  FeedViewModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 27.03.25.
//

import Foundation

class ProfileViewModel {
    var manager = ProfileManager()
    
    var profile: MyProfileModelUser?
    
    var profileGetSuccess: (() -> Void)?
    var errorHandling: ((String) -> Void)?
    
    init() {
        getMyProfile()
    }
    
    func getMyProfile() -> Void {
        manager.myProfile { response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.profile = response.data?.user
                self.profileGetSuccess?()
            }
        }
    }
}
