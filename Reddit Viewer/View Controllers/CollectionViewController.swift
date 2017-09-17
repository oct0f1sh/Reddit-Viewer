//
//  ViewController.swift
//  Reddit Viewer
//
//  Created by Duncan MacDonald on 9/16/17.
//

import Foundation
import UIKit
import CoreData

class CollectionViewController: UIViewController {
    var subreddits: [Subreddit] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        reloadSubreddits()
    }
    
    func reloadSubreddits() {
        subreddits = CoreDataHelper.retrieveSubreddits()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addSubredditTapped(_ sender: Any) {
        self.showInputTextAlert(title: "Add SubReddit", message: "Input the name of the SubReddit you want to add:", placeholder: "SubReddit") { (subreddit) in
            guard let subreddit = subreddit else { return }
            let newSubreddit = CoreDataHelper.addSubreddit()
            newSubreddit.subredditName = subreddit
            CoreDataHelper.saveSubreddit()
            self.reloadSubreddits()
            print(self.subreddits.count)
        }
    }
}

extension CollectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subreddits.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension CollectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SubredditCell = tableView.dequeueReusableCell()
        let subreddit = subreddits[indexPath.row]
        
        cell.subredditLabel.text = subreddit.subredditName
        
        return cell
    }
}
