//
//  RegisterViewModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import Foundation

class RegisterViewModel {
    var manager = RegisterManager()
    
    var registerSuccess: ((Int) -> Void)?
    var errorHandling: ((String) -> Void)?
    
    var registeredUserId: Int?
    
    func register(username: String, name: String, email: String, password: String) {
        manager.register(username: username, name: name, email: email, password: password) { response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.registeredUserId = response.data?.userID
                self.registerSuccess?(self.registeredUserId ?? 0)
            }
        }
    }
}
