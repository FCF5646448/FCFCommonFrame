//
//  TextViewExtension.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/15.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import Foundation

extension UITextView{
    func appendLinkString(string:String,withURLString:String = "") {
        //原来内容
        let attrString:NSMutableAttributedString = NSMutableAttributedString()
        attrString.append(self.attributedText)
        //
        let attrs = [NSFontAttributeName:self.font ?? UIFont.systemFont(ofSize: 13)]
        let appendString = NSMutableAttributedString.init(string: string, attributes: attrs)
        
        if withURLString != "" {
            let range:NSRange = NSMakeRange(0, appendString.length)
            appendString.beginEditing()
            appendString.addAttribute(NSLinkAttributeName,value:withURLString,range:range)
            appendString.endEditing()
        }
        
        attrString.append(appendString)
        
        self.attributedText = attrString
        
    }
}
