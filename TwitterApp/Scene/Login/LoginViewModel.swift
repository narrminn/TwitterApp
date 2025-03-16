//
//  LoginViewModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import Foundation

class LoginViewModel {
    var manager = LoginManager()
    
    var loginSuccess: ((LoginModel) -> Void)?
    var errorHandling: ((String) -> Void)?
    
    func login(email: String, password: String) {
        manager.login(email: email, password: password) { response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.loginSuccess?(response)
            }
        }
    }
}
