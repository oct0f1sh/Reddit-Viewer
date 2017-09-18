//
//  ImageService.swift
//  Reddit Viewer
//
//  Created by Duncan MacDonald on 9/16/17.
//

import Foundation

class ImageService {
    static func getPostsFromSubreddit(subreddit: String, completion: @escaping ([Post]) -> Void) {
        let url = URL(string: "https://reddit.com/r/\(subreddit)/.json")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return }
            
            if let data = data {
                let postList = try? JSONDecoder().decode(PostResults.self, from: data)
                guard let posts = postList?.data.children else { return }
                completion(posts)
            }
        }
        task.resume()
    }
}
