//
//  SubredditImageViewController.swift
//  Reddit Viewer
//
//  Created by Duncan MacDonald on 9/18/17.
//

import Foundation
import UIKit
import Lightbox

class SubredditImageViewController: UIViewController {
    var subreddit: String!
    var images: [LightboxImage] = []
    
    var posts: [Post] = [] {
        didSet {
            images = posts.map {
                LightboxImage(imageURL: $0.imageURL, text: $0.title)
            }
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        self.navigationBar.title = subreddit
//        ImageService.getMultiplePagesFromSubreddit(subreddit: subreddit) { (gatheredPosts) in
//            self.posts = gatheredPosts
//            self.collectionView.reloadData()
//        }
        let subService = SubredditService(subreddit: subreddit)
        subService.getSomePosts {
            self.posts = subService.posts
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func reloadCV(_ sender: Any) {
        self.collectionView.reloadData()
    }
    
    @IBAction func unwindToSubView(segue: UIStoryboardSegue) {
        
    }
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toImageView" {
            let cell = sender as! UICollectionViewCell
            let indexPath = self.collectionView!.indexPath(for: cell)
            let post = self.posts[(indexPath?.row)!]
            let destVC = segue.destination as! SlideshowContentViewController
            destVC.post = post
        }
    }
}

extension SubredditImageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = LightboxController(images: images, startIndex: indexPath.row)
        controller.dynamicBackground = true
        
        present(controller, animated: true, completion: nil)
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
        let width = (self.view.frame.size.width - 20) / 3
        let height = width
        
        return CGSize(width: width, height: height)
    }
}
