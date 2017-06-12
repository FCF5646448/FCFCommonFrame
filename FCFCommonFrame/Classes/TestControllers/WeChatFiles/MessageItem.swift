//
//  MessageItem.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/19.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit
import ObjectMapper

class UserInfo: BaseModel {
    var username:String = ""
    var avatar:String = ""
    override func mapping(map: Map) {
        username <- map["username"]
        avatar <- map["avatar"]
    }
}

enum ChatType{
    case mine
    case someone
}

class MessageItem {
    var user:UserInfo //用户信息
    var date:Date //消息时间
    var mtype:ChatType
    var view:UIView //内容视图 ,标签或图片
    var insets:UIEdgeInsets
    //设置我的文本消息边距
    class func getTextInsetsMine()->UIEdgeInsets{
        return UIEdgeInsets.init(top: 5, left: 10, bottom: 11, right: 17)
    }
    //设置他人的文本消息边距
    class func getTextInsetsSomeone()->UIEdgeInsets{
        return UIEdgeInsets.init(top: 5, left: 15, bottom: 11, right: 10)
    }
    //设置我的图片消息边距
    class func getImageInsetsMine()->UIEdgeInsets{
        return UIEdgeInsets.init(top: 11, left: 13, bottom: 16, right: 22)
    }
    //设置他人的图片消息边距
    class func getImageInsetsSomeone()->UIEdgeInsets{
        return UIEdgeInsets.init(top: 11, left: 13, bottom: 16, right: 22)
    }
    
    init(user:UserInfo,date:Date,mtype:ChatType,view:UIView,insets:UIEdgeInsets)
    {
        self.user = user
        self.date = date
        self.mtype = mtype
        self.view = view
        self.insets = insets
    }
    
    //构建文本消息体
    convenience init(body:String = "",user:UserInfo,date:Date,mtype:ChatType){
        let font = UIFont.boldSystemFont(ofSize: 12)
        let width = 225,height = 10000.0
        let atts = [NSFontAttributeName:font]
        let size = (body as NSString).boundingRect(with: CGSize(width: CGFloat(width), height: CGFloat(height)), options: .usesLineFragmentOrigin, attributes: atts, context: nil)
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: size.size.width, height: size.size.height))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = body
        label.font = font
        label.backgroundColor = UIColor.clear
        let insets:UIEdgeInsets = (mtype == .mine ? MessageItem.getTextInsetsMine() : MessageItem.getTextInsetsSomeone())
        self.init(user:user,date:date,mtype:mtype,view:label,insets:insets)
    }
    //构建图片消息体
    convenience init(image:UIImage,user:UserInfo,date:Date,mtype:ChatType){
        var size = image.size
        //等比缩放
        if size.width > 220{
            size.height /= (size.width/220)
            size.width = 220
        }
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        imageView.image = image
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        let insets:UIEdgeInsets = (mtype == .mine ? MessageItem.getImageInsetsMine() : MessageItem.getImageInsetsSomeone())
        self.init(user:user,date:date,mtype:mtype,view:imageView,insets:insets)
    }
}
