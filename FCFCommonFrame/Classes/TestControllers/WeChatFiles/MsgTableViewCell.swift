//
//  MsgTableViewCell.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/19.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class MsgTableViewCell: BaseTableViewCell {
    //消息内容视图
    var customView:UIView!
    
    //消息背景
    var bubbleImage:UIImageView!
    
    //头像
    var avatarImage:UIImageView!
    
    //消息结构体
    var msgItem:MessageItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func rebuildUserInterface(data:MessageItem){
        clearnSubVies()
        
        self.msgItem = data
//        if self.bubbleImage == nil {
            self.bubbleImage = UIImageView()
            self.addSubview(self.bubbleImage)
//        }
        
        let type = self.msgItem.mtype
        let width = self.msgItem.view.frame.size.width
        let height = self.msgItem.view.frame.size.height
        var x = (type == .someone) ? 0 : self.frame.size.width - width - self.msgItem.insets.left - self.msgItem.insets.right
        var y:CGFloat = 0
        //显示头像
        if self.msgItem.user.username != "" {
            let thisUser = self.msgItem.user
            
            self.avatarImage = UIImageView.init(image: UIImage.init(named: (thisUser.avatar != "" ? thisUser.avatar : "defaultHeadImg.png")))
            self.avatarImage.layer.cornerRadius = 9.0
            self.avatarImage.layer.masksToBounds = true
            self.avatarImage.layer.borderWidth = 1.0
            self.avatarImage.layer.borderColor = UIColor.init(white: 0, alpha: 0.2).cgColor
            //
            let avatarX = (type == .someone) ? 2 : self.frame.size.width - 52
            
            let avatarY:CGFloat = 0
            self.avatarImage.frame = CGRect.init(x: avatarX, y: avatarY, width: 50, height: 50)
            self.addSubview(self.avatarImage)
            
            let delta = (50 - (self.msgItem.insets.top + self.msgItem.insets.bottom + self.msgItem.view.frame.size.height))/2
            if delta > 0 {
                y = delta
            }
            if type == .someone {
                x += 54
            }
            if type == .mine {
                x -= 54
            }
        }
        self.customView = self.msgItem.view
        self.customView.frame = CGRect.init(x: x + self.msgItem.insets.left, y: y + self.msgItem.insets.top, width: width, height: height)
        self.addSubview(self.customView)
        
        if type == .someone {
            self.bubbleImage.image = UIImage.init(named: "yoububble.png")!.stretchableImage(withLeftCapWidth: 21, topCapHeight: 25)
        }else{
            self.bubbleImage.image = UIImage.init(named: "mebubble.png")!.stretchableImage(withLeftCapWidth: 15, topCapHeight: 25)
        }
        self.bubbleImage.frame = CGRect.init(x: x, y: y, width: width + self.msgItem.insets.left + self.msgItem.insets.right, height: height + self.msgItem.insets.top + self.msgItem.insets.bottom)
    }
    
    override var frame: CGRect{
        get{
            return super.frame
        }
        set(newFrame){
            var frame = newFrame
            frame.size.width = UIScreen.main.bounds.width
            super.frame = frame
        }
    }
    
    func clearnSubVies(){
        for v in subviews {
            v.removeFromSuperview()
        }
    }
}
