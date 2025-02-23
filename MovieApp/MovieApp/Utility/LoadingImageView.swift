//
//  LoadingImageView.swift
//  MovieApp
//
//  Created by Shakti Singh on 21/02/25.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class LoadingImageView: UIImageView {
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    var imgUrlstring:String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupActivityIndicator()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupActivityIndicator()
        
    }

    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func loadImage(from url: String) {
        guard URL(string: url) != nil else { return }
        imgUrlstring = url
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        activityIndicator.startAnimating()
        self.image = UIImage(named: "Placeholder")
        ServiceHandler.shared.fetchPosterImage(from: url) { image in
            if self.imgUrlstring == url{
                self.activityIndicator.stopAnimating()
                if let image{
                    self.image = image
                    imageCache.setObject(image, forKey: url as AnyObject)
                }
            }
            
        }
        
    }
}
