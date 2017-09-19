//
//  SubredditImageViewController.swift
//  Reddit Viewer
//
//  Created by Duncan MacDonald on 9/18/17.
//

import Foundation
import UIKit

class SubredditImageViewController: UIViewController {
    var subreddit: String!
    var posts: [Post] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        ImageService.getPostsFromSubreddit(subreddit: subreddit) { (gatheredPosts) in
            self.posts = gatheredPosts
            self.collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
}

extension SubredditImageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
}

extension SubredditImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ThumbnailCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath) as! ThumbnailCell
        let post = posts[indexPath.row]
        cell.post = post
        
        post.images.downloadThumbnail() { () in
            cell.thumbnailImageView.image = post.images.thumbnail
        }
        
        return cell
    }
    
    
}

extension SubredditImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 10 * 4) / 3
        let height = width
        
        return CGSize(width: width, height: height)
    }
}
