//
//  CKRecordExtension.swift
//  Contacts
//
//  Created by Bethany Wride on 10/18/19.
//  Copyright © 2019 Bethany Bellio. All rights reserved.
//

import Foundation
import CloudKit

extension CKRecord {
    convenience init(contact: Contact) {
        self.init(recordType: ContactStrings.recordTypeKey, recordID: contact.ckRecordID)
        self.setValuesForKeys ([
            ContactStrings.nameKey : contact.name,
            ContactStrings.phoneNumberKey : contact.phoneNumber,
            ContactStrings.emailKey : contact.email
        ])
    }
}
