//
//  DetailViewModelTests.swift
//  ContactAppTests
//
//  Created by Quang Huy on 7/21/19.
//  Copyright © 2019 RezaIlham. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import ContactApp

class DetailViewModelTests: XCTestCase {
    var provider: RealmProvider!
    
    override func setUp() {
        provider = RealmProvider().copyForTesting()
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
            print(res)
            XCTAssertEqual(res.first_name, contact.first_name)
            XCTAssertEqual(res.last_name, contact.last_name)
            exp.fulfill()
        }
        waitForExpectations(timeout: 30.0, handler: nil)
    }
    
    func testRequestDetailContact() {
        let exp = expectation(description: "testAddContactRemote")
        let contactId = 7697
        let detailViewModel = ContactViewModel(contactId: contactId, realmProvider: provider)
        detailViewModel.getDetailContact { (error, json) in
            if error == nil && json == nil {
                XCTFail()
                return
            }
            let res = Contact()
            Contact.parseFromJSON(json: json!, object: res)
            XCTAssertEqual(contactId, res.id)
            exp.fulfill()
        }
        waitForExpectations(timeout: 30.0, handler: nil)

    }

    func testSaveListData() {
        let exp = expectation(description: "testSaveListData")
        let contact1 = Contact()
        contact1.id = 7697
        let json = JSON(contact1.toJSON())
        let detailViewModel = ContactViewModel(contactId: contact1.id, realmProvider: provider)
        detailViewModel.updateData(json: json, completion: { (contact) in
            guard let contact = contact else {
                XCTFail()
                return
            }
            XCTAssertEqual(contact1.id, contact.id)
            exp.fulfill()
        })
        waitForExpectations(timeout: 30.0, handler: nil)
    }
    
    func testUpdateFavoriteRemote() {
        let exp = expectation(description: "testSaveListData")
        let id = 7697
        let favorite = false
        let detailViewModel = ContactViewModel(contactId: id, realmProvider: provider)
        detailViewModel.updateContact(favorite: favorite, contactId: id) { (error, json) in
            if error == nil && json == nil {
                XCTFail()
                return
            }
            let res = Contact()
            Contact.parseFromJSON(json: json!, object: res)
            XCTAssertEqual(id, res.id)
            XCTAssertEqual(favorite, res.favorite)
            exp.fulfill()
        }
        waitForExpectations(timeout: 30.0, handler: nil)
    }
    
    override func tearDown() {
        try! provider.realm.write {
            provider.realm.deleteAll()
        }
    }
}
