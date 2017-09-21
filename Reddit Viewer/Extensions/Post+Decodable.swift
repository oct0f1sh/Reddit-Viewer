//
//  Post+Decodable.swift
//  Reddit Viewer
//
//  Created by Duncan MacDonald on 9/21/17.
//

import Foundation

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
        //Change this to true to print container data for debugging purposes
        let dh = DebugHelper(shouldPrint: true)
        
        
        let container = try decoder.container(keyedBy: Keys.self)
        dh.printContainer(container: container, forContainer: .root)
        
        
        let dataContainer = try container.nestedContainer(keyedBy: AttributeKeys.self, forKey: .data)
        dh.printContainer(container: dataContainer, forContainer: .data)
        
        
        let imagesContainer = try dataContainer.nestedContainer(keyedBy: ImagesKeys.self, forKey: .preview)
        dh.printContainer(container: imagesContainer, forContainer: .images)
        
        var imageContainer = try imagesContainer.nestedUnkeyedContainer(forKey: .images)
        dh.printContainer(container: imageContainer, forContainer: .image)
        
        let imageSizesContainer = try imageContainer.nestedContainer(keyedBy: ImageSizes.self)
        dh.printContainer(container: imageSizesContainer, forContainer: .imageSizes)
        
        let sourceContainer = try imageSizesContainer.nestedContainer(keyedBy: SourceImageKeys.self, forKey: .source)
        dh.printContainer(container: sourceContainer, forContainer: .source)
        
        let title = try dataContainer.decode(String.self, forKey: .title)
        dh.printAttribute(attribute: title, forAttr: .title)
        let description = try dataContainer.decode(String.self, forKey: .selftext)
        dh.printAttribute(attribute: description, forAttr: .description)
        let author = try dataContainer.decode(String.self, forKey: .author)
        dh.printAttribute(attribute: author, forAttr: .author)
        let thumbURL = try dataContainer.decode(URL.self, forKey: .thumbnail)
        dh.printAttribute(attribute: thumbURL, forAttr: .thumbURL)
        let postURL = try dataContainer.decode(String.self, forKey: .permalink)
        dh.printAttribute(attribute: postURL, forAttr: .postURL)
        let imageURL = try sourceContainer.decode(URL.self, forKey: .url)
        dh.printAttribute(attribute: imageURL, forAttr: .imageURL)
        
        self.init(imageURL: imageURL, thumbURL: thumbURL, postURL: postURL, title: title, description: description, author: author)
    }
}

struct PostResults: Decodable {
    struct PostData: Decodable {
        let children: [Post]
    }
    
    let data: PostData
}
