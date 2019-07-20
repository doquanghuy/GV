//
//  RealmNotification.swift
//  ContactApp
//
//  Created by Quang Huy on 7/18/19.
//  Copyright © 2019 RezaIlham. All rights reserved.
//

import UIKit
import RealmSwift

enum RealmNotificationType: String {
    case inital
    case change
    case update
    case delete
    case error
}

final class RealmNotification {
    static let share = RealmNotification()
    var collectionToken : NotificationToken?
    var objectToken: NotificationToken?
    
    func observeCollectionChange(collection: Results<Group>) {
        collectionToken = collection.observe({ (changes: RealmCollectionChange) in
            switch changes {
            case .initial(_):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: RealmNotificationType.inital.rawValue), object: collection)
            case .update(_, _, _, _):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: RealmNotificationType.update.rawValue), object: collection)
            case .error(_):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: RealmNotificationType.error.rawValue), object: collection)
            }
        })
    }
    
    func observerObjectChanged(object: Object) {
        objectToken = object.observe({ (objectChange) in
            switch objectChange {
            case .change(_):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: RealmNotificationType.change.rawValue), object: object)
            case .error(_):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: RealmNotificationType.error.rawValue), object: object)
            case .deleted:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: RealmNotificationType.delete.rawValue), object: object)
            }
        })
    }
    
    deinit {
        collectionToken?.invalidate()
        objectToken?.invalidate()
    }
}
