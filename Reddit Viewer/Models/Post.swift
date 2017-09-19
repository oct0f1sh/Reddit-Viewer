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

extension Post: Decodable {
    enum Keys: String, CodingKey {
        case children
        case data
    }
    
    enum AttributeKeys: String, CodingKey {
        case title
        case selftext       /* description */
        case permalink      /* post URL */
        case author
        case thumbnail
        case preview
    }
    
    enum ImagesKeys: String, CodingKey {
        case images
    }
    
    enum ImageKeys: String, CodingKey {
        case source
    }
    
    enum ImageSizes: String, CodingKey {
        case source
    }
    
    enum SourceImageKeys: String, CodingKey {
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let dataContainer = try container.nestedContainer(keyedBy: AttributeKeys.self, forKey: .data)
        let imagesContainer = try dataContainer.nestedContainer(keyedBy: ImagesKeys.self, forKey: .preview)
        var imageContainer = try imagesContainer.nestedUnkeyedContainer(forKey: .images)
        let imageSizesContainer = try imageContainer.nestedContainer(keyedBy: ImageSizes.self)
        let sourceContainer = try imageSizesContainer.nestedContainer(keyedBy: SourceImageKeys.self, forKey: .source)
        
        let title = try dataContainer.decode(String.self, forKey: .title)
        let description = try dataContainer.decode(String.self, forKey: .selftext)
        let author = try dataContainer.decode(String.self, forKey: .author)
        let thumbURL = try dataContainer.decode(URL.self, forKey: .thumbnail)
        let postURL = try dataContainer.decode(String.self, forKey: .permalink)
        let imageURL = try sourceContainer.decode(URL.self, forKey: .url)
        
        self.init(imageURL: imageURL, thumbURL: thumbURL, postURL: postURL, title: title, description: description, author: author)
    }
}

struct PostResults: Decodable {
    struct PostData: Decodable {
        let children: [Post]
    }
    
    let data: PostData
}
