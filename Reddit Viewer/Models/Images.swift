//
//  Images.swift
//  Reddit Viewer
//
//  Created by Duncan MacDonald on 9/18/17.
//

import Foundation
import UIKit

class Images {
    var fullImage: UIImage?
    var thumbnail: UIImage?
    let fullImageURL: URL?
    let thumbnailURL: URL?
    
    init(fullImageURL: URL, thumbnailURL: URL) {
        self.fullImageURL = fullImageURL
        self.thumbnailURL = thumbnailURL
    }
    
    func downloadFullImage() {
        let dg = DispatchGroup()
        
        if let fullImageURL = self.fullImageURL {
            dg.enter()
            ImageService.loadImage(imageURL: fullImageURL, completion: { (img) in
                self.fullImage = img
                dg.leave()
            })
        }
    }
    
    func downloadThumbnail(completion: @escaping () -> Void) {
        let dg = DispatchGroup()
        
        if let thumbnailURL = self.thumbnailURL {
            dg.enter()
            ImageService.loadImage(imageURL: thumbnailURL, completion: { (img) in
                self.thumbnail = img
                dg.leave()
            })
        }
        dg.notify(queue: .main) {
            completion()
        }
    }
}
