//
//  ViewController.swift
//  Reddit Viewer
//
//  Created by Duncan MacDonald on 9/16/17.
//

import Foundation
import UIKit

class CollectionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addSubredditTapped(_ sender: Any) {
        
    }
}

extension CollectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension CollectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SubredditCell = tableView.dequeueReusableCell()
        
        return cell
    }
}
