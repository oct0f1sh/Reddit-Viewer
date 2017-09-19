//
//  ImageService.swift
//  Reddit Viewer
//
//  Created by Duncan MacDonald on 9/16/17.
//

import Foundation
import UIKit

class ImageService {
    static func getPostsFromSubreddit(subreddit: String, completion: @escaping ([Post]) -> Void) {
        let url = URL(string: "https://reddit.com/r/\(subreddit)/.json")!
        
        let dg = DispatchGroup()
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        var posts = [Post]()
        
        dg.enter()
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return }
            
            if let data = data {
                let postList = try? JSONDecoder().decode(PostResults.self, from: data)
                guard let newPosts = postList?.data.children else { return }
                posts = newPosts
                dg.leave()
            } else {
                dg.leave()
            }
        }
        task.resume()
        
        for i in posts {
            if i.imageURL == URL(string: "") {
                print("%%%%%%%%%%%%%%%%%%%%%")
            }
        }
        
        dg.notify(queue: .main, execute: {
            completion(posts)
        })
    }
    
    static func loadImage(imageURL: URL!, completion: @escaping (UIImage?) -> Void) {
        let session = URLSession.shared
        
        let dg = DispatchGroup()
        
        var img: UIImage?
        
        dg.enter()
        let task = session.dataTask(with: imageURL) { (data, response, error) in
            guard error == nil else { return }
            
            if let data = data {
                if let image = UIImage(data: data) {
                    dg.leave()
                    img = image
                } else {
                    dg.leave()
                    print("image error")
                }
            }
        }
        task.resume()
        
        dg.notify(queue: .main) {
            completion(img)
        }
    }
}
