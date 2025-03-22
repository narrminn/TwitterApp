//
//  ConversationController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 17.03.25.
//

import UIKit

class ConversationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Messages"
    }
}
