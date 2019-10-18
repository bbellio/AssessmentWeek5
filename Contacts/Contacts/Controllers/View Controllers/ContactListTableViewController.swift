//
//  ContactListTableViewController.swift
//  Contacts
//
//  Created by Bethany Wride on 10/18/19.
//  Copyright © 2019 Bethany Bellio. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {
// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }

// MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactController.sharedInstance.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let contact = ContactController.sharedInstance.contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        return cell
    }

// MARK: - Custom Methods
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func loadContacts() {
        ContactController.sharedInstance.fetchAllContacts { (success) in
            if success {
                self.updateViews()
            }
        }
    }
    
// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toContactDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let destinationVC = segue.destination as? ContactDetailViewController
            let contact = ContactController.sharedInstance.contacts[indexPath.row]
            destinationVC?.contact = contact
        }
    }
} // End of class
