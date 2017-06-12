//
//  LabelTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/9.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class LabelTestController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UILabel和富文本"
        
        let label = UILabel.init(frame: CGRect.init(x: 10, y: 50, width: ContentWidth-20, height: 200))
        label.backgroundColor = UIColor.lightGray
        label.textColor = UIColor.black
        label.text = "swift基础控件学习之UILabel balabablababalabalabalabla"
        view.addSubview(label)
        
        label.textAlignment = .center
        label.shadowColor = UIColor.gray
        label.shadowOffset = CGSize.init(width: 1.5, height: 1.5)
        label.font = UIFont.init(name: "Zapfino", size: 15)
        
        label.lineBreakMode = .byWordWrapping //截去多余部分不显示省略号，(byTruncatingHead 隐藏头部并显示省略号;byTruncatingTail 隐藏尾部并显示省略号;byTruncatingMiddle 隐藏中间并显示省略号)
        label.numberOfLines = 0 //无限行
        
        let label2 = UILabel.init(frame: CGRect.init(x: 10, y: 400, width: ContentWidth-20, height: 200))
        //富文本
        let attributeString = NSMutableAttributedString.init(string: "swift基础控件学习之UILabel balabablababalabalabalabla")
        attributeString.addAttribute(NSFontAttributeName, value: UIFont.init(name: "Zapfino", size: 15) ?? UIFont.systemFont(ofSize: 15), range: NSMakeRange(0, 5))
        attributeString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.red, range: NSMakeRange(10, 12))
        attributeString.addAttributes([NSStrikethroughStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue,NSBaselineOffsetAttributeName:0], range: NSMakeRange(6, 10))
        label2.attributedText = attributeString
        view.addSubview(label2)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
