//
//  ActivityTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/31.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class ActivityTestController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Activity使用"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareBtnClicked(_ sender: Any) {
        //分享内容
        let items:[Any] = ["swift",UIImage(named: "swift.png")!,URL(fileURLWithPath: "www.baidu.com")]
        //自定义的分享对象数组
        let acts = [swiftActivity()]
        //根据分享内容和自定义的分享按钮调用分享视图
        let actView:UIActivityViewController = UIActivityViewController.init(activityItems: items, applicationActivities: acts)
        //要排除的分享按钮，不显示在分享框里
        actView.excludedActivityTypes = [.mail,.copyToPasteboard,.print,.assignToContact,.saveToCameraRoll,.message]
        self.present(actView, animated: true, completion: nil)
    }
    
}

class swiftActivity:UIActivity{
    //用于保存传递过来的数据
    var text:String!
    var url:URL!
    var img:UIImage!
    
    //这里显示在分享框里的图片和名称是这边写死的，跟分享内容没有任何关系。而且分享照片一定是要有1倍、2倍、3倍像素的照片，不然可能不会显示出来
    //显示在分享框里的名称
    override var activityTitle: String?{
        return "swift"
    }
    //显示在分享框里的图片
    override var activityImage: UIImage?{
        return UIImage(named: "defaultHead")
    }
    //分享类型,一般取当前类名
    override var activityType: UIActivityType?{
        return UIActivityType.init(swiftActivity.self.description())
    }
    
    //按钮类型
    override class var activityCategory: UIActivityCategory{
        return .action
    }
    
    //是否显示分享按钮
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for item in activityItems {
            if item is UIImage {
                return true
            }
            if item is String {
                return true
            }
            if item is URL{
                return true
            }
        }
        return false
    }
    
    //解析分享数据时的调用，可以进一步处理
    override func prepare(withActivityItems activityItems: [Any]) {
        for item in activityItems {
            if item is UIImage {
                img = item as! UIImage
            }
            if item is String {
                text = item as! String
            }
            if item is URL{
                url = item as! URL
            }
        }
    }
    //执行分享行为
    override func perform() {
        activityDidFinish(true)
    }
    
    //分享时调用
    override var activityViewController: UIViewController?{
        print("activity...")
        return nil
    }
    //分享结束时调用
    override func activityDidFinish(_ completed: Bool) {
        print("finish...")
    }
    
}
