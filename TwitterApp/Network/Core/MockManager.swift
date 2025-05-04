//
//  MockManager.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 04.05.25.
//

import Foundation

enum MockError: Error {
    case fileNotFound
    case invalidData
}

class MockManager {
    func loadFile<T: Codable>(filename: String, type: T.Type, completion: ((T?, String?) -> Void)) {
        guard let file = Bundle.main.url(forResource: filename, withExtension: "json" ) else {
            completion(nil, MockError.fileNotFound.localizedDescription)
            return
        }
        
        guard let data = try? Data(contentsOf: file) else {
            completion(nil, MockError.invalidData.localizedDescription)
            return
        }
        
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            completion(model, nil)
        }
        catch {
            completion(nil, error.localizedDescription)
        }
    }
}
