//
//  UIImagePickerController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 22.03.25.
//

import UIKit
import PhotosUI

//extension CreateTweetController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    @objc func handleImagePicker() {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = .photoLibrary
//        present(picker, animated: true)
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[.originalImage] as? UIImage {
//            selectedImageView.image = image
//        }
//        picker.dismiss(animated: true)
//    }
//}

//extension CreateTweetController: PHPickerViewControllerDelegate {
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true)
//        
//        selectedImages.removeAll()
//        let group = DispatchGroup()
//        
//        for result in results {
//            group.enter()
//            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
//                defer { group.leave() }
//                if let image = reading as? UIImage {
//                    self.selectedImages.append(image)
//                }
//            }
//        }
//        
//        group.notify(queue: .main) {
//            self.imagesCollectionView.reloadData()
//        }
//    }
//}
