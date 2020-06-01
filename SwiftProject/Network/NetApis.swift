//
//  NetApis.swift
//  ViewTest
//
//  Created by Ifeng科技 on 2020/5/19.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation

enum NetApis: ClientRequestConvertible {
    
    case login(username:String,password:String)
    case goodDetails(goodsCode:String)
    
    
    func createRequestAddress(host: String) -> String {
        switch self {
        case .login(_,_):
            return host + "/otc-front/login"
            
        case .goodDetails(_):
            return host + "/otc-front/goods/getGoodsDetails"
        }
    }
    
    
    func createRequestParamter() -> IFNetService.RequestParameters {
        switch self {
            
        case .login(let username, let password):
            return ["username":username ,"password":password ]
            
        case .goodDetails(let goodCode):
            return ["goodsCode":goodCode]
        }
    }
    
    
}
