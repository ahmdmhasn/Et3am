//
//  ImageStore.swift
//  Homepwner
//
//  Created by Ahmed M. Hassan on 5/2/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

/*
 This class is used whenever we load/ get photos from internet
 */
import UIKit

class ImageStore {
    
    let cache = NSCache<NSString, UIImage>()
    
    // Save an image to cache object & internal storage
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        // Create full URL for image
        let url = imageURL(forKey: key)
        
        // Turn image into JPEG data
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            try? data.write(to: url, options: [.atomic])
        }
    }
    
    // Load an image from cache object & internal storage using image key
    func image(forKey key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
    
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    // Delete an image from cache object & internal storage using image key
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error removing the image from disk: \(error)")
        }
    }
    
    // Creating full image url using image key
    private func imageURL(forKey key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent(key)
    }
    
}
