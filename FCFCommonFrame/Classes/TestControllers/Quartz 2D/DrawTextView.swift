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
protocol DrawTextViewDelegate{
    func drawTextViewDeleteBtnCLicked(textView:DrawTextView)
    func drawTextViewSureBtnCLicked(textView:DrawTextView)
}

class DrawTextView: UITextView {
    //应该要保存自己的原点、大小、旋转角度等相关信息，待续
    var btnDelegate:DrawTextViewDelegate?
    init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.masksToBounds = true
        self.returnKeyType = .done
        self.inputAccessoryView = self.inputAccessoryV
    }
    
    lazy var inputAccessoryV: UIView? = {
        let bgView:UIView = UIView(frame:CGRect(x: 0, y: 0, width: ContentWidth, height: 40))
        bgView.backgroundColor = UIColor.lightGray
        //
        bgView.addSubview(self.deletBtn)
        bgView.addSubview(self.textView)
        bgView.addSubview(self.sureBtn)
        return bgView
    }()
    
    lazy var deletBtn:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        btn.setTitle("删除", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(deleteBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    lazy var sureBtn:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect(x: ContentWidth-35, y: 5, width: 30, height: 30)
        btn.setTitle("确定", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(sureBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    lazy var textView:UITextView = {
        let tv:UITextView = UITextView(frame: CGRect(x: 10 + 30, y: 2, width: ContentWidth - 20 - 60, height: 36))
        tv.backgroundColor = UIColor.lightGray
        tv.textColor = UIColor.white
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    func deleteBtnClicked() {
        self.btnDelegate?.drawTextViewDeleteBtnCLicked(textView: self)
    }
    
    func sureBtnClicked(){
        self.btnDelegate?.drawTextViewSureBtnCLicked(textView: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
