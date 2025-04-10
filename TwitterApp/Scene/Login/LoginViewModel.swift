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
    
    enum ViewState {
        case loading
        case loaded
        case loginSuccess(LoginModel)
        case errorHandling(String)
        case idle
    }
    
    var stateUpdated: ((ViewState) -> Void)?
    
    var state: ViewState = .idle {
        didSet {
            stateUpdated?(state)
        }
    }
    
    func login(email: String, password: String) {
        manager.login(email: email, password: password) { response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.loginSuccess?(response)
            }
        }
    }
    
    func loginAsync(email: String, password: String) async {
        do {
            let data = try await manager.login(email: email, password: password)
            Task { @MainActor in
                if let loginResponse = data {
                    state = .loginSuccess(loginResponse)
                }
            }
        } catch {
            Task { @MainActor in
                state = .errorHandling(error.localizedDescription)
            }
        }
    }
}
