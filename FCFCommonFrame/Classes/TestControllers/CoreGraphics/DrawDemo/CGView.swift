//
//  CGView.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/7/5.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class CGView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //获取到上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        //基础设置
        context.setStrokeColor(UIColor.red.cgColor) //颜色
        context.setLineWidth(6) //画笔宽度
        context.setLineJoin(.round) //连接点样式
        context.setLineCap(.round) //端点样式
        context.setShadow(offset: CGSize(width: 1, height: 2), blur: 0.6, color: UIColor.lightGray.cgColor) //阴影 blur模糊度
        
        //创建路径
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 30, y: 30)) //起点
        path.addLine(to: CGPoint(x: 200, y: 200)) //线1
        path.addLine(to: CGPoint(x: 300, y: 100)) //线2
        //添加路径到图形上下文
        context.addPath(path)

        
//        每个虚线的长度与间隔
//        let lengths:[CGFloat] = [15,8] //这两个数值是虚线短线和空格的长度
//        设置虚线样式
//        context.setLineDash(phase: 0, lengths: lengths)
        
//        圆
        context.addEllipse(in: CGRect(x: 100, y: 300, width: 200, height: 200)) //这个画出来的是一个内切圆。是在Rect(100，300，200，200)内的内切圆；如果画椭圆，只需要width和height不等就可以了
        
//        矩形
        context.addRect(CGRect(x: 10, y: 100, width: 20, height: 30))
        
        
        //贝塞尔曲线
        path.move(to: CGPoint(x: 10, y: 300)) //起点
        path.addCurve(to: CGPoint(x:20,y:180), control1: CGPoint(x:40,y:320), control2: CGPoint(x:50,y:250))
        context.addPath(path)
        
        
        //绘制圆弧
        let radius = 50 //圆弧半径
        let center = CGPoint(x: 200, y: 220) //圆弧中点
        path.addArc(center: center, radius: CGFloat(radius), startAngle: 0, endAngle: CGFloat(Double.pi), clockwise: false)
        context.addPath(path)
        
        //绘制
        context.strokePath()
    }
}
