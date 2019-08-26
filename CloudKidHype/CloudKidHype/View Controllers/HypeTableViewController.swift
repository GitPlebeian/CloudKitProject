//
//  HypeTableViewController.swift
//  CloudKidHype
//
//  Created by Jackson Tubbs on 8/26/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class HypeTableViewController: UITableViewController {

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func addHypeButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Get Hype", message: "What is hype my never die", preferredStyle: .alert)
        
        alertController.addTextField { (textfield) in
            textfield.placeholder = "WHAT'S HYPEING TODAY BRUH?"
        }
        // Add Action
        let addHypeAction = UIAlertAction(title: "Add Hype", style: .default) { (_) in
            guard let hypeText = alertController.textFields?[0].text else {return}
            
            if hypeText != "" {
                HypeController.shared.saveHype(text: hypeText, completion: { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(addHypeAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HypeController.shared.hypes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hypeCell", for: indexPath)

        let hype = HypeController.shared.hypes[indexPath.row]
        
        cell.textLabel?.text = hype.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd yyyy"
        
        cell.detailTextLabel?.text = dateFormatter.string(from: hype.timestamp)

        return cell
    }
}
