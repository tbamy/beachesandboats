//
//  ImageValidator.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/09/2025.
//


import UIKit

public struct ValidatedImage {
    let image: UIImage
    let data: Data
}

//class ImageValidator {
//    static let maxSizeBytes = 2_000_000 // 2MB
//
//    struct ValidatedImage {
//        let image: UIImage
//        let data: Data
//    }
//
//    static func validateImages(
//        _ images: [UIImage],
//        allowCompression: Bool = true
//    ) -> (validImages: [ValidatedImage], hasInvalidImages: Bool) {
//        var validImages: [ValidatedImage] = []
//        var hasInvalidImages = false
//
//        for image in images {
//            var quality: CGFloat = 1.0
//            var imageData = image.jpegData(compressionQuality: quality)
//
//            // Iterative compression loop
//            if let data = imageData, data.count > maxSizeBytes, allowCompression {
//                while let d = image.jpegData(compressionQuality: quality), d.count > maxSizeBytes, quality > 0.1 {
//                    quality -= 0.1
//                    imageData = d
//                }
//            }
//
//            if let data = imageData, data.count <= maxSizeBytes {
//                if let finalImage = UIImage(data: data) {
//                    validImages.append(ValidatedImage(image: finalImage, data: data))
//                }
//            } else {
//                hasInvalidImages = true
//            }
//        }
//
//        return (validImages, hasInvalidImages)
//    }
//}

class ImageValidator {
    static let maxSizeBytes = 2_000_000 // 2 MB
    
    static func validateImages(
        _ images: [UIImage],
        allowCompression: Bool = true
    ) -> ([ValidatedImage], Bool) {
        var validated: [ValidatedImage] = []
        var hasInvalid = false
        
        for image in images {
            // Start with full quality
            if let data = image.jpegData(compressionQuality: 1.0),
               data.count <= maxSizeBytes {
                validated.append(ValidatedImage(image: image, data: data))
                continue
            }
            
            if allowCompression {
                // Try progressively smaller qualities
                var compressedData: Data?
                var quality: CGFloat = 0.9
                while quality > 0.1 {
                    if let data = image.jpegData(compressionQuality: quality),
                       data.count <= maxSizeBytes {
                        compressedData = data
                        break
                    }
                    quality -= 0.1
                }
                
                if let data = compressedData,
                   let compressedImage = UIImage(data: data) {
                    validated.append(ValidatedImage(image: compressedImage, data: data))
                } else {
                    hasInvalid = true
                }
            } else {
                hasInvalid = true
            }
        }
        
        return (validated, hasInvalid)
    }
}
