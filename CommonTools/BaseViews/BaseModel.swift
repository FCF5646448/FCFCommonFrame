//
//  BaseModel.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/18.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit
import ObjectMapper

class BaseModel: NSObject,Mappable {
    
    override init(){
        super.init()
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
    }
}
