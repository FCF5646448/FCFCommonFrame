//
//  NumberExtension.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/7/4.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat{
    func roundTo(places:Int)->CGFloat{
        let divisor = powf(10.0, Float(places))
        return CGFloat((self * CGFloat(divisor)).rounded() / CGFloat(divisor))
    }
}
