//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Bethany Wride on 10/18/19.
//  Copyright © 2019 Bethany Bellio. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
// MARK: - Properties and Global Variables
    var contact: Contact? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
// MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
// MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let nameText = nameTextField.text, !nameText.isEmpty,
            let phoneNumberText = phoneNumberTextField.text,
            let emailText = emailTextField.text
        else { return }
        if let contact = contact {
            contact.name = nameText
            contact.phoneNumber = phoneNumberText
            contact.email = emailText
            self.update(contact: contact)
        } else {
            self.addContact(name: nameText, phoneNumber: phoneNumberText, email: emailText)
        }
    }
    
// MARK: - Custom Methods
    func updateViews() {
        if let contact = contact {
            nameTextField.text = contact.name
            phoneNumberTextField.text = contact.phoneNumber
            emailTextField.text = contact.email
            title = contact.name
        }
    }
    
    func update(contact: Contact) {
        ContactController.sharedInstance.update(contact: contact) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
                print("Successfully updated contact when save button was tapped")
            }
        }
    }
    
    func addContact(name: String, phoneNumber: String, email: String) {
        ContactController.sharedInstance.createContactWith(name: name, phoneNumber: phoneNumber, email: email) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.nameTextField.text = name
                    self.phoneNumberTextField.text = phoneNumber
                    self.emailTextField.text = email
                    self.navigationController?.popViewController(animated: true)
                }
                print("Successfully saved new contact when save button was tapped")
            }
        }
    }
} // End of class
