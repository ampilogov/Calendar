//
//  RequestManager.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 12/3/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation

protocol IRequestManager {
    
    // Send request to server
    func load<T: Request, Model>(_ request: T, completion: @escaping (Result<Model>) -> Void)
    
}

protocol Parsable {
    
    func fromJSON(_ json: [String: AnyHashable]) -> Self
}

protocol Request {
    
    associatedtype Model: Parsable

    var host: String { get }
    var path: String { get }
    var GETParameters: [String: String] { get }
}

enum Result<T> {
    case success(T)
    case fail(Error)
}

class RequestManager {
    
    func load<R: Request, Model>(_ request: R, completion: @escaping (Result<Model>) -> Void) {
        
        let url = URL(fileReferenceLiteralResourceName: "")//request.buildURL()
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
        }
        
    }
    
}
