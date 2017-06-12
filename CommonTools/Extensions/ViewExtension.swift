//
//  ViewExtension.swift
//  FCFCommonTools
//
//  Created by 冯才凡 on 2017/4/6.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    //获取任意试图view指定类型的父视图T,例如cell上的btn获取cell：let cell = btn.superView(of:UITableViewCell.self)
    func superView<T:UIView>(of: T.Type) -> T? {
        for view in sequence(first: self.superview, next: {$0?.superview}) {
            if let father = view as? T {
                return father
            }
        }
        return nil
    }
    
    //获取任意试图view所属视图控制器UIViewController
    func firstViewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: {$0?.superview}) {
            if let response = view?.next {
                if response.isKind(of: UIViewController.self){
                    return response as? UIViewController
                }
            }
        }
        return nil
    }
    
    /**
     @IBInspectable 用于修饰属性，其修饰的属性可以在xib右侧面板中修改，也可以直接通过代码.出来
     */
    
    /// 设置圆角
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    /// 设置描边
    @IBInspectable var borderColor: UIColor {
        get {
            guard let c = layer.borderColor else {
                return UIColor.clear
            }
            return UIColor(cgColor: c)
        }
        
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    /// 设置描边粗细
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    /// x
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        
        set {
            frame.origin.x = newValue
        }
    }
    
    /// y
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        
        set {
            frame.origin.y = newValue
        }
    }
    
    /// centerX
    var centerX: CGFloat {
        get {
            return center.x
        }
        
        set {
            center.x = newValue
        }
    }
    
    /// centerY
    var centerY: CGFloat {
        get {
            return center.y
        }
        
        set {
            center.y = newValue
        }
    }
    
    /// width
    var width: CGFloat {
        get {
            return frame.size.width
        }
        
        set {
            frame.size.width = newValue
        }
    }
    
    /// height
    var height: CGFloat {
        get {
            return frame.size.height
        }
        
        set {
            frame.size.height = newValue
        }
    }
    
    /// size
    var size: CGSize {
        get {
            return frame.size
        }
        
        set {
            frame.size = newValue
        }
    }
}
