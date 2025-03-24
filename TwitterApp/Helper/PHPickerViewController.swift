//
//  PHPickerViewController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 22.03.25.
//

import UIKit
import PhotosUI

extension CreateTweetController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        selectedImages.removeAll()
        self.viewModel.tweetFiles = []
        
        let group = DispatchGroup()
        
        for result in results {
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                defer { group.leave() }
                if let image = reading as? UIImage {
                    self.selectedImages.append(image)
                    
                    //api request
                    self.viewModel.uploadImage(image: image)
                }
            }
        }
        
        group.notify(queue: .main) {
            self.imagesCollectionView.reloadData()
        }
    }
}
