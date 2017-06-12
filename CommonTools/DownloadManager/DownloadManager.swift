//
//  DownloadManager.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/4/17.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit
import Alamofire

enum RequestResultType:Int {
    case error_NetWork = -2
    case error_Data = -1
    case success = 0
}

class DownloadManager: NSObject {
    //这里添加固定的请求信息，如版本号
    class func appendBaseParamsToDictionary() -> [String:AnyObject]? {
        var params = [String:AnyObject]()
        params["ver"] = GlobalManager.getAppVersion() as AnyObject
        return params
    }
    //Get下载
    class func DownloadGet(host:String?=nil,path:String?=nil,params:[String:AnyObject]?=nil,timeout:TimeInterval? = 5,cache:Bool? = false,progress:((_ progress:Float)->Void)?=nil,successed:@escaping (_ JSONString:String?)->Void,failed:@escaping (_ error:NSError?)->Void){
        if host == nil  && path == nil {
            return
        }
        var url:String?
        if host != nil{
            url = String(format: "%@?%@", host!,path!)
        }else{
            url = String(format: "%@", path!)
        }
        var param = DownloadManager.appendBaseParamsToDictionary()
        if params != nil && param != nil {
            for (key,value) in params! {
                param![key] = value
            }
        }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = timeout!
        manager.session.configuration.timeoutIntervalForResource = timeout!
        manager.request(url!, method: .get, parameters: param).downloadProgress { (progre) in
            DispatchQueue.main.async {
                if progress != nil {
                    progress!(Float(progre.fractionCompleted))
                }
            }
        }.responseString { (response) in
            print("response:\(response.response)")
            print("data:\(response.data)")
            switch response.result{
            case .success(_):
                successed(response.result.value)
                break
            case .failure(let error):
                failed(error as NSError?)
                break
            }
        }
    }
    //Post
    class func DownloadPost(host:String?=nil,path:String?=nil,params:[String:AnyObject]?=nil,timeout:TimeInterval? = 5,cache:Bool? = false,progress:((_ progress:Float)->Void)?=nil,successed:@escaping (_ JSONString:String?)->Void,failed:@escaping (_ error:NSError?)->Void){
        if host == nil  && path == nil {
            return
        }
        var url:String?
        if host != nil{
            url = String(format: "%@?%@", host!,path!)
        }else{
            url = String(format: "%@", path!)
        }
        var param = DownloadManager.appendBaseParamsToDictionary()
        if params != nil && param != nil {
            for (key,value) in params! {
                param![key] = value
            }
        }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = timeout!
        manager.session.configuration.timeoutIntervalForResource = timeout!
        manager.upload(multipartFormData: { (multipartFormData) in
            for (key,value) in param! {
                multipartFormData.append(value.data(using:String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to: url!) { (encodingResult) in
            switch encodingResult {
            case .success(let upload,_,_):
                upload.uploadProgress(closure: { (progre) in
                    DispatchQueue.main.async {
                        if progress != nil {
                            progress!(Float(progre.fractionCompleted))
                        }
                    }
                })
                upload.responseString(completionHandler: { (response) in
                    print("response:\(response.response)")
                    print("data:\(response.data)")
                    switch response.result{
                    case .success(_):
                        successed(response.result.value)
                        break
                    case .failure(let error):
                        failed(error as NSError?)
                        break
                    }
                })
                break
            case .failure(let error):
                failed(error as NSError?)
                break
            }
        }
    }
    //上传图片
    class func DownloadPostPic(host:String?=nil,path:String?=nil,params:[String:AnyObject]?=nil,type:String?=nil,fileDatas:[(key:String,data:Data,keyname:String)]?=nil,timeout:TimeInterval?=5,cache:Bool?=false,progress:((_ progress:Float)->Void)?=nil,successed:@escaping (_ JSONString:String?)->Void,failed:@escaping (_ error:NSError?)->Void){
        if host == nil && path == nil {
            return
        }
        var url:String?
        if host != nil{
            url = String(format: "%@?%@", host!,path!)
        }else{
            url = String(format: "%@", path!)
        }
        var param = DownloadManager.appendBaseParamsToDictionary()
        if params != nil && param != nil {
            for (key,value) in params! {
                param![key] = value
            }
        }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = timeout!
        manager.session.configuration.timeoutIntervalForResource = timeout!
        manager.upload(multipartFormData: { (multipartFormatData) in
            for (key,value) in param! {
                multipartFormatData.append(value.data(using:String.Encoding.utf8.rawValue)!, withName: key)
            }
            if fileDatas != nil {
                for (key,data,keyname) in fileDatas! {
                    multipartFormatData.append(data, withName: keyname, fileName: key, mimeType: type!)
                }
            }
        }, to: url!) { (encodingResult) in
            switch encodingResult{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progre) in
                    DispatchQueue.main.async {
                        if progress != nil {
                            progress!(Float(progre.fractionCompleted))
                        }
                    }
                })
                upload.responseString(completionHandler: { (response) in
                    print("response:\(response.response)")
                    print("data:\(response.data)")
                    switch response.result{
                    case .success(_):
                        successed(response.result.value)
                        break
                    case .failure(let error):
                        failed(error as NSError?)
                        break
                    }
                })
                break
            case .failure(let error):
                failed(error as NSError)
                break
            }
        }
    }
}
