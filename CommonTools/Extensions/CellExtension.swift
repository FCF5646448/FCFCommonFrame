//
//  CellExtension.swift
//  FCFCommonTools
//
//  Created by 冯才凡 on 2017/4/7.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell{
    //返回cell所在tableview
    func superTableView() -> UITableView? {
        for view in sequence(first: self.superview, next: {$0?.superview}) {
            if let tableview = view as? UITableView {
                return tableview
            }
        }
        return nil
    }
}

extension UICollectionViewCell{
    //返回cell所在collectionview
    func superCollectionView() -> UICollectionView? {
        for view in sequence(first: self.superview, next: {$0?.superview}) {
            if let collectionView = view as? UICollectionView {
                return collectionView
            }
        }
        return nil
    }
}
