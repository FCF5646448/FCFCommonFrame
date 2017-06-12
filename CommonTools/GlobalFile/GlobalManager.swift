//
//  GlobalManager.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/4/17.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit
import AdSupport

@objc class GlobalManager: NSObject {
    
    class var sharedInstance:GlobalManager {
        struct Static{
            static var instance:GlobalManager = GlobalManager()
        }
        return Static.instance
    }
    
    class func getidfv()->String?{
        return UIDevice.current.identifierForVendor?.uuidString
    }
    class func getidfa()->String?{
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    //获取版本号
    class func getAppVersion() -> String? {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    }
    
}
