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
    func load<R: ModelRequest, Model>(_ request: R, completion: @escaping (Result<[Model]>) -> Void) where Model == R.Model
}

protocol Parsable {
    
    static func fromJSON(_ json: [String: AnyHashable]) -> Self?
}

protocol Request {
    var host: String { get }
    var path: String { get }
    var GETParameters: [String: String] { get }
}

protocol ModelRequest: Request {
    associatedtype Model: Parsable
    var payloadPath: [String] { get }
}

enum Result<T> {
    case success(T)
    case fail(Error)
}

class RequestManager: IRequestManager {
    
    let requestBuilder: IRequestBuilder
    let responseParser: IResponseParser
    
    enum NetworkError: Error {
        case requestError
        case parsingError
    }
    
    init(requestBuilder: IRequestBuilder, responseParser: IResponseParser) {
        self.requestBuilder = requestBuilder
        self.responseParser = responseParser
    }
    
    func load<R: ModelRequest, Model>(_ request: R, completion: @escaping (Result<[Model]>) -> Void) where Model == R.Model {
        
        guard let urlRequest = requestBuilder.buildURLRequest(from: request) else {
            completion(.fail(NetworkError.requestError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, requestError) in
            
            if let requestError = requestError {
                completion(.fail(requestError))
                return
            }
            
            do {
                let result = try self.responseParser.parse(data, payloadPath: request.payloadPath, model: R.Model.self)
                completion(.success(result))
            } catch let error {
                completion(Result.fail(error))
            }
        }
        
        task.resume()
        
    }
    
}
