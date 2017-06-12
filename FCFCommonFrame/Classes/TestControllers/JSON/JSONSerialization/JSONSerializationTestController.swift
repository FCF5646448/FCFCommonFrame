//
//  JSONSerializationTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/7.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit
import SDWebImage

class JSONModel: NSObject {
    var returnMsg:String = ""
    var returnCode:String = ""
    var data:[DataModel]?
}
class DataModel: NSObject {
    var id:String = ""
    var type:String = ""
    var content:[contenModel]?
}
class contenModel: NSObject {
    var cid:String = ""
    var name:String = ""
    var img:String = ""
    var url:String = ""
}

class JSONSerializationTestController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var sectionArr:[(type:String,contentlist:[contenModel])] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.fcfRegister(BaseTableViewCell.self)
        jsonToData()
        json()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

extension JSONSerializationTestController{
    func jsonToData(){
        let path = Bundle.main.path(forResource: "data", ofType: "json")
        //转成url
        let jurl = URL(fileURLWithPath: path!)
        //转换为data格式
        let data = try! Data(contentsOf: jurl)
        print(data)
        //将data转换成json对象
        let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
        
        //将json转成data
        let jdata = try? JSONSerialization.data(withJSONObject: json, options: [])
        print(jdata)
        //将data转成string
        let str = String.init(data: jdata!, encoding: String.Encoding.utf8)
        print(str ?? "")
    }
    func json(){
        //数据解析
        let path = Bundle.main.path(forResource: "data", ofType: "json")
        //转成url
        let jurl = URL(fileURLWithPath: path!)
        //转换为data格式
        let jdata = try! Data(contentsOf: jurl)
        do{
             //将data转换成json对象
            let json = try JSONSerialization.jsonObject(with: jdata, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
            print(json)
            //解析
            //最外层datas
            let datas = json["datas"] as! [AnyObject]
            for item in datas {
                let type = item["type"] as! String
                let contentList = item["content"] as! [AnyObject]
                var contentArr:[contenModel] = []
                for obj in contentList {
                    let name = obj["name"] as! String
                    let img = obj["img"] as! String
                    
                    let model = contenModel()
                    model.name = name
                    model.img = img
                    contentArr.append(model)
                }
                sectionArr.append((type: type, contentlist: contentArr))
            }
            
        }catch let error as NSError{
            print(error)
        }
        
        //将字典数组转换成Data
        
    }
}

extension JSONSerializationTestController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionArr[section].contentlist.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArr[section].type
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.fcfDequeueReusableCell(forIndexPath: indexPath) as BaseTableViewCell
        let model = sectionArr[indexPath.section].contentlist[indexPath.row] as contenModel
        cell.textLabel?.text = model.name
        cell.imageView?.sd_setImage(with: URL(string: model.img), placeholderImage: UIImage(named:"defaultHead"))
        return cell
    }
}
