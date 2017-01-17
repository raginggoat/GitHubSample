//
//  FavoritesTableViewController.swift
//  GitHubSample
//
//  Created by Adam Rayborn on 1/16/17.
//  Copyright © 2017 Adam Rayborn. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    var selectedJSON: JSON?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favorites"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        if defaults.array(forKey: "favRepos") != nil {
            let editItem = self.editButtonItem
            self.navigationItem.rightBarButtonItem = editItem
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
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
        if defaults.array(forKey: "favRepos") != nil {
            return (defaults.array(forKey: "favRepos")?.count)!
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            self.tableView.isEditing = true
        } else {
            self.tableView.isEditing = false
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var array = defaults.array(forKey: "favRepos") as! [String]
            array.remove(at: (indexPath as NSIndexPath).row)
            defaults.setValue(array, forKey: "favRepos")
            defaults.synchronize()
            tableView.reloadData()
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        if (cell != nil)
        {
            cell = UITableViewCell(style: .subtitle,
                                   reuseIdentifier: "reuseIdentifier")
        }
        
        let jsonString = defaults.array(forKey: "favRepos")?[indexPath.row]
        let json = JSON.init(parseJSON: jsonString as! String)
        
        if let name = json["name"].string {
            cell?.textLabel?.text = name
        }
        
        if let description = json["description"].string {
            cell?.detailTextLabel?.text = description
        }
        
        return cell!
    }

    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let string = defaults.array(forKey: "favRepos")?[indexPath.row]
        selectedJSON = JSON.init(parseJSON: string as! String)
        self.performSegue(withIdentifier: "favDetails", sender: self.navigationController)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favDetails" {
            let repoDetailsTVC: RepoDetailTableViewController = segue.destination as! RepoDetailTableViewController
            repoDetailsTVC.repoJSON = selectedJSON
        }
    }
}
