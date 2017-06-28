//
//  DrawTextView.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/27.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

//橡皮擦是无法擦出文本的。
//用来输入文字的文本,当选中的type是文本的时候，就将手势和边框开启，否则就隐藏起来，当切换type的时候，将空的textView移除，如果点击了文本里的移除按钮，则这个文本就相当于从整个队列里移除了出去
class DrawTextView: UITextView {
    //应该要保存自己的原点、大小、旋转角度等相关信息，待续
    init(frame: CGRect,size:CGFloat,color:String) {
        super.init(frame: frame, textContainer: nil)
        super.layoutSubviews()
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.masksToBounds = true
        self.textColor = UIColor.haxString(hex: color)
        self.font = UIFont.systemFont(ofSize: size)
        self.returnKeyType = .done
        //这里添加平移和旋转事件
    }
    
    convenience init() {
        self.init(coder: NSCoder())!
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

//    //编码成object
//    override func encode(with aCoder: NSCoder) {
//        
//    }
//    
//    //
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.backgroundColor = UIColor.clear
//        self.layer.borderWidth = 0.5
//        self.layer.borderColor = UIColor.lightGray.cgColor
//    }
//    
//    //给text添加一个旋转的线
//    func showRotateLine(){
//        
//    }
}
