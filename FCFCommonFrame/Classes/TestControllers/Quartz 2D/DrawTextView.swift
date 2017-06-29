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
    func drawTextViewDeleteBtnCLicked(drawTextView:DrawTextView,index:Int)
    func drawTextViewSureBtnCLicked(drawTextView:DrawTextView,index:Int,textStr:String)
    func drawTextViewPullToNewPosition(drawTextView:DrawTextView,index:Int,oldCenterPoint:CGPoint,newCenterPoint:CGPoint)
    func drawTextViewRotated(drawTextView:DrawTextView,index:Int,touchPoint:CGPoint)
    func drawTextViewRotated(drawTextView:DrawTextView,index:Int,rotated:Bool)
}

class DrawTextView:UIView {
    var strokeWidth:CGFloat = 1.0 //画笔宽度，默认1.0
    var strockColor:String = "000000" //画笔颜色,默认黑色
    //应该要保存自己的原点、大小、旋转角度等相关信息，待续
    var btnDelegate:DrawTextViewDelegate?
    var touchBenPoint:CGPoint?
    var index:Int = -1 //在数组中的下标
    init(frame: CGRect,index:Int,color:String,strokewidth:CGFloat) {
        super.init(frame: frame)
        let oldFrame = self.frame
        self.layer.anchorPoint = CGPoint(x: 0, y: 0)
        self.frame = oldFrame
        self.strokeWidth = strokewidth
        self.strockColor = color
        self.index = index
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.addSubview(self.textView)
        self.textView.delegate = self
        self.addSubview(self.rotateView)
        self.textView.textColor = UIColor.haxString(hex:color)
        self.textView.font = UIFont.systemFont(ofSize:strokewidth)
        self.textView.becomeFirstResponder()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(move))
        self.addGestureRecognizer(panGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    lazy var textView:UITextView = {
        let textV:UITextView = UITextView(frame: CGRect(x: 2, y: 2, width: self.frame.width-40, height: self.frame.height - 4))
        textV.backgroundColor = UIColor.clear
        textV.layer.borderWidth = 0.5
        textV.layer.borderColor = UIColor.gray.cgColor
        textV.layer.cornerRadius = 4
        textV.layer.masksToBounds = true
        textV.inputAccessoryView = self.inputAccessoryV
        textV.isScrollEnabled = false
        return textV
    }()
    
    lazy var inputAccessoryV: UIView? = {
        let bgView:UIView = UIView(frame:CGRect(x: 0, y: 0, width: ContentWidth, height: 40))
        bgView.backgroundColor = UIColor.lightGray
        bgView.addSubview(self.deletBtn)
        bgView.addSubview(self.showTextV)
        bgView.addSubview(self.sureBtn)
        return bgView
    }()
    
    lazy var showTextV:UITextView = {
        let tv:UITextView = UITextView(frame: CGRect(x: 10 + 30, y: 2, width: ContentWidth - 20 - 60, height: 36))
        tv.backgroundColor = UIColor.lightGray
        tv.textColor = UIColor.white
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    lazy var deletBtn:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        btn.setTitle("删除", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(deleteBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    lazy var sureBtn:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect(x: ContentWidth-35, y: 5, width: 30, height: 30)
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(sureBtnClicked), for: .touchUpInside)
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        return btn
    }()
    
    lazy var rotateView:UIButton = {
        let imgbtn:UIButton = UIButton(frame: CGRect(x: self.frame.size.width-30, y: (self.frame.size.height-30)/2, width: 30, height: 30))
        imgbtn.setImage(UIImage(named: "rotate"), for: .normal)
        imgbtn.layer.cornerRadius = 4
        imgbtn.layer.masksToBounds = true
        imgbtn.addTarget(self, action: #selector(rotatedBtnClicked), for: .touchUpInside)
        return imgbtn
    }()
    
    func rotatedBtnClicked(sender:AnyObject){
        self.textView.resignFirstResponder()
        var selected = false
        if self.backgroundColor == UIColor.clear {
            //未选中状态，变成选中状态，可以旋转
            selected = true
            self.textView.backgroundColor = UIColor.lightGray
            self.backgroundColor = UIColor.gray
        }else{
            //选中状态,变成未选中状态
            selected = false
            self.textView.backgroundColor = UIColor.clear
            self.backgroundColor = UIColor.clear
        }
        self.btnDelegate?.drawTextViewRotated(drawTextView: self, index: self.index, rotated: selected)
    }
    
    func move(recognizer:UISwipeGestureRecognizer){
        let oldCenter = self.center
        var newCenterPoint:CGPoint?
        switch recognizer.state {
        case .began:
            touchBenPoint = recognizer.location(in: self.superview)
        default:
            newCenterPoint = recognizer.location(in: self.superview)
        }
        let touch = recognizer.location(in: self)
        if (touchBenPoint != nil && newCenterPoint != nil && self.textView.frame.contains(touch)) {
            let newPoint = newCenterPoint!
            let bengin = touchBenPoint!
            let move:(x:CGFloat,y:CGFloat) = (newPoint.x-bengin.x,newPoint.y-bengin.y)
            let newCenter:CGPoint = CGPoint(x: oldCenter.x + move.x, y: oldCenter.y + move.y)
            UIView.animate(withDuration: 0, animations: { 
                self.center = newCenter
            })
            
            if oldCenter != self.center {
                self.btnDelegate?.drawTextViewPullToNewPosition(drawTextView: self, index: self.index, oldCenterPoint: oldCenter, newCenterPoint: newCenter)
            }
        }
    }
    
    func setRotatedAngle(angle:CGFloat){
        self.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    func deleteBtnClicked() {
        self.btnDelegate?.drawTextViewDeleteBtnCLicked(drawTextView: self, index: self.index)
    }
    
    func sureBtnClicked(){
        self.btnDelegate?.drawTextViewSureBtnCLicked(drawTextView: self, index: self.index,textStr:self.textView.text)
    }
    
    func remove(){
        self.rotateView.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DrawTextView:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView){
        if textView.text != "" {
            //将输入的文字显示在inputAccessoryView上
            self.showTextV.font = UIFont.systemFont(ofSize: self.strokeWidth)
            showTextV.textColor = UIColor.haxString(hex: self.strockColor)
            showTextV.text = textView.text
            let bottom = showTextV.contentSize.height - showTextV.bounds.size.height
            showTextV.setContentOffset(CGPoint(x: 0, y: bottom), animated: true)
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}
