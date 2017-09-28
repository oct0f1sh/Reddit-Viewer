//
//  test.swift
//  Reddit Viewer
//
//  Created by Duncan MacDonald on 9/28/17.
//

import Foundation
import UIKit
import Lightbox

class Test: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var subredditName: String!
    var allImages: [LightboxImage]!
    var surroundingImages: [(Int, LightboxImage)]!
    var subService: SubredditService!
    var posts: [Post]! {
        didSet {
            allImages = posts.map {
                LightboxImage(imageURL: $0.imageURL, text: $0.title)
            }
        }
    }
    var imageQueue: [LightboxImage]!
    
    override func viewDidLoad() {
        self.navigationBar.title = subredditName
        self.subService = SubredditService(subreddit: subredditName)
        
        gatherPostsFromSubreddit()
    }
    
    func gatherPostsFromSubreddit() {
        print("gathering posts")
        subService.getSomePosts {
            self.posts = self.subService.posts
            self.collectionView.reloadData()
        }
    }
    
    func getSurroundingImageArray(indexPath: IndexPath, completion: () -> Void) -> Int {
        let bounds = 3
        var lowerBound = indexPath.row - bounds
        var upperBound = indexPath.row + bounds
        
        if indexPath.row - bounds < 0 {
            lowerBound = 0
        }
        if indexPath.row + bounds > self.allImages.count {
            upperBound = self.allImages.count
        }
        
        let surImgsArray = Array(ArraySlice<LightboxImage>(allImages[lowerBound...upperBound]))
        
        for i in 0...surImgsArray.count - 1 {
            let img: LightboxImage = surImgsArray[i]
            let tuple: (Int, LightboxImage) = (lowerBound + i, img)
            
            //if not clicking on image for first time
            //meaning surroundingImages array != nil
            if let _ = self.surroundingImages {
                if self.surroundingImages.contains(where: { $0.0 == tuple.0 }) {
                    continue
                } else {
                    print("added image to array")
                    self.surroundingImages.append(tuple)
                }
            } else {
                print("initializing surrounding images arary")
                self.surroundingImages = [tuple]
            }
        }
        
        var index: Int = 0
        for i in self.surroundingImages {
            if i.0 == indexPath.row {
                break
            } else {
                index += 1
            }
        }
        
        return index
    }
}

extension Test: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = self.getSurroundingImageArray(indexPath: indexPath) {
            self.surroundingImages.sort(by: { $0.0 < $1.0 })
        }
        
        self.imageQueue = surroundingImages.map { $0.1 }
        
        let controller = LightboxController(images: self.imageQueue, startIndex: index)
        controller.pageDelegate = self
        controller.dynamicBackground = true
        
        self.present(controller, animated: true, completion: nil)
    }
}


extension Test: LightboxControllerPageDelegate {
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        print(page)
    }
}
