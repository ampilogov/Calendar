//
//  ResponseParser.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 12/7/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation

protocol IResponseParser {
    func parse<T: Parsable>(_ data: Data?, payloadPath: [String], model: T.Type) throws -> [T]
}

class ResponseParser: IResponseParser {
    
    typealias JSON = [String: AnyHashable]
    
    func parse<T: Parsable>(_ data: Data?, payloadPath: [String], model: T.Type) throws -> [T] {
        
        var result = [T]()
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                result = parsePayload(from: json, path: payloadPath).flatMap({ T.fromJSON($0) })
            } catch let parsingError {
                throw parsingError
            }
        }
        
        return result
    }
    
    private func parsePayload(from json: Any, path: [String]) -> [JSON] {
        var payload: Any = json
        for key in path {
            if let jsonPayload = payload as? JSON,
                let subJSON = jsonPayload[key] {
                payload = subJSON
            } else {
                break
            }
        }
        
        let result = payload as? [JSON] ?? []
        return result
    }
    
}
