//
//  Network2Requests.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/20.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import HandyJSON
import SwiftyJSON


func convenientSend<R:Request,T:HandyJSON>(request:R, success: @escaping (T) -> Void ,fail :@escaping (Error) -> Void){
    
    Network2Client.shared.send(request) { (data, error) in
        if let error = error {
            fail(error)
            return
        }
        
        if let model = T.deserialize(from: data){
            success(model)
            return
        }
       
        fatalError("数据异常")
    }
}


struct GoodsDetailRequest : Request {
    var path: String {
        return "/otc-front/login"
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var parameters: [String : Any]? {
        return ["goodsCode":goodsCode]
    }
    
     
    var goodsCode:String
    
    func send(success:@escaping (GoodsDetailModel) -> Void , fail: @escaping (Error) -> Void) {
        
        convenientSend(request: self, success: { (model:GoodsDetailModel) in
            success(model)
        }, fail: fail)
        
    }
    
//    func send(success:@escaping (GoodsDetailModel) -> Void , fail: @escaping (Error) -> Void) {
//
//        Network2Client.shared.send(self) { (data, error) in
//               if let error = error {
//                   fail(error)
//                   return
//               }
//               if let model = GoodsDetailModel.deserialize(from: data){
//                 success(model)
//               }
//
//               fatalError("数据异常")
//           }
//    }
    
    
    
}
