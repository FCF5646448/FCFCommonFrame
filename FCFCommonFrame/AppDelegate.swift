//
//  AppDelegate.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/4/13.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit
import ObjectMapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor =  UIColor.white
        window?.rootViewController = MineMainTabController()
        window?.makeKeyAndVisible()
        
        
        self.download() //将之前画的下载下来写进文件
        
        return true
    }
    
    //app将要进入后台
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    //app已经进入后台
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    //  app进入前台
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    //app启动只会执行这一个函数，如果是从后台进入前台则会先调用applicationWillEnterForeground，再调用这个函数
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    //应用程序终止时，但是大部分手动杀死app的操作都会先让app进入后台，然后滑动杀死app
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

//本地消息推送
extension AppDelegate{
    
}

extension AppDelegate{
    func download(){
        var params = [String:AnyObject]()
        params["uid"] = "1" as AnyObject
        DownloadManager.DownloadGet(host: "http://gangqinputest.yusi.tv/", path: "urlparam=note/xmlstr/getxmlbyuid", params: params, successed: { (JsonString) in
            print(JsonString ?? "")
            let result = Mapper<XmlModel>().map(JSONString: JsonString!)
            if let obj = result{
                if obj.returnCode == "0000" && obj.data != nil {
                    if obj.data!.xml_str != "" {
                        let filePath:String = NSHomeDirectory() + "/Documents/DrawText.xml"
                        try! obj.data!.xml_str.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
                    }
                    //读取
                }else{
                    print("获取数据失败")
                }
            }else{
                print("获取数据失败")
            }
        }) { (error) in
            print("\(String(describing: error))")
        }
    }
}



