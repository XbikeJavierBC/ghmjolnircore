//
//  GHCacheImage.swift
//  LNMainApp
//
//  Created by Javier Carapia on 24/08/21.
//

import UIKit

public final class GHCacheImage {
    private lazy var synQueue = DispatchQueue(label: "serializationQueue")
    private static var instance: GHCacheImage?
    
    public static var shared: GHCacheImage {
        if self.instance == nil {
            self.instance = GHCacheImage()
        }
        
        return self.instance!
    }
    
    private var dict = [String: UIImage?]()
    
    private init() { }
    
    public func releaseCache() {
        self.dict.removeAll()
    }
    
    public func setCacheAsset(
        model: GHCacheImageDelegate,
        imageView: UIImageView,
        poiner: @escaping (GHCacheImageDelegate, UIImage?) -> Bool
    ) {
        
        DispatchQueue.main.async {
            imageView.image = nil
        }
        
        self.getValue(key: model.urlImage, closure: { image in
            guard let chacheImage = image else {
                if let url = URL(string: model.urlImage) {
                    let task = URLSession(configuration: .default).dataTask(
                        with: url,
                        completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                            if let _ = error {
                                DispatchQueue.main.async { [weak self] in
                                    guard let self = self else { return }
                                    
                                    self.setValue(key: model.urlImage, image: UIImage())
                                    if poiner(model, nil) {
                                        imageView.image = UIImage()
                                    }
                                }
                                
                                return
                            }
                            
                            if let dt = data {
                                if let imageResponse = UIImage(data: dt) {
                                    DispatchQueue.main.async { [weak self] in
                                        guard let self = self else { return }
                                        
                                        self.setValue(key: model.urlImage, image: imageResponse)
                                        if poiner(model, imageResponse) {
                                            imageView.image = imageResponse
                                        }
                                    }
                                    return
                                }
                            }
                        }
                    )
                        
                    task.resume()
                }
                else {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
                        self.setValue(key: model.urlImage, image: UIImage())
                        imageView.image = UIImage()
                    }
                }
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let _ = self else { return }
                
                if poiner(model, chacheImage) {
                    imageView.image = chacheImage
                }
            }
        })
    }
    
    public func setSimpleCacheAsset(
        urlStr: String,
        closurePointer: @escaping (UIImage?) -> ()
    ) {
        self.getValue(key: urlStr, closure: { image in
            guard let chacheImage = image else {
                if let url = URL(string: urlStr) {
                    let task = URLSession(configuration: .default).dataTask(
                        with: url,
                        completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                            if let _ = error {
                                DispatchQueue.main.async { [weak self] in
                                    guard let self = self else { return }
                                    
                                    self.setValue(key: urlStr, image: UIImage())
                                    closurePointer(nil)
                                }
                                
                                return
                            }
                            
                            if let dt = data {
                                if let imageResponse = UIImage(data: dt) {
                                    DispatchQueue.main.async { [weak self] in
                                        guard let self = self else { return }
                                        
                                        self.setValue(key: urlStr, image: imageResponse)
                                        closurePointer(imageResponse)
                                    }
                                    return
                                }
                            }
                        }
                    )
                        
                    task.resume()
                }
                else {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
                        self.setValue(key: urlStr, image: UIImage())
                    }
                }
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let _ = self else { return }
                
                closurePointer(chacheImage)
            }
        })
    }
    
    private func setValue(key: String, image: UIImage) {
        self.synQueue.sync { [weak self] in
            guard let self = self else { return }
            
            self.dict.updateValue(image, forKey: key)
        }
    }
    
    private func getValue(key: String, closure: (UIImage?) -> ()) {
        self.synQueue.sync {
            if let image = self.dict[key] {
                closure(image)
            }
            else {
                closure(nil)
            }
        }
    }
}
