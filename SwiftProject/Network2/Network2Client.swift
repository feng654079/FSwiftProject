//
//  NetworkClient.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/20.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension NSError {
    func getErrorReason() -> String {
        let reason = userInfo[NSLocalizedFailureReasonErrorKey] as? String
        return reason ?? ""
    }
}


class Network2Client: Client {
    
    var host: String = "https://api.zhuishushenqi.com/"
    
    static let shared: Network2Client = {
        let client = Network2Client()
        return client
    }()
    
    
//    func send<T>(_ request: T, completion: @escaping Completion) where T : Request {
//
//        let url = host + request.path
//
//        let afRequest =  SessionManager.default.request(url, method: Alamofire.HTTPMethod(rawValue: request.method.rawValue) ?? .get, parameters: request.parameters, encoding: URLEncoding.default, headers: nil)
//
//        afRequest.responseData { (dataResponse) in
//            if let reponseData = dataResponse.data {
//                if let json = try? JSON(data: reponseData) {
//                    debugPrint("RESPONSE: \(url)" , "\(json)")
//                    let code = json["code"].stringValue
//                    if code == "2000" {
//                        if let dic = try? JSONSerialization.jsonObject(with: reponseData, options: .allowFragments) as? [String : Any] {
//                            completion(dic, nil)
//                        } else {
//                            completion(nil,self.error(with: "响应不能被序列化为json Object"))
//                        }
//                    } else {
//                        completion(nil , self.error(with: json["message"].stringValue))
//                    }
//                } else {
//                    completion(nil,self.error(with: "json解析错误"))
//                }
//            } else {
//                completion(nil,self.error(with: "没有响应数据"))
//            }
//        }
//        afRequest.resume()
//    }
//
    
    func send<T>(_ request: T, completion: @escaping Completion) where T : Request {
           
           let url = host + request.path
           
           let afRequest =  SessionManager.default.request(url, method: Alamofire.HTTPMethod(rawValue: request.method.rawValue) ?? .get, parameters: request.parameters, encoding: URLEncoding.default, headers: nil)
           
           afRequest.responseData { (dataResponse) in
               if let reponseData = dataResponse.data {
                   if let json = try? JSON(data: reponseData) {
                       debugPrint("RESPONSE: \(url)" , "\(json)")
                       if let dic = try? JSONSerialization.jsonObject(with: reponseData, options: .allowFragments) as? [String : Any] {
                           completion(dic, nil)
                       } else {
                           completion(nil,self.error(with: "响应不能被序列化为json Object"))
                       }
                   } else {
                       completion(nil,self.error(with: "json解析错误"))
                   }
               } else {
                   completion(nil,self.error(with: "没有响应数据"))
               }
           }
           afRequest.resume()
       }
    
    private func error(with tipMsg:String) -> NSError {
        let userInfo = [NSLocalizedFailureReasonErrorKey:tipMsg]
        return NSError(domain: "netclient.error", code: -500, userInfo: userInfo)
    }
    
}
