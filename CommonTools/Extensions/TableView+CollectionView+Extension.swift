//
//  TableView+CollectionView+Extension.swift
//  FCFCommonTools
//
//  Created by 冯才凡 on 2017/4/6.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView:class {}

extension ReusableView where Self:UIView{
    static var reuseIdentifier:String{
        return String(describing: self)
    }
}


extension UITableViewCell:ReusableView{}
extension UICollectionViewCell:ReusableView{}

protocol NibLoadableView:class {}
extension NibLoadableView where Self:UIView{
    static var NibName:String{
        return String(describing: self)
    }
}
extension UITableViewCell:NibLoadableView{}
extension UICollectionViewCell:NibLoadableView{}

//UITableView 简化xib注册cell和获取复用队列的cell的方法
extension UITableView{
    func fcfRegister<T:UITableViewCell>(_:T.Type) where T:ReusableView, T:NibLoadableView{
        let Nib = UINib(nibName: T.NibName, bundle: nil)
        register(Nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func fcfDequeueReusableCell<T:UITableViewCell>(forIndexPath indexPath:IndexPath)->T where T:ReusableView{
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier : \(T.reuseIdentifier)")
        }
        return cell
    }
}

//UICollectionView 简化xib注册cell和获取复用队列的cell的方法
extension UICollectionView{
    func fcfRegister<T:UICollectionViewCell>(_:T.Type) where T:ReusableView, T:NibLoadableView{
        let Nib = UINib.init(nibName: T.NibName, bundle: nil)
        register(Nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func fcfDequeueReusableCell<T:UICollectionViewCell>(forIndexPath indexPath:IndexPath)->T where T:ReusableView{
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else{
            fatalError("Could not dequeue cell with identifier : \(T.reuseIdentifier)")
        }
        return cell
    }
}
