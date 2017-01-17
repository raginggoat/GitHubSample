//
//  ReposTableViewController.swift
//  GitHubSample
//
//  Created by Adam Rayborn on 1/16/17.
//  Copyright © 2017 Adam Rayborn. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    var json: JSON?
    var selectedJSON: JSON?
    var userName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = userName {
            title = user
        }
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (json?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        if (cell != nil)
        {
            cell = UITableViewCell(style: .subtitle,
                                   reuseIdentifier: "reuseIdentifier")
        }
        
        if let name = json?[indexPath.row]["name"].string {
            cell?.textLabel?.text = name
        }
        
        if let description = json?[indexPath.row]["description"].string {
            cell?.detailTextLabel?.text = description
        }
        
        return cell!
    }

    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedJSON = json?[indexPath.row]
        self.performSegue(withIdentifier: "repoDetails", sender: self.navigationController)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "repoDetails" {
            let repoDetailsTVC: RepoDetailTableViewController = segue.destination as! RepoDetailTableViewController
            repoDetailsTVC.repoJSON = selectedJSON
        }
    }
}
