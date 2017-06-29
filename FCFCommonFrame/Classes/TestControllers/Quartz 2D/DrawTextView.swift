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
    func drawTextViewDeleteBtnCLicked(textView:DrawTextView,index:Int)
    func drawTextViewSureBtnCLicked(textView:DrawTextView,index:Int)
    func drawTextViewPullToNewPosition(textView:DrawTextView,index:Int,oldCenterPoint:CGPoint,newCenterPoint:CGPoint)
}

class DrawTextView: UITextView {
    //应该要保存自己的原点、大小、旋转角度等相关信息，待续
    var btnDelegate:DrawTextViewDelegate?
    var index:Int = -1 //在数组中的下标
    var beginRotatePoint:CGPoint?
    init(frame: CGRect,index:Int) {
        super.init(frame: frame, textContainer: nil)
        self.index = index
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
        self.clipsToBounds = false
        self.layer.masksToBounds = true
        self.inputAccessoryView = self.inputAccessoryV
        self.isScrollEnabled = false //禁止滚动
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5) //设置锚点
        self.addSubview(self.moveView)
        self.addSubview(self.rotateView)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(toush))
        self.addGestureRecognizer(panGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.text != "" {
            self.moveView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width-self.frame.size.height, height: self.frame.size.height)
            self.rotateView.frame = CGRect(x: self.frame.size.width-self.frame.size.height, y: 0, width: self.frame.size.height, height: self.frame.size.height)
        }
    }
    
    lazy var inputAccessoryV: UIView? = {
        let bgView:UIView = UIView(frame:CGRect(x: 0, y: 0, width: ContentWidth, height: 40))
        bgView.backgroundColor = UIColor.lightGray
        bgView.addSubview(self.deletBtn)
        bgView.addSubview(self.textView)
        bgView.addSubview(self.sureBtn)
        return bgView
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
    
    lazy var textView:UITextView = {
        let tv:UITextView = UITextView(frame: CGRect(x: 10 + 30, y: 2, width: ContentWidth - 20 - 60, height: 36))
        tv.backgroundColor = UIColor.lightGray
        tv.textColor = UIColor.white
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    lazy var rotateView:UIImageView = {
        let imgv:UIImageView = UIImageView(frame: CGRect(x: self.frame.size.width-self.frame.size.height, y: 0, width: self.frame.size.height, height: self.frame.size.height))
        imgv.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        imgv.contentMode = .scaleAspectFill
        imgv.image = UIImage(named: "rotateHand")
        self.beginRotatePoint = imgv.center
        return imgv
    }()
    
    lazy var moveView:UIImageView = {
        let moveV:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width-self.frame.size.height, height: self.frame.size.height))
        moveV.backgroundColor = UIColor.clear
        
        return  moveV
    }()
    
    func toush(recognizer:UISwipeGestureRecognizer){
        let touchPoint = recognizer.location(in: self)
        if self.moveView.frame.contains(touchPoint) {
            self.move(recognizer: recognizer)
        }else if self.rotateView.frame.contains(touchPoint){
            self.rotated(recognizer: recognizer)
        }
    }
    
    func move(recognizer:UISwipeGestureRecognizer){
        let oldCenter = self.center
        let newCenterPoint = recognizer.location(in: self.superview)
        self.center = newCenterPoint
        if oldCenter != self.center {
            self.btnDelegate?.drawTextViewPullToNewPosition(textView: self, index: self.index, oldCenterPoint: oldCenter, newCenterPoint: self.center)
        }
    }
    
    func rotated(recognizer:UISwipeGestureRecognizer){
        let touchPoint = recognizer.location(in: self.superview)
        let oldCenter = self.frame.origin
        self.layer.anchorPoint = CGPoint(x: 0, y:0)
        self.transform = CGAffineTransform(rotationAngle:self.computeAngle(archoldP: oldCenter,oldTouchPoint: beginRotatePoint!,touchPoint: touchPoint))
        self.layer.anchorPoint = CGPoint(x: 0.5, y:0.5)
    }
    
    func deleteBtnClicked() {
        self.btnDelegate?.drawTextViewDeleteBtnCLicked(textView: self, index: self.index)
    }
    
    func sureBtnClicked(){
        self.btnDelegate?.drawTextViewSureBtnCLicked(textView: self, index: self.index)
    }
    
    func remove(){
        self.rotateView.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func computeAngle(archoldP:CGPoint,oldTouchPoint:CGPoint,touchPoint:CGPoint)->CGFloat{
        
        let v1 = CGVector(dx: oldTouchPoint.x - archoldP.x, dy: oldTouchPoint.y - archoldP.y)
        let v2 = CGVector(dx: touchPoint.x - archoldP.x, dy: touchPoint.y - archoldP.y)
        let angle = atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)
        return angle
    }
    
}

extension DrawTextView{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
