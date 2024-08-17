//
//  ImageDownloader.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/17/24.
//

/*
 fetch from local or download images if not saved
 */

import UIKit

class ImageDownloader {
    static let shared = ImageDownloader()
    
    private let cache = NSCache<NSString, NSData>()
    private let fileManager = LocalFileManager.shared
    private let session = URLSession.shared
    
    func fetchImage(urlPath: String) async throws -> UIImage? {
        guard let imagePath = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        let cacheId = NSString(string: imagePath)
        
        // first check cache
        if let imageData = cache.object(forKey: cacheId) as Data? {
            return UIImage(data: imageData)
        } else {
            // check local
            if let imageData = fileManager.fetchData(urlPath: imagePath) {
                return UIImage(data: imageData)
            } else {
                // image not yet saved - fetch from api
                guard let url = URL(string: imagePath) else {
                    return nil
                }
                
                let result: NetworkResult = try await session.data(from: url, delegate: nil)
                let imageData = result.data
                
                if let image = UIImage(data: imageData),
                   let data = image.jpegData(compressionQuality: 1.0) {
                    self.fileManager.save(data: data, urlPath: imagePath)
                    self.cache.setObject(data as NSData, forKey: cacheId)
                    return image
                }
            }
        }
        return nil
    }
    
}
