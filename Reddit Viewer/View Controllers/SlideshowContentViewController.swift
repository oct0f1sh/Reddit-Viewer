//
//  SlideshowContentViewController.swift
//  Reddit Viewer
//
//  Created by Duncan MacDonald on 9/19/17.
//

import Foundation
import UIKit

class SlideshowContentViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var post: Post?
    
    override func viewDidLoad() {
        if let post = post {
            post.images.downloadFullImage() { () in
                self.imageView.image = post.images.fullImage
            }
        }
        print("view loaded")
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        print("exit button tapped")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
}
