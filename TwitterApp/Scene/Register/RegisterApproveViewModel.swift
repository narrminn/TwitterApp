//
//  RegisterApproveViewModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import Foundation

class RegisterApproveViewModel {
    var userId: Int
    
    var manager = RegisterManager()
    
    var registerApproveSuccess: (() -> Void)?
    var errorHandling: ((String) -> Void)?
    
    init(userId: Int) {
        self.userId = userId
    }
    
    func registerApprove(code: String) {
        manager.registerApprove(code: code, userId: userId) { response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.registerApproveSuccess?()
            }
        }
    }
}
