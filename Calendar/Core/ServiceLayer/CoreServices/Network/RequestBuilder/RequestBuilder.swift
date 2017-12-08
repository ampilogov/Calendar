//
//  RequestBuilder.swift
//  Calendar
//
//  Created by Vitaliy Ampilogov on 12/6/17.
//  Copyright © 2017 v.ampilogov. All rights reserved.
//

import Foundation

protocol IRequestBuilder {
    func buildURLRequest(from request: Request) -> URLRequest?
}

class RequestBuilder: IRequestBuilder {
    
    func buildURLRequest(from request: Request) -> URLRequest? {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = request.host
        urlComponents.path = request.path
        urlComponents.queryItems = request.GETParameters.map { URLQueryItem(name: $0, value: $1) }
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        return URLRequest(url: url)
    }
}
