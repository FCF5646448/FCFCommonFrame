//
//  UIButtonExtension.swift
//  FCFCommonTools
//
//  Created by 冯才凡 on 2017/4/7.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    //设置按钮上图片和文字的相对位置及间距：各个边界相对于原来的位置的位移，距离变大了就加，距离变小了就减。
    @objc func set(image anImage:UIImage?,title:String,titlePosition:UIViewContentMode,additionalSpacing:CGFloat,state:UIControlState){
        self.imageView?.contentMode = .center
        setImage(anImage, for: state)
        positionLabelRespectToImage(title: title, position: titlePosition, spacing: additionalSpacing)
        self.titleLabel?.contentMode = .center
        self.setTitle(title, for: state)
    }
    fileprivate func positionLabelRespectToImage(title:String,position:UIViewContentMode,spacing:CGFloat){
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font
        let titleSize = (title as NSString).size(attributes: [NSFontAttributeName: titleFont!])
        var titleInsets:UIEdgeInsets
        var imageInsets:UIEdgeInsets
        switch position {
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + spacing/2.0), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: (titleSize.height + spacing/2.0), left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + spacing/2.0), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: -(titleSize.height + spacing/2.0), left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width + spacing/2.0), bottom: 0, right: (imageSize.width + spacing/2.0))
            imageInsets = UIEdgeInsets(top: 0, left: (titleSize.width+spacing/2.0), bottom: 0, right: -(titleSize.width+spacing/2.0))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: spacing/2.0, bottom: 0, right: -spacing/2.0)
            imageInsets = UIEdgeInsets(top: 0, left: -spacing/2.0, bottom: 0, right: spacing/2.0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
}
