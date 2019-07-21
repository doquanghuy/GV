//
//  ListViewModelTests.swift
//  ContactAppTests
//
//  Created by Quang Huy on 7/21/19.
//  Copyright © 2019 RezaIlham. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import ContactApp

class ListViewModelTests: XCTestCase {
    var listViewModel: ContactsViewModel!
    var provider: RealmProvider!
    
    override func setUp() {
        provider = RealmProvider().copyForTesting()
        listViewModel = ContactsViewModel(realmProvider: provider)
    }
    
    func testRequestListCalled() {
        let exp = expectation(description: "testRequestListCalled")
        listViewModel.requestContactList { (error, json) in
            if error == nil && json == nil {
                XCTFail()
                return
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 30.0, handler: nil)
    }
    
    func testRequestListReturnJsonArray() {
        let exp = expectation(description: "testRequestListCalled")
        listViewModel.requestContactList { (error, json) in
            if error != nil{
                XCTFail()
                return
            }
            guard let json = json else {
                XCTFail()
                return
            }
            XCTAssertNotNil(json.array)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 30.0, handler: nil)
    }
    
    func testSaveListData() {
        let exp = expectation(description: "testSaveListData")
        let contact1 = Contact()
        contact1.id = 1
        let contact2 = Contact()
        contact2.id = 2
        let contacts = [contact1.toJSON(), contact2.toJSON()]
        let json = JSON(contacts)
        listViewModel.addContacts(json: json, provider) { (c) in
            XCTAssertEqual(c.count, contacts.count)
            exp.fulfill()
        }
        waitForExpectations(timeout: 30.0, handler: nil)
    }
    
    func testSortContacts() {
        let contact1 = Contact()
        contact1.id = 1
        contact1.first_name = "E"
        
        let contact2 = Contact()
        contact2.id = 2
        contact2.first_name = "B"
        
        let contact3 = Contact()
        contact3.id = 3
        contact3.first_name = "D"
        
        let contact4 = Contact()
        contact4.id = 4
        contact4.first_name = "C"
        
        Contact.createOrUpdate(realmProvider: provider, false,  [contact1, contact2, contact3, contact4], nil)
        XCTAssertEqual(Group.findAll(realmProvider: provider).count, 4)
        XCTAssertEqual(Contact.findAll(realmProvider: provider).count, 4)
        listViewModel.resetSections()
        
        
        var contactTest = listViewModel.contactViewModel(indexPath: IndexPath(row: 0, section: 0))?.contact()
        XCTAssertNotNil(contactTest)
        XCTAssertEqual(contactTest!.id, 2)
        
        contactTest = listViewModel.contactViewModel(indexPath: IndexPath(row: 0, section: 1))?.contact()
        XCTAssertNotNil(contactTest)
        XCTAssertEqual(contactTest!.id, 4)
        
        contactTest = listViewModel.contactViewModel(indexPath: IndexPath(row: 0, section: 2))?.contact()
        XCTAssertNotNil(contactTest)
        XCTAssertEqual(contactTest!.id, 3)
        
        contactTest = listViewModel.contactViewModel(indexPath: IndexPath(row: 0, section: 3))?.contact()
        XCTAssertNotNil(contactTest)
        XCTAssertEqual(contactTest!.id, 1)
    }
    
    func testTwoContactInTheSameGroup() {
        let contact1 = Contact()
        contact1.id = 1
        contact1.first_name = "E"
        
        let contact2 = Contact()
        contact2.id = 2
        contact2.first_name = "E1"
        
        Contact.createOrUpdate(realmProvider: provider, false,  [contact1, contact2], nil)
        XCTAssertEqual(Group.findAll(realmProvider: provider).count, 1)
        XCTAssertEqual(Contact.findAll(realmProvider: provider).count, 2)
        listViewModel.resetSections()

        var contactTest = listViewModel.contactViewModel(indexPath: IndexPath(row: 0, section: 0))?.contact()
        XCTAssertNotNil(contactTest)
        XCTAssertEqual(contactTest!.id, 1)
        
        contactTest = listViewModel.contactViewModel(indexPath: IndexPath(row: 1, section: 0))?.contact()
        XCTAssertNotNil(contactTest)
        XCTAssertEqual(contactTest!.id, 2)
    }
    
    override func tearDown() {
        try! provider.realm.write {
            provider.realm.deleteAll()
        }
    }
}
