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
    var subService: SubredditService!
    
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
        self.subService = SubredditService(subreddit: subreddit)
        
        self.getMorePosts()
    }
    
    func getMorePosts() {
        subService.getSomePosts {
            self.posts = self.subService.posts
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

extension SubredditImageViewController: LightboxControllerPageDelegate {
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        print(page)
    }
}

extension SubredditImageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = LightboxController(images: images, startIndex: indexPath.row)
        controller.dynamicBackground = true
        
        controller.pageDelegate = self
        
        print(posts[indexPath.row].description)
        
        present(controller, animated: true, completion: nil)
    }
}

extension SubredditImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ThumbnailCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath) as! ThumbnailCell
        let post = posts[indexPath.row]
        cell.post = post
        
        if let img = post.images.thumbnail {
            cell.thumbnailImageView.image = img
        } else {
            cell.downloadImage(completion: {
                self.collectionView.reloadItems(at: [indexPath])
            })
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= posts.count - 1 {
            self.getMorePosts()
        }
    }
}

extension SubredditImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 20) / 3
        let height = width
        
        return CGSize(width: width, height: height)
    }
}
