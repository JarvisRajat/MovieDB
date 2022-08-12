//
//  ImageDownloader.swift
//  MovieDB
//
//  Created by Rajat Raj on 11/08/22.
//

import Foundation
import UIKit

class ImageDownloadManager {
    static let shared = ImageDownloadManager()
    func loadImage(imageView: UIImageView, imageUrl: String) {
        imageView.loadImage(from: imageUrl) { (image) in
            DispatchQueue.main.async {
                if let downloadedImage = image {
                    imageView.image = downloadedImage
                } else {
                    imageView.image = UIImage(named: "default_image")
                }
            }
        }
    }
}

extension UIImageView {
    func loadImage(from urlString: String?, complition: @escaping (UIImage?) -> Void) {
        let encodedUrlString = urlString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let urlString = encodedUrlString,
              let imageURL = URL(string: urlString) else {
            DispatchQueue.main.async {
                complition(nil)
            }
            return
        }
        
        let cache =  URLCache.shared
        let request = URLRequest(url: imageURL)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    complition(image)
                }
            } else {
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, _) in
                    if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        DispatchQueue.main.async {
                            complition(image)
                        }
                    } else {
                        DispatchQueue.main.async {
                            complition(nil)
                        }
                    }
                }).resume()
            }
        }
    }
}
