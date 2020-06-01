//
//  GKRequests.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/21.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import HandyJSON

//MARK:-  Rank

enum GKUserState :Int, HandyJSONEnum{
    case boy = 1
    case girl = 2
}

struct GKRankModel:HandyJSON {
    
    var _id: String?
    var collapse: String?
    var cover: String?
    var monthRank: String?
    var shortTitle: String?
    var title: String?
    var totalRank: String?
    var select: Bool?
    var rankSort: Int?
}

struct RankInfo : HandyJSON{
    var state: GKUserState?
    var listBoys:[GKRankModel]?
    var listGirls:[GKRankModel]?
    var picture: [GKRankModel]?
    var epub: [GKRankModel]?
    var listData: [GKRankModel]? {
        switch state {
        case .boy:
            return self.listBoys
        case .girl:
            return self.listGirls
        case .none:
            return nil
            
        }
    }
    
   mutating func mapping(mapper: HelpingMapper) {
        // specify 'cat_id' field in json map to 'id' property in object
        mapper <<<
            self.listGirls <-- "female"
    
       mapper <<<
            self.listBoys <-- "male"
            
    }
    
}



struct RankRequest: Request {
    var path: String = "ranking/gender"
     
    var method: HTTPMethod = .GET
    
    var parameters: [String : Any]? = nil
    
     func send(success:@escaping (RankInfo) -> Void , fail: @escaping (Error) -> Void) {
           
        convenientSend(request: self, success: { (model:RankInfo) in
            success(model)
        }, fail: fail)
           
    }
    
}

//MARK: - 
