//
//  UIImage.swift
//  listProductTest
//
//  Created by Кирилл Харьковский on 23.08.2021.
//

import Foundation
import UIKit
import Alamofire
import SDWebImage

private let imageToCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func download(from url: URL) {
        self.image = nil
        if let cachedImage = imageToCache.object(forKey: NSString(string: url.absoluteString)) {
            self.image = cachedImage
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                imageToCache.setObject(image, forKey: NSString(string: url.absoluteString))
            }
        }.resume()
    }
    
    func downloadWithSD(from url: URL?) {
        
        guard let url = url else {
            print("Not a valid URL!")
            return
        }
        
        if let cachedImage = imageToCache.object(forKey: NSString(string: url.absoluteString)) {
            self.image = cachedImage
            return
        }
        
        sd_setImage(with: url, placeholderImage: UIImage(named: "HugePlaceHolder"), options: []) { (imageSD, error, _, _) in
            if error != nil {
                print("Error: ", error!.localizedDescription)
                return
            }
            imageToCache.setObject(imageSD!, forKey: NSString(string: url.absoluteString))
        }
    }
    
    // Method with Completion after the download is done
    func downloadWithSDWithCompletion(from url: URL?, completion: @escaping () -> Void) {
        
        guard let url = url else {
            print("Not a valid URL!")
            return
        }
        
        if let cachedImage = imageToCache.object(forKey: NSString(string: url.absoluteString)) {
            self.image = cachedImage
            completion()

            return
        }
        
        sd_setImage(with: url, placeholderImage: UIImage(named: "HugePlaceHolder"), options: []) { (imageSD, error, _, _) in
            if error != nil {
                print("Error: ", error!.localizedDescription)
                                
                return
            }
            imageToCache.setObject(imageSD!, forKey: NSString(string: url.absoluteString))
            completion()
        }
    }
}

extension UIImage {
    func withAlpha(_ a: CGFloat) -> UIImage {
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { (_) in
            draw(in: CGRect(origin: .zero, size: size), blendMode: .normal, alpha: a)
        }
    }
}
