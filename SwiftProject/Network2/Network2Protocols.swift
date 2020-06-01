//
//  NetworkProtocols.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/20.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import Alamofire

enum HTTPMethod :String {
    case GET = "GET"
    case POST = "POST"
}

protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String :Any]? { get }
    
}


protocol Client {
    typealias Completion = ([String:Any]?,Error?) -> Void
    
    var host : String { get }
    
    func send<T:Request>(_ request:T ,completion:@escaping Completion) 
}

