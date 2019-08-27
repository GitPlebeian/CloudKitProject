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
        configureRefreshControl()
        loadData()
    }
    
    func loadData() {
        HypeController.shared.fetchHypes { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func configureRefreshControl () {
        // Add the refresh control to your UIScrollView object.
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:
            #selector(handleRefreshControl),
                                                  for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        
        self.loadData()
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Actions
    
    func presentAddHypeAleart(hype: Hype?) {
        let alertController = UIAlertController(title: "Get Hype", message: "What is hype my never die", preferredStyle: .alert)
        
        alertController.addTextField { (textfield) in
            textfield.placeholder = "WHAT'S HYPEING TODAY BRUH?"
        }
        // Add Action
        let addHypeAction = UIAlertAction(title: "Add Hype", style: .default) { (_) in
            guard let hypeText = alertController.textFields?[0].text else {return}
            let feedback = UINotificationFeedbackGenerator()
            feedback.prepare()
            if hypeText != "" && hype == nil{
                HypeController.shared.saveHype(text: hypeText, completion: { (success) in
                    if success {
                        DispatchQueue.main.async {
                            feedback.notificationOccurred(.success)
                            self.tableView.reloadData()
                        }
                    }
                })
            } else {
                guard let hype = hype else {return}
                HypeController.shared.updateHype(hype: hype, with: hypeText, completion: { (success) in
                    if success {
                        DispatchQueue.main.async {
                            feedback.notificationOccurred(.success)
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
    
    @IBAction func addHypeButtonTapped(_ sender: Any) {
        presentAddHypeAleart(hype: nil)
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let hype = HypeController.shared.hypes[indexPath.row]
            
            let feedback = UINotificationFeedbackGenerator()
            feedback.prepare()
            HypeController.shared.removeHype(hype) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.tableView.reloadData()
                        feedback.notificationOccurred(.success)
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hype = HypeController.shared.hypes[indexPath.row]
        
        presentAddHypeAleart(hype: hype)
    }
}
