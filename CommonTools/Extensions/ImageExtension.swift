//
//  ImageExtension.swift
//  FCFCommonTools
//
//  Created by 冯才凡 on 2017/4/6.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    //根据颜色值创建图片
    class func initImgWithColor(color:UIColor,size:CGSize? = nil) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 0)
        var sizetmp = rect.size
        if let s = size {
            sizetmp = s
        }
        UIGraphicsBeginImageContext(sizetmp)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: CGPoint(x: 0, y: 0), size: sizetmp))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    //由一组图片生成一张图片，类似群组里的头像，最多9张，超出9张不现实
    class func groupIcon(wh:CGFloat,images:[UIImage],bgColor:UIColor?) -> UIImage {
        let finalSize = CGSize(width: wh, height: wh)
        var rect:CGRect = CGRect.zero
        rect.size = finalSize
        //开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可
        UIGraphicsBeginImageContextWithOptions(finalSize, false, 0)
        //绘制背景
        if (bgColor != nil) {
            let context:CGContext = UIGraphicsGetCurrentContext()!
            context.addRect(rect) //添加矩形背景区域
            context.setFillColor(bgColor!.cgColor)//设置填充颜色
            context.drawPath(using: .fill)
        }
        //绘制图片
        if images.count >= 1 {
            //获取位置
            var rects = getRectsInGroupIcon(wh: wh, count: images.count)
            var count = 0
            //将每张图绘制在相应区域
            for image in images {
                if count > rects.count - 1 {
                    break
                }
                let rect = rects[count]
                image.draw(in: rect)
                count = count + 1
            }
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    //获取图片数组中每个图片的位置，这个函数是为groupIcon函数服务的
    fileprivate class func getRectsInGroupIcon(wh:CGFloat,count:Int) -> [CGRect]{
        //如果只有一张图片就占全部位置
        if count == 1 {
            return [CGRect(x: 0, y: 0, width: wh, height: wh)]
        }
        var array = [CGRect]()
        var padding:CGFloat = 10//图片间距
        var cellWH:CGFloat //小图片尺寸
        var cellCount:Int //用于后面计算的单元格数量（小于等于4张图片算4格单元格，大于4张算9格单元格）
        if count <= 4 {
            cellWH = (wh - padding * 3)/2
            cellCount = 4
        }else{
            padding = padding/2
            cellWH = (wh-padding*4)/3
            cellCount = 9
        }
        let rowCount = Int(sqrt(Double(cellCount))) //总行数
        //根据单元格长宽，间距，数量返回所有单元格初步对应的位置尺寸，这样的话，每次都会生成4个图片或者9个图片的尺寸。
        for i in 0..<cellCount {
            let row = i/rowCount //当前行
            let column = i%rowCount // 当前列
            let rect = CGRect(x: padding*CGFloat(column+1)+cellWH*CGFloat(column),
                            y: padding*CGFloat(row+1)+cellWH*CGFloat(row), width: cellWH, height: cellWH)
            array.append(rect)
        }
        //根据实际图片的数量再调整单元格的数量和位置
        if count == 2 {
            array.removeSubrange(0...1) //4宫格，将多余的两个图片移除
            for i in 0..<array.count {
                //调整剩下的两个图片的y值
                array[i].origin.y = array[i].origin.y - (padding + cellWH)/2
            }
        }else if count == 3{
            array.remove(at: 0)//4宫格，移除第一个多图片
            //调整原来第一行剩余的图片的x值
            array[0].origin.x = (wh - cellWH)/2
        }else if count == 5 {
            array.removeSubrange(0...3) //9宫格，移除多余的4张图
            for i in 0..<array.count {
                if i<2 {
                    //调整原来处在第二行的图片的x
                    array[i].origin.x = array[i].origin.x - (padding+cellWH)/2
                }
                //调整所有图片的y
                array[i].origin.y = array[i].origin.y - (padding+cellWH)/2
            }
        }else if count == 6{
            array.removeSubrange(0...2) //9宫格，移除多余的3张图
            for i in 0..<array.count {
                //将剩余的图片整体向上调整
                array[i].origin.y = array[i].origin.y - (padding+cellWH)/2
            }
        }else if count == 7{
            array.removeSubrange(0...1) //9宫格，移除多余的2张图
            array[0].origin.x = (wh-cellWH)/2 //调整第一行仅剩的一张图到第一行中间位置
        }else if count == 8{
            array.remove(at: 0) //9宫格，移除第一张多余的图
            for i in 0..<2 {
                //将第一行的剩余两张图调整到中间位置
                array[i].origin.x = array[i].origin.x - (padding+cellWH)/2
            }
        }
        return array
    }
    
    
    //重设图片大小
    func reSizeImage(reSize:CGSize)->UIImage{
        UIGraphicsBeginImageContextWithOptions(reSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage
    }
    
    //等比率缩放
    func scaleImage(scaleSize:CGFloat) -> UIImage{
        let reSize = CGSize(width: size.width*scaleSize, height: size.height*scaleSize)
        return reSizeImage(reSize: reSize)
    }
    
    //生成像素化、马赛克后的图片,scale越大，马赛克越大
    func pixellated(scale:Int = 30) -> UIImage {
        let filter = CIFilter(name: "CIPixellate")
        let inputImage = CIImage(image: self)
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(scale, forKey: kCIInputScaleKey)
        let fullPixellatedImage = filter?.outputImage
        let cgImage  = CIContext().createCGImage(fullPixellatedImage!, from: fullPixellatedImage!.extent)
        return UIImage(cgImage: cgImage!)
    }
    
    //返回高斯模糊后的图片,radius越大越模糊
    func blured(radius:Int = 40) -> UIImage {
        let filter = CIFilter(name: "CIGaussianBlur")
        let inputImage = CIImage(image: self)
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(radius, forKey: kCIInputRadiusKey)
        let outputCIImage = filter?.outputImage
        let rect = CGRect(origin: CGPoint.zero, size: size)
        let cgImage = CIContext().createCGImage(outputCIImage!, from: rect)
        return UIImage(cgImage: cgImage!)
    }
    
    //修改图片颜色
    func tint(color:UIColor,blendMode:CGBlendMode) -> UIImage{
        let drawRect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
    
}
