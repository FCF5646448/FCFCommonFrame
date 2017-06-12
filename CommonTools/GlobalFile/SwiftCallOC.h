//
//  SwiftCallOC.h
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/4/17.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

#ifndef SwiftCallOC_h
#define SwiftCallOC_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//这个就是调用OC代码的bridge文件，需要在Object-C Bridgeing Header 中把$SRCROOT/CommonTools/GlobalFile/SwiftCallOC.h这个相对路径加上。另外一个需要注意的是，如果是用Carthage导入的第三方，就只能每次使用的时候import。不能放在这里
#import "MJRefresh.h"

#import <sqlite3.h> //用于SQlite3TestController,要使用系统原生的就只有这个OC版本,如果不想自己造轮子可以直接使用别人的swift版本,如stephencelis/SQLite.swift(https://github.com/stephencelis/SQLite.swift)

#import "DDXML.h"
#import "DDXMLElementAdditions.h" //xml

#endif /* SwiftCallOC_h */
