//
//  AddViewModelTests.swift
//  ContactAppTests
//
//  Created by Quang Huy on 7/21/19.
//  Copyright © 2019 RezaIlham. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import ContactApp

class AddViewModelTests: XCTestCase {
    var provider: RealmProvider!
    
    override func setUp() {
        provider = RealmProvider().copyForTesting()
    }
    
    override func tearDown() {
        try! provider.realm.write {
            provider.realm.deleteAll()
        }
    }
    
    func testAddContactRemote() {
        let exp = expectation(description: "testAddContactRemote")
        let addContactViewModel = AddContactViewModel(realmProvider: provider)
        let contact = Contact()
        contact.first_name = "ABCD"
        contact.last_name = "EFGH"
        contact.email = "doquanghuy91@gmail.com"
        contact.phone_number = "8374783463928643"
        addContactViewModel.createContact(contact: contact) { (error, json) in
            if error == nil && json == nil {
                XCTFail()
                return
            }
            let res = Contact()
            Contact.parseFromJSON(json: json!, object: res)
            XCTAssertEqual(res.first_name, contact.first_name)
            XCTAssertEqual(res.last_name, contact.last_name)
            exp.fulfill()
        }
        waitForExpectations(timeout: 30.0, handler: nil)
    }
    
    func testAddedContactExistInRealm() {
        let exp = expectation(description: "testAddContactRemote")
        let addContactViewModel = AddContactViewModel(realmProvider: provider)
        let contact = Contact()
        contact.first_name = "ABCD"
        contact.last_name = "EFGH"
        contact.email = "doquanghuy91@gmail.com"
        contact.phone_number = "8374783463928643"
        addContactViewModel.createContact(contact: contact) { (error, json) in
            if error == nil && json == nil {
                XCTFail()
                return
            }
            let res = Contact()
            Contact.parseFromJSON(json: json!, object: res)
            let contactInRealm = Contact.findByID(id: res.id, realmProvider: self.provider, true)
            XCTAssertNil(contactInRealm)
            exp.fulfill()
        }
        waitForExpectations(timeout: 30.0, handler: nil)
    }
    
    func testAddContactSavedLocal() {
        let exp = expectation(description: "testAddContactRemote")
        let addContactViewModel = AddContactViewModel(realmProvider: provider)
        let contact = Contact()
        contact.first_name = "ABCD"
        contact.last_name = "EFGH"
        contact.email = "doquanghuy91@gmail.com"
        contact.phone_number = "8374783463928643"
        addContactViewModel.createContact(contact: contact) { (error, json) in
            if error == nil && json == nil {
                XCTFail()
                return
            }
            let res = Contact()
            Contact.parseFromJSON(json: json!, object: res)
            addContactViewModel.createContactLocal(json: json!, completion: { (res) in
                XCTAssertEqual(contact.email, res?.email)
                XCTAssertEqual(contact.phone_number, res?.phone_number)
                XCTAssertEqual(contact.first_name, res?.first_name)
                XCTAssertEqual(contact.last_name, res?.last_name)
                exp.fulfill()
            })
        }
        waitForExpectations(timeout: 30.0, handler: nil)
    }
    
    func testAddedAlphabetContactInCorrectGroup() {
        let exp = expectation(description: "testAddContactRemote")
        let addContactViewModel = AddContactViewModel(realmProvider: provider)
        let contact = Contact()
        contact.first_name = "ABCD"
        contact.last_name = "EFGH"
        contact.email = "doquanghuy91@gmail.com"
        contact.phone_number = "8374783463928643"
        addContactViewModel.createContact(contact: contact) { (error, json) in
            if error == nil && json == nil {
                XCTFail()
                return
            }
            let res = Contact()
            Contact.parseFromJSON(json: json!, object: res)
            addContactViewModel.createContactLocal(json: json!, completion: { (res) in
                guard let res = res, let group = res.group else {
                    XCTFail()
                    return
                }
                let firstChar = contact.first_name.first
                XCTAssertEqual(group.id, firstChar != nil ? String(firstChar!) : "")
                exp.fulfill()
            })
        }
        waitForExpectations(timeout: 30.0, handler: nil)
    }
    
    func testSepecialCharacterContactInCorrectGroup() {
        let exp = expectation(description: "testAddContactRemote")
        let addContactViewModel = AddContactViewModel(realmProvider: provider)
        let contact = Contact()
        contact.first_name = "1111"
        contact.last_name = "EFGH"
        contact.email = "doquanghuy91@gmail.com"
        contact.phone_number = "8374783463928643"
        addContactViewModel.createContact(contact: contact) { (error, json) in
            if error == nil && json == nil {
                XCTFail()
                return
            }
            let res = Contact()
            Contact.parseFromJSON(json: json!, object: res)
            addContactViewModel.createContactLocal(json: json!, completion: { (res) in
                guard let res = res, let group = res.group else {
                    XCTFail()
                    return
                }
                XCTAssertEqual(group.id, "#")
                exp.fulfill()
            })
        }
        waitForExpectations(timeout: 30.0, handler: nil)
    }
}
