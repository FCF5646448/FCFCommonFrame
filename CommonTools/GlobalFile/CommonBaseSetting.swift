//
//  CommonBaseSetting.swift
//  FCFCommonTools
//
//  Created by 冯才凡 on 2017/4/6.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

//注意，在使用xib初始化的view里面。view的width和height是xib里的高度。为了更好地适配，最好使用这里的宽高
//屏幕宽度
let WIDTH = UIScreen.main.bounds.width > UIScreen.main.bounds.height ? UIScreen.main.bounds.height : UIScreen.main.bounds.width

//屏幕高度
let HEIGHT = UIScreen.main.bounds.width > UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height

//内容的宽度和高度(一般需要除去顶部navigationBar的高度44和状态栏的高度20)
let ContentWidth = WIDTH
let ContentHeight = HEIGHT - 64

//主题色
let MainColor = "fe4b2b"
