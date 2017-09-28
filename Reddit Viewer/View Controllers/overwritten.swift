//
//  SubredditImageViewController.swift
//  Reddit Viewer
//
//  Created by Duncan MacDonald on 9/18/17.
//

import Foundation
import UIKit
import Lightbox

class overwritten: UIViewController {
    var subreddit: String!
    var allImages: [LightboxImage] = []
    var surroundingImages: [(Int, LightboxImage)]! {
        didSet {
            surroundingImages = surroundingImages.sorted { $0.0 < $1.0 }
        }
    }
    var subService: SubredditService!
    var controller: LightboxController!
    var previousPage: Int!
    
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
        print("getting more posts")
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
    
    func getSurroundingImages(indexPath: IndexPath, completion: @escaping ([LightboxImage], Int) -> Void) {
        let bounds = 3
        var lowerBound = indexPath.row - bounds
        var higherBound = indexPath.row + bounds
        
        if indexPath.row - bounds < 0 {
            lowerBound = 0
        }
        
        if indexPath.row + bounds > self.allImages.count {
            higherBound = self.allImages.count
        }
        
        let surImgsSlice = ArraySlice<LightboxImage>(allImages[lowerBound...higherBound])
        let surImgsArray = Array(surImgsSlice)
        
        for i in 0...surImgsSlice.count - 1 {
            let lbImg: LightboxImage = surImgsArray[i]
            let tuple: (Int, LightboxImage) = (lowerBound + i, lbImg)
            if let _ = self.surroundingImages {
                if self.surroundingImages.contains( where: { $0.0 == tuple.0 } ) {
                    print("exists")
                    continue
                } else {
                    self.surroundingImages.append(tuple)
                }
            } else {
                self.surroundingImages = [tuple]
            }
        }
        
        var indx: Int = 0
        for i in self.surroundingImages {
            print("indexpath: \(indexPath.row) and i: \(i.0)")
            if i.0 == indexPath.row {
                break
            } else {
                indx += 1
            }
        }
        
        let imgArr = surroundingImages.map { $0.1 }
        completion(imgArr, indx)
//        print(indx)
//
//        let controller = LightboxController(images: imgArr, startIndex: indx)
//        controller.dynamicBackground = true
//
//        controller.pageDelegate = self
//
//        completion(controller)
    }
}

extension overwritten: LightboxControllerPageDelegate {
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        print(page)
        if page >= posts.count - 5 {
            self.getMorePosts()
        }
        
        self.getSurroundingImages(indexPath: IndexPath(item: page, section: 0)) { (imgArr, index) in
            self.controller.images = imgArr
//            self.controller.goTo(index)
//            self.controller.configureLayout()
            print("maybe worked")
        }
        
        self.collectionView.scrollToItem(at: IndexPath(item: page, section: 0), at: UICollectionViewScrollPosition.centeredVertically, animated: false)
    }
}

extension overwritten: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.getSurroundingImages(indexPath: indexPath) { (imgArr, index) in
            self.controller = LightboxController(images: imgArr, startIndex: index)
            self.controller.pageDelegate = self
            self.controller.dynamicBackground = true
            self.present(self.controller, animated: true, completion: nil)
        }
    }
}

extension overwritten: UICollectionViewDataSource {
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

extension overwritten: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 20) / 3
        let height = width
        
        return CGSize(width: width, height: height)
    }
}
