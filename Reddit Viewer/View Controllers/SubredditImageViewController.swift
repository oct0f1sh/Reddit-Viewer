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
    var allImages: [LightboxImage] = []
    var surroundingImages: [LightboxImage?]
    var subService: SubredditService!
    
    var posts: [Post] = [] {
        didSet {
            allImages = posts.map {
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
        //populate array of previous and next 5 values in images
        print("initial index: \(indexPath)")
        for i in 0...allImages.count {
            if i > indexPath.row - 6 && i <= indexPath.row {
                guard let _ = self.surroundingImages else { self.surroundingImages = [self.allImages[i]]; continue }
                let containsElement = self.surroundingImages.contains { $0.image == self.allImages[i].image }
                if containsElement {
                    print("image exists")
                    continue
                } else {
                    print("bound: \(i)")
                    self.surroundingImages.append(self.allImages[i])
                }
            } else if i > indexPath.row && i < indexPath.row + 6 {
                print("bound: \(i)")
                self.surroundingImages.append(self.allImages[0])
            }
        }
        
        let indx = self.surroundingImages.count / 2
        print(indx)
        
        let controller = LightboxController(images: surroundingImages, startIndex: indx)
        controller.dynamicBackground = true
        
        controller.pageDelegate = self
        
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
