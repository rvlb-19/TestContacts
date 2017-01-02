//
//  ViewController.swift
//  TestContacts
//
//  Created by Renato on 02/01/17.
//  Copyright © 2017 Renato Vieira Leite de Barros. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getContacts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getContacts() {
        let store = CNContactStore()
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .notDetermined:
            store.requestAccess(for: .contacts, completionHandler: {
                (authorized: Bool, error: Error?) -> Void in
                if authorized {
                    self.retrieveContactsWithStore(store)
                }
            })
        case .authorized:
            self.retrieveContactsWithStore(store)
        default:
            break
        }
    }
    
    func retrieveContactsWithStore(_ store: CNContactStore) {
        do {
            let predicate = CNContact.predicateForContacts(matchingName: "Renato")
            let keys = [
                CNContactGivenNameKey,
                CNContactPhoneNumbersKey
            ]
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys as [CNKeyDescriptor])
            for contact in contacts {
                let name = contact.givenName
                guard let phone = contact.phoneNumbers.first else {
                    // If our contact doesn't have a phone number
                    // we simply skip it and go to the next one...
                    continue
                }
                print("\(name) - \(phone.value.stringValue).")
            }
        } catch {
            print(error)
        }
    }
}

