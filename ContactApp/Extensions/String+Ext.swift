//
//  String+Ext.swift
//  ContactApp
//
//  Created by Quang Huy on 7/20/19.
//  Copyright © 2019 RezaIlham. All rights reserved.
//

import Foundation

extension String {
    var isAlphabet: Bool {
        for c in "abcdefghijklmnopqrstuvwxyz" {
            if String(c) == self.lowercased() {
                return true
            }
        }
        return false
    }
}
