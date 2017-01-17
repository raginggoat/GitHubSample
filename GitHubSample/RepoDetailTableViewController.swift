//
//  RepoDetailTableViewController.swift
//  GitHubSample
//
//  Created by Adam Rayborn on 1/16/17.
//  Copyright © 2017 Adam Rayborn. All rights reserved.
//

import UIKit
import SafariServices

class RepoDetailTableViewController: UITableViewController {
    
    var repoJSON: JSON?
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        let addFavItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFav))
        self.navigationItem.rightBarButtonItem = addFavItem
        
        if let name = repoJSON?["name"].string {
            title = name
            
            if defaults.array(forKey: "favRepos") != nil {
                let array = defaults.array(forKey: "favRepos") as! [String]
                
                for string in array {
                    if string.contains(name) {
                        self.navigationItem.rightBarButtonItem?.isEnabled = false
                        break
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addFav() {
        if defaults.array(forKey: "favRepos") != nil {
            let jsonString = repoJSON?.rawString()
            var newArray = defaults.array(forKey: "favRepos") as! [String]
            newArray.append(jsonString!)
            defaults.setValue(newArray, forKey: "favRepos")
            defaults.synchronize()
        } else {
            let jsonString = repoJSON!.rawString()
            var array = [String]()
            array.append(jsonString!)
            defaults.setValue(array, forKey: "favRepos")
            defaults.synchronize()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        if (cell != nil)
        {
            cell = UITableViewCell(style: .default,
                                   reuseIdentifier: "reuseIdentifier")
        }
        
        if indexPath.row == 0 {
            if let language = repoJSON?["language"].string {
                cell?.textLabel?.text = String("Language: \(language)")
            }
        } else if indexPath.row == 1 {
            if let created = repoJSON?["created_at"].string {
                cell?.textLabel?.text = String("Created \(created)")
            }
        } else if indexPath.row == 2 {
            if let updated = repoJSON?["updated_at"].string {
                cell?.textLabel?.text = String("Updated \(updated)")
            }
        } else if indexPath.row == 3 {
            if let forks = repoJSON?["forks_count"].int {
                cell?.textLabel?.text = String("Forks: \(forks)")
            }
        } else if indexPath.row == 4 {
            if let issues = repoJSON?["open_issues_count"].int {
                cell?.textLabel?.text = String("Open issues: \(issues)")
            }
        } else if indexPath.row == 5 {
            if let watchers = repoJSON?["watchers_count"].int {
                cell?.textLabel?.text = String("Watchers: \(watchers)")
            }
        } else if indexPath.row == 6 {
            if let url = repoJSON?["html_url"].string {
                cell?.textLabel?.text = String("\(url)")
            }
        }

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 6 {
            if let urlString = repoJSON?["html_url"].string {
                let url = URL(string: urlString)
                let safariVC = SFSafariViewController(url: url!)
                self.present(safariVC, animated: true, completion: nil)
            }
        }
    }
}
