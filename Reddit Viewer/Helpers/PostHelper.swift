//
//  PostHelper.swift
//  Reddit Viewer
//
//  Created by Duncan MacDonald on 9/21/17.
//

import Foundation
import UIKit

class PostHelper {
    static func cleanPosts(posts: [Post]) -> [Post] {
        var cleanedPosts = [Post]()
        for i in posts {
            if i.title != "notitle" {
                cleanedPosts.append(i)
            }
        }
        return cleanedPosts
    }
}
