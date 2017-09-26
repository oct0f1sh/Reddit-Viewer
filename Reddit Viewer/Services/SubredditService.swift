//
//  SubredditService.swift
//  Reddit Viewer
//
//  Created by Duncan MacDonald on 9/25/17.
//

import Foundation
import UIKit

class SubredditService {
    var posts: [Post] = []
    var after: String = "null"
    let subreddit: String
    
    func getSomePosts(completion: @escaping () -> Void) {
        let url = URL(string: "https://reddit.com/r/\(subreddit)/.json?after=\(after)")!
        
        print(url)
        
        let dg = DispatchGroup()
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        dg.enter()
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return }
            
            if let data = data {
                let postList = try? JSONDecoder().decode(PostResults.self, from: data)
                guard let newPosts = postList?.data.children else { return }
                self.after = (postList?.data.after)!
                self.posts.append(contentsOf: newPosts)
                dg.leave()
            } else {
                dg.leave()
            }
        }
        task.resume()
        
        dg.notify(queue: .main) {
            self.posts = PostHelper.cleanPosts(posts: self.posts)
            completion()
        }
    }
    
    init(subreddit: String) {
        self.subreddit = subreddit
    }
}
