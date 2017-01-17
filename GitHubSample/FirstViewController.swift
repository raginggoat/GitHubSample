//
//  FirstViewController.swift
//  GitHubSample
//
//  Created by Adam Rayborn on 1/16/17.
//  Copyright © 2017 Adam Rayborn. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    
    var json: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userNameTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getJSONData() -> Data? {
        var data = Data()
        
        if let username = userNameTextField.text {
            let urlString = String("https://api.github.com/users/\(username)/repos")
            let url = URL(string: urlString!)
            
            do {
                data = try Data(contentsOf: url!)
            } catch {
                // Error getting data
            }
        }
        
        return data
    }
    
    func getJSON(with data: Data) {
        json = JSON(data: data)
        
        if (json?.null != nil) {
            print("User not found")
            let notFoundAlert = UIAlertController(title: "", message: "User not found.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                (action) -> Void in
                notFoundAlert.dismiss(animated: true, completion: nil)
            })
            
            notFoundAlert.addAction(okAction)
            self.present(notFoundAlert, animated: true, completion: nil)
        } else {
            // Perform segue to repo table view
            self.performSegue(withIdentifier: "showRepos", sender: self.navigationController)
        }
    }

    @IBAction func lookUpUser(_ sender: AnyObject?) {
        if let jsonData = getJSONData() {
            getJSON(with: jsonData)
        }
    }
    
    // MARK: - UITextField
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        lookUpUser(nil)
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showRepos" {
            let repoTVC: ReposTableViewController = segue.destination as! ReposTableViewController
            repoTVC.json = self.json
            repoTVC.userName = self.userNameTextField.text!
        }
    }
}

