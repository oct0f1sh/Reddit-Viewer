//
//  ThumbnailCell.swift
//  Reddit Viewer
//
//  Created by Duncan MacDonald on 9/18/17.
//

import Foundation
import UIKit

class ThumbnailCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var post: Post!
    
    override func awakeFromNib() {
        self.activityView.isHidden = true
    }
    
    func stopLoading() {
        self.activityView.stopAnimating()
        self.activityView.isHidden = true
    }
    
    func downloadImage(completion: @escaping () -> Void) {
        post.images.downloadThumbnail {
            self.thumbnailImageView.image = self.post.images.thumbnail
            self.stopLoading()
            completion()
        }
    }
}
