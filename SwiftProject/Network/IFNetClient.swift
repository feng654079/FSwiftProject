//
//  IFNetClient.swift
//  ViewTest
//
//  Created by Ifeng科技 on 2020/5/19.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import HandyJSON
protocol ClientRequestConvertible {
    
    func createRequestAddress(host: String) -> String
    func createRequestParamter() -> IFNetService.RequestParameters
}



class IFNetClient {
    
    
    static let host = "http://fangcun.ifeng-tech.com"
    
    func getRequest<T:HandyJSON>(with request:ClientRequestConvertible ,
                                 modelType:T.Type,
                                 success: @escaping (T) -> Void,
                                 fail:  @escaping IFNetService.FailHandler)  {
        
        let requestAddress =  request.createRequestAddress(host: IFNetClient.host)
        let para = request.createRequestParamter()
        
        
        IFNetService.shared.getRequest(with: requestAddress, parameters: para, success: { (data) in
            
            if let data = T.deserialize(from: data) {
                DispatchQueue.main.async {
                    success(data)
                }
                
            } else {
                debugPrint("\(requestAddress) HandyJSON 数据解析错误")
            }
            
        }) { (error) in
            DispatchQueue.main.async {
                fail(error)
            }
        }
    }
    
    func postRequest<T:HandyJSON>(with request:ClientRequestConvertible ,
                                  modelType:T.Type,
                                  success: @escaping (T) -> Void,
                                  fail:  @escaping IFNetService.FailHandler)  {
        
        let requestAddress =  request.createRequestAddress(host: IFNetClient.host)
        let para = request.createRequestParamter()
        
               
        
        IFNetService.shared.postRequest(with: requestAddress, parameters: para, success: { (data) in
            
            if let data = T.deserialize(from: data) {
                
               DispatchQueue.main.async {
                    success(data)
                }
                
            } else {
                debugPrint("\(requestAddress) HandyJSON 错误")
            }
            
        }) { (error) in
            DispatchQueue.main.async {
                           fail(error)
            }
        }
    }
    
}
