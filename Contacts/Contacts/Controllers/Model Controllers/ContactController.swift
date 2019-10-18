//
//  ContactController.swift
//  Contacts
//
//  Created by Bethany Wride on 10/18/19.
//  Copyright © 2019 Bethany Bellio. All rights reserved.
//

import Foundation
import CloudKit

class ContactController {
// MARK: - Properties and Global Variables
    static let sharedInstance = ContactController()
    var contacts: [Contact] = []
    let privateDB = CKContainer.default().privateCloudDatabase

// MARK: - CRUD
    // Create
    func createContactWith(name: String, phoneNumber: String, email: String, completion: @escaping (_ success: Bool) -> Void){
        let newContact = Contact(name: name, phoneNumber: phoneNumber, email: email)
        let recordForNewContact = CKRecord(contact: newContact)
        privateDB.save(recordForNewContact) { (record, error) in
            if let error = error {
                print("Error in trying to save contacts to Cloud: \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let unwrappedSavedRecord = record,
                let savedContact = Contact(ckRecord: unwrappedSavedRecord)
                else { completion(false) ; return }
            self.contacts.append(savedContact)
            print("Successfully saved new contact to cloud and appended local array")
            completion(true)
        }
    } // End of function
    
    // Read
    func fetchAllContacts(completion: @escaping (_ success: Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: ContactStrings.recordTypeKey, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (recordsArray, error) in
            if let error = error {
                print("Error fetching contacts: \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let unwrappedRecords = recordsArray else { completion(false) ; return }
            let contactsArray = unwrappedRecords.compactMap { Contact(ckRecord: $0) }
            self.contacts = contactsArray
            print("Successfully fetched all contacts")
            completion(true)
        }
    } // End of function
    
    // Update
    func update(contact: Contact, completion: @escaping (_ success: Bool) -> Void) {
        let recordToUpdate = CKRecord(contact: contact)
        let operation = CKModifyRecordsOperation(recordsToSave: [recordToUpdate], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { records, _, error in
            if let error = error {
                print("Error updating record for contact in Cloud: \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard recordToUpdate == records?.first else {
                print("Unexpected record updated")
                completion(false)
                return
            }
            print("Updated contact record in the Cloud successfully")
            completion(true)
        }
        privateDB.add(operation)
    } // End of function
} // End of class
