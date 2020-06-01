//
//  Models.swift
//  ViewTest
//
//  Created by Ifeng科技 on 2020/5/19.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
import HandyJSON

//@objc(Commodity)
final class GoodsDetailCommodity :NSObject ,HandyJSON{
    var isHot: NSNumber?
    var goodsCode: String?
    var commName: String?
    var deleteStatus: NSNumber?
    var goodsName: String?
    var maxPrice: NSNumber?
    var goodsImage: String?
    var commodityDescribe: String?
    var hot: NSNumber?
    var isCollect: NSNumber?
    var commodityName: String?
    var commodityDetails: String?
    var backgroundImg: String?
    var type: String?
    var state: NSNumber?
    var whetherInput: String?
    var id: NSNumber?
    var addTime: NSNumber?
    var num: NSNumber?
    var commodityLink: String?
    var regex: String?
    var commodityCode: String?
    var versionType: String?
    var commodityDescription: String?
    var minPrice: NSNumber?
    var currentPrice: NSNumber?
    var firstCategoryId: String?
    var categoryId: NSNumber?
    var commCode: String?
    
}
//@objc(data)
final class GoodsDetailData :NSObject ,HandyJSON{
    var commodity: GoodsDetailCommodity?
    
    
    func mapping(mapper: HelpingMapper) {
        // specify 'cat_id' field in json map to 'id' property in object
        mapper <<<
            self.commodity <-- "Commodity"
        
    }
    
}
//@objc(WHC)
final class GoodsDetailModel :NSObject ,HandyJSON  {
    var message: String?
    var data: GoodsDetailData?
    var code: String?
}




//MARK: -
