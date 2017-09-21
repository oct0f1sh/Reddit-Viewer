//
//  Post.swift
//  Reddit Viewer
//
//  Created by Duncan MacDonald on 9/18/17.
//

import Foundation
import UIKit

struct Post {
    let imageURL: URL
    let thumbURL: URL
    let title: String
    let description: String
    let author: String
    let postURL: String
    let images: Images
    
    init(imageURL: URL, thumbURL: URL, postURL: String, title: String, description: String, author: String) {
        self.imageURL = imageURL
        self.thumbURL = thumbURL
        self.title = title
        self.description = description
        self.author = author
        self.postURL = postURL
        self.images = Images(fullImageURL: imageURL, thumbnailURL: thumbURL)
    }
}
