//
//  FirstController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/4/17.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit
import ObjectMapper

class FsectionObj: BaseModel {
    var sectionTitle:String = ""
    var items:[FitemObj] = []
    override func mapping(map: Map) {
        sectionTitle <- map["sectionTitle"]
        items <- map["items"]
    }
}

class FitemObj:BaseModel{
    var item:String = ""
    override func mapping(map: Map) {
        item <- map["item"]
    }
}


class FirstController: BaseViewController {

    @IBOutlet weak var tableview: UITableView!
    var sectionData:[FsectionObj] = []
    let baseData:[String:[String]] = ["基础学习":["UI小控件的学习","Tableview使用","CollectionView使用"],"Demo实践":["加速传感器motion","webview","wkwebview","日历事件的使用","仿微信聊天页面","AnimateDemo","音视频相关"],"iOS框架学习":["Quartz 2D","图层CALayer","CAShapeLayer"],"三方库的学习":["数据存储相关","JSON相关","XML相关","MJRefresh"]] 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.mj_header = MJRefreshNormalHeader(refreshingBlock:{
            
            self.createData()
        })
        createData()
        
        let point = CGPoint(x: 234.0, y: 2348.0)
        let str = NSStringFromCGPoint(point)
//        let point = CGPointFromString(str)
        print(str)
    }
    
    func endrefresh() {
        if tableview!.mj_header != nil &&  tableview!.mj_header.isRefreshing() {
            tableview.mj_header.endRefreshing()
        }
        if tableview!.mj_footer != nil && tableview!.mj_footer.isRefreshing() {
            tableview?.mj_footer.endRefreshing()
        }
    }

    func createData(){
        sectionData.removeAll()
        for sectionObj in baseData {
            var items = [FitemObj]()
            for sectionItem in sectionObj.value {
                let obj:FitemObj = FitemObj()
                obj.item = sectionItem
                items.append(obj)
            }
            let secObj:FsectionObj = FsectionObj()
            secObj.sectionTitle = sectionObj.key
            secObj.items = items
            sectionData.append(secObj)
        }
        endrefresh()
        tableview.fcfRegister(BaseTableViewCell.self)
        tableview.tableFooterView = UIView() //去除多余分割线
        tableview.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension FirstController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData[section].items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionData[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview.fcfDequeueReusableCell(forIndexPath: indexPath) as BaseTableViewCell
        let titleS = sectionData[indexPath.section].items[indexPath.row].item
        cell.textLabel?.text = titleS
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage.init(named: "defaultHead")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let titleS = sectionData[indexPath.section].items[indexPath.row].item
        switch titleS {
        case "Tableview使用":
            let vc = TestTableController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "UI小控件的学习":
            let vc = BaseSearchController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "CollectionView使用":
            let vc = CollectViewDataController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "数据存储相关":
            let vc = DataBaseViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "日历事件的使用":
            let vc = EKEventStoreController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "加速传感器motion":
            let motion = MotionViewController()
            motion.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(motion, animated: true)
        case "webview":
            let webview = WebViewTestController()
            webview.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(webview, animated: true)
        case "wkwebview":
            let wkwebview = WebKitViewController()
            wkwebview.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(wkwebview, animated: true)
        case "仿微信聊天页面":
            let weChat = WechatViewController()
            weChat.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(weChat, animated: true)
        case "AnimateDemo":
            let animate = AnimateTestController()
            animate.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(animate, animated: true)
        case "音视频相关":
            let vc = AudioVideoTestController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "XML相关":
            let vc = XMLTestController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "JSON相关":
            let vc = JSONTestController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "Quartz 2D":
            let vc = Quartz2DTestController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "图层CALayer":
            let vc = CALayerTestController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "CAShapeLayer":
            let vc = CAShapeLayerTestController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}








