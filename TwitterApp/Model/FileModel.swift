//
//  FileModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 24.03.25.
//

import Foundation

// MARK: - FileUploadModel
struct FileUploadModel: Codable {
    let message: String?
    let data: FileUploadModelData?
}

// MARK: - FileUploadModelData
struct FileUploadModelData: Codable {
    let file: FileUploadModelFile?
}

// MARK: - FileUploadModelFile
struct FileUploadModelFile: Codable {
    let storagePath, path, fileExtension: String?
    let size: Int?
    let mimeType, id, updatedAt, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case storagePath = "storage_path"
        case path
        case fileExtension = "extension"
        case size
        case mimeType = "mime_type"
        case id
        case updatedAt = "updated_at"
        case createdAt = "created_at"
    }
}


