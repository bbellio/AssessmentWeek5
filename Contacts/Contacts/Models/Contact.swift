//
//  Contact.swift
//  Contacts
//
//  Created by Bethany Wride on 10/18/19.
//  Copyright © 2019 Bethany Bellio. All rights reserved.
//

import Foundation
import CloudKit

// MARK: - ContactStrings
struct ContactStrings {
    static let recordTypeKey = "Contact"
    static let nameKey = "name"
    static let phoneNumberKey = "phoneNumber"
    static let emailKey = "email"
}

// MARK: - Class Declaration
class Contact {
    var name: String
    var phoneNumber: String
    var email: String
    var ckRecordID: CKRecord.ID
   
// MARK: - Initialization
    init(name: String, phoneNumber: String = "", email: String = "", ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.ckRecordID = ckRecordID
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[ContactStrings.nameKey] as? String,
            let phoneNumber = ckRecord[ContactStrings.phoneNumberKey] as? String,
            let email = ckRecord[ContactStrings.emailKey] as? String
            else { return nil }
        self.init(name: name, phoneNumber: phoneNumber, email: email, ckRecordID: ckRecord.recordID)
    }
} // End of class

