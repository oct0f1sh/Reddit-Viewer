//
//  Post.swift
//  Reddit Viewer
//
//  Created by Duncan MacDonald on 9/18/17.
//

import Foundation

struct Post {
    let imageURL: URL
    let thumbURL: URL
    let title: String
    let description: String
    let author: String
    let postURL: String
    
    init(imageURL: URL, thumbURL: URL, postURL: String, title: String, description: String, author: String) {
        self.imageURL = imageURL
        self.thumbURL = thumbURL
        self.title = title
        self.description = description
        self.author = author
        self.postURL = postURL
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
        print("init started")
        
        let container = try decoder.container(keyedBy: Keys.self)
        
        print("container: \(container)")
        
        let dataContainer = try container.nestedContainer(keyedBy: AttributeKeys.self, forKey: .data)
        print("data: \(dataContainer)")
        let imagesContainer = try dataContainer.nestedContainer(keyedBy: ImagesKeys.self, forKey: .preview)
        print("images: \(imagesContainer)")
        var imageContainer = try imagesContainer.nestedUnkeyedContainer(forKey: .images)
        let imageSizesContainer = try imageContainer.nestedContainer(keyedBy: ImageSizes.self)
        print("imagesizes: \(imageSizesContainer)")
        let sourceContainer = try imageSizesContainer.nestedContainer(keyedBy: SourceImageKeys.self, forKey: .source)
        print("source: \(sourceContainer)")
        
        let title = try dataContainer.decode(String.self, forKey: .title)
        let description = try dataContainer.decode(String.self, forKey: .selftext)
        let author = try dataContainer.decode(String.self, forKey: .author)
        let thumbURL = try dataContainer.decode(URL.self, forKey: .thumbnail)
        let postURL = try dataContainer.decode(String.self, forKey: .permalink)
        let imageURL = try sourceContainer.decode(URL.self, forKey: .url)
        print(imageURL)
        
        self.init(imageURL: imageURL, thumbURL: thumbURL, postURL: postURL, title: title, description: description, author: author)
    }
}

struct PostResults: Decodable {
    struct PostData: Decodable {
        let children: [Post]
    }
    
    let data: PostData
}
