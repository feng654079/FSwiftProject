//
//  HandyJSONTests.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2019/10/29.
//  Copyright © 2019 Ifeng科技. All rights reserved.
//

import Foundation
import HandyJSON

class AModel:HandyJSON {
    var aaa:NSString = ""
    
    required init() {}
}

struct AStruct: HandyJSON {
    var int: Int = 0
    var doubleOptional: Double?
    var stringImplicitlyUnwrapped: String!
}

enum AnimalType:String,HandyJSONEnum {
    case Cat = "cat"
    case Dog = "dog"
    case Bird = "bird"
}

struct Animal: HandyJSON {
    var name: String?
    var type: AnimalType?
}

class BModel: HandyJSON {
    var bool: Bool = true
    var intOptional: Int?
    var doubleImplicitlyUnwrapped: Double!
    var anyObjectOptional: Any?
    
    var arrayInt: Array<Int> = []
    var arrayStringOptional: Array<String>?
    var setInt: Set<Int>?
    var dictAnyObject: Dictionary<String,Any> = [:]
    
    var nsNumber = 2
    var nsString: NSString?
    
    required init() {}
}


class Cat :HandyJSON {
    var id: Int64!
    var name: String!
    
    required init() {}
}

class Component: HandyJSON {
    var  aInt: Int?
    var  aString: String?
    
    required init() {}
}

class Composition: HandyJSON {
    var aInt: Int?
    var comp1: Component?
    var comp2: Component?
    required init() {}
}

class Animal_c: HandyJSON {
    var id: String?
    var color: String?
    
    required init() {}
}

class Cat_c: Animal_c {
    var name: String?
    required init() {}
}

class Cat_c1: HandyJSON {
    var name: String?
    var id: String?
    
    required init() {}
}

class Cat_c2: HandyJSON {
    var id: Int64!
    var name: String!
    var parent: (String,String)!
    var friendName: String?
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        
        mapper <<< self.id <-- "cat_id"
        
        mapper <<<
            self.parent <-- TransformOf<(String,String),String> (fromJSON: { (rawString) -> (String, String)? in
                if let parntNames = rawString?.split(separator: "/").map(String.init) {
                    return (parntNames[0],parntNames[1])
                }
                return nil
            }, toJSON: { (tuple) -> String? in
                if let _tuple = tuple {
                    return "\(_tuple.0)/\(_tuple.1)"
                }
                return nil
            })
        
        mapper <<< self.friendName <-- "friend.name"
        
    }
}

class ExtendType: HandyJSON {
    var date: Date?
    var decimal: NSDecimalNumber?
    var url: URL?
    var data: Data?
    var color: UIColor?
    
    public required init() {}
    
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            date <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd")
        
        mapper <<<
            decimal <-- NSDecimalNumberTransform()
        
        mapper <<<
            url <-- URLTransform(shouldEncodeURLString: false)
        
        mapper <<<
            data <-- DataTransform()
        
        mapper <<<
            color <-- HexColorTransform()
    }
    
}


class NotHandyJSONType {
    var dummy: String?
}

class Cat_c3: HandyJSON {
    var id: Int64!
    var name: String!
    var notHandyJSONTypeProperty: NotHandyJSONType?
    var basicTypeButNotWantedProperty: String?
    
    required init() {}
    
    func  mapping(mapper: HelpingMapper) {
        mapper >>> self.notHandyJSONTypeProperty
        mapper >>> self.basicTypeButNotWantedProperty
    }
}

class BasicTypes: HandyJSON {
    var int: Int = 2
    var doubleOptional : Double?
    var stringImplicitlyUnwrapped: String!
    
    required init() {}
}


func HandyJSONTestCases() {
    do {
        let jsonString = "{\"aaa\":\"aaa\"}"
        if let obj = AModel.deserialize(from: jsonString) {
            print(obj)
        }
        
    }
    
    do {
        let jsonString = "{\"doubleOptional\":1.1,\"stringImplicitlyUnwrapped\":\"hello\",\"int\":1}"
        if let obj = AStruct.deserialize(from: jsonString) {
            print(obj)
        }
        
    }
    
    do {
        let jsonString = "{\"type\":\"cat\",\"name\":\"Tom\"}"
        if let obj = Animal.deserialize(from: jsonString) {
            print(obj)
        }
        
    }
    
    
    do {
        let object = BModel()
        object.intOptional = 1
        object.doubleImplicitlyUnwrapped = 1.0
        object.anyObjectOptional = "StringValue"
        object.arrayInt = [1,2]
        object.arrayStringOptional = ["a","b"]
        object.setInt = [1,2]
        object.dictAnyObject = ["key1":1 ,"key2": "string value"]
        object.nsNumber = 3
        object.nsString = "nsStringValue"
        
        let jsonString = object.toJSONString()!
        print(jsonString)
        
        if let object = BModel.deserialize(from: jsonString) {
            print(object)
        }
        
    }
    
    //Designated Path
    do {
        let jsonString = "{\"code\":200,\"msg\":\"success\",\"data\":{\"cat\":{\"id\":12345,\"name\":\"Kitty\"}}}"
        if let cat = Cat.deserialize(from: jsonString, designatedPath: "data.cat") {
            print(cat.name)
        }
    }
    
    //对象的组合
    do {
        let jsonString = "{\"num\":12345,\"comp1\":{\"aInt\":1,\"aString\":\"aaaaa\"},\"comp2\":{\"aInt\":2,\"aString\":\"bbbbb\"}}"
        
        if let object = Composition.deserialize(from: jsonString) {
            print(object.comp1?.aString)
        }
    }
    
    //
    do {
        let jsonString = "{\"id\":12345,\"color\":\"black\",\"name\":\"cat\"}"
        if let obj = Cat_c.deserialize(from: jsonString) {
            print(obj)
        }
    }
    
    do {
        let jsonArrayString: String? = "[{\"name\":\"Bob\",\"id\":\"1\"}, {\"name\":\"Lily\",\"id\":\"2\"}, {\"name\":\"Lucy\",\"id\":\"3\"}]"
        if let cats = [Cat_c1].deserialize(from: jsonArrayString) {
            cats.forEach { (cat) in
                print("cat.name:\(cat?.name)")
            }
        }
    }
    
    
    do {
        var dict = [String:Any]()
        dict["doubleOptional"] = 1.1
        dict["doubleOptional"] = 1.1
        dict["stringImplicitlyUnwrapped"] = "hello"
        dict["int"] = 1
        if let object = AStruct.deserialize(from: dict) {
            print(object)
        }
    }
    
    do {
        //custom mapping 牛逼
        let jsonString = "{\"cat_id\":12345,\"name\":\"Kitty\",\"parent\":\"Tom/Lily\",\"friend\":{\"id\":54321,\"name\":\"Lily\"}}"
        if let cat = Cat_c2.deserialize(from: jsonString) {
            print(cat.id)
            print(cat.parent)
            print(cat.friendName)
        }
    }
    
    do {
        
        let object = ExtendType()
        object.date = Date()
        object.decimal = NSDecimalNumber(string: "1.21564324543121389878")
        object.url = URL(string: "https://www.baidu.com")
        object.data = Data(base64Encoded: "aGVsbG8sIHdvcmxkIQ==")
        object.color = UIColor.blue
        
        print(object.toJSONString()!)
        let mappedObject = ExtendType.deserialize(from: object.toJSONString()!)!
        print(mappedObject.date)
        
    }
    
    do {
        
        let jsonString = "{\"name\":\"cat\",\"id\":\"12345\"}"
        
        if let cat = Cat_c3.deserialize(from: jsonString) {
            print(cat)
        }
    }
    
    do {
        // update existing model
        var object = BasicTypes()
        object.int = 1
        object.doubleOptional = 1.1
        
        let jsonString = "{\"doubleOptional\":2.2}"
        JSONDeserializer.update(object: &object, from: jsonString)
        print(object.int)
        print(object.doubleOptional)
    }
    
    
}

