//
//  TestExtension.swift
//  ContactAppTests
//
//  Created by Quang Huy on 7/21/19.
//  Copyright © 2019 RezaIlham. All rights reserved.
//

import Foundation
import RealmSwift

@testable import ContactApp

extension RealmProvider {
    func copyForTesting() -> RealmProvider {
        var conf = self.configuration
        conf.inMemoryIdentifier = UUID().uuidString
        conf.readOnly = false
        return RealmProvider(config: conf)
    }
}

extension Realm {
    func addForTesting(objects: [Object]) {
        try! write {
            add(objects)
        }
    }
}


