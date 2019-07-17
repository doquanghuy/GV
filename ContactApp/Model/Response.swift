//
//  Response.swift
//

import Foundation

struct Response {
    fileprivate var results: Data
    init(results: Data) {
        self.results = results
    }
}

extension Response {
    public func decode<T: Codable>(_ type: T.Type) -> T? {
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(T.self, from: results)
            return response
        } catch _ {
            return nil
        }
    }
}
