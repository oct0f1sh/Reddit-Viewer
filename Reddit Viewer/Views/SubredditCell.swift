//
//  SubreditCell.swift
//  Reddit Viewer
//
//  Created by Duncan MacDonald on 9/16/17.
//

import Foundation
import UIKit

class SubredditCell: UITableViewCell {
    @IBOutlet weak var subredditLabel: UILabel!
    
    @IBAction func buttonTapped(_ sender: Any) {
        print("button tapped")
        
        ImageService.getPostsFromSubreddit(subreddit: subredditLabel.text!) { (posts) in
            
        }
    }
}
