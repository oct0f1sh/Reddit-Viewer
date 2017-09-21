//
//  DebugHelper.swift
//  Reddit Viewer
//
//  Created by Duncan MacDonald on 9/21/17.
//

import Foundation
import UIKit

struct DebugHelper {
    var debugPrint: Bool
    
    init(shouldPrint: Bool) {
        self.debugPrint = shouldPrint
        if debugPrint {
            print("init started")
        }
    }
    
    enum Containers {
        case root
        case data
        case images
        case image
        case imageSizes
        case source
    }
    
    enum Attributes {
        case title
        case description
        case author
        case thumbURL
        case imageURL
        case postURL
    }
    
    func printContainer(container: Any, forContainer: Containers) {
        if debugPrint {
            switch forContainer{
            case .root:
                print("root: \(container)")
            case .data:
                print("data: \(container)")
            case .images:
                print("images: \(container)")
            case .image:
                print("image: \(container)")
            case .imageSizes:
                print("imageSizes: \(container)")
            case .source:
                print("source: \(container)")
            }
        }
    }
    
    func printAttribute(attribute: Any, forAttr: Attributes) {
        if debugPrint {
            switch forAttr {
            case .title:
                print("title: \(attribute)")
            case .description:
                print("description: \(attribute)")
            case .author:
                print("author: \(attribute)")
            case .thumbURL:
                print("thumbURL: \(attribute)")
            case .imageURL:
                print("imageURL: \(attribute)")
            case .postURL:
                print("postURL: \(attribute)")
            }
        }
    }
}
