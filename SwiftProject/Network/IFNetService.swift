//
//  IFNetService.swift
//  ViewTest
//
//  Created by Ifeng科技 on 2020/5/18.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class IFNetService {
    typealias JSONResponse = [String : Any]
    typealias SuccessHandler = (JSONResponse) -> Void
    typealias FailHandler = (Error?) -> Void
    typealias RequestParameters = [String:Any]
    
    
    static let responseQueue = DispatchQueue.init(label: "netservice.reponse.queue")
    static let shared: IFNetService = {
        let service = IFNetService()
        return service
    }()
    
    
    func getRequest(with address:String , parameters:RequestParameters,success:@escaping SuccessHandler , fail:@escaping FailHandler) {
        
        debugPrint("GET \(address) \n","para: \(parameters)")
        
        SessionManager.default
            .request(address, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON(queue: IFNetService.responseQueue, options: .allowFragments, completionHandler: { [weak self](response) in
                
                self?.handleResponse(response: response, address: address, success: success, fail: fail)
                
            }).resume()
    }
    
    func postRequest(with address:String , parameters:RequestParameters,success:@escaping SuccessHandler , fail:@escaping FailHandler) {
        
        SessionManager.default
            .request(address, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON(queue: IFNetService.responseQueue, options: .allowFragments, completionHandler: { [weak self ](response) in
                
                self?.handleResponse(response: response, address: address, success: success, fail: fail)
                
                
            }).resume()
    }
    
    
    func handleResponse(response :DataResponse<Any> ,address:String, success:SuccessHandler,fail:FailHandler) {
        if let reponseData = response.data {
            if let json = try? JSON(data: reponseData) {
                
                debugPrint("RESPONSE: \(address)" , "\(json)")
                
                let code = json["code"].stringValue
                
                if code == "2000" {
                    
                    switch response.result {
                    case .success(let data):
                        if let data = data as? JSONResponse {
                            success(data)
                        }
                    case .failure(let error):
                        fail(error)
                    }
                }
                
            } else {
                fail(nil)
            }
        } else {
            fail(nil)
        }
    }
    
    
}
