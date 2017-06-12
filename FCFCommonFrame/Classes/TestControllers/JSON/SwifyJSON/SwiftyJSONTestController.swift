//
//  SwiftyJSONTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/7.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

////SwiftyJSON没有提供与Model的映射，貌似必须得借助泛型才能与model映射
protocol SwiftyJsonAble {
    init?(jsonData:JSON)
}

class SJSONModel<T:SwiftyJsonAble>: SwiftyJsonAble {
    var returnMsg:String = ""
    var returnCode:String = ""
    var data:[T]?
    required init?(jsonData:JSON) {
        self.returnMsg = jsonData["returnMsg"].stringValue
        self.returnCode = jsonData["returnCode"].stringValue
        self.data = jsonData["datas"].arrayValue.flatMap{T(jsonData:$0)}
    }
}
class SDataModel<T:SwiftyJsonAble>: SwiftyJsonAble {
    var id:String = ""
    var type:String = ""
    var content:[T]?
    required init(jsonData:JSON) {
        self.id = jsonData["id"].stringValue
        self.type = jsonData["type"].stringValue
        self.content = jsonData["content"].arrayValue.flatMap{T(jsonData:$0)}
    }
}
class SContenModel: SwiftyJsonAble {
    var cid:String = ""
    var name:String = ""
    var img:String = ""
    var url:String = ""
    required init?(jsonData:JSON) {
        cid = jsonData["cid"].stringValue
        name = jsonData["name"].stringValue
        img = jsonData["img"].stringValue
        url = jsonData["url"].stringValue
    }
}


class SwiftyJSONTestController: BaseViewController {
    var sectionArr:[(type:String,contentlist:[SContenModel])] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "swiftyJSON"
        tableView.tableFooterView = UIView()
        tableView.fcfRegister(BaseTableViewCell.self)
        json()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension SwiftyJSONTestController{
    func json(){
        let path = Bundle.main.path(forResource: "data", ofType: "json")
        let jurl = URL.init(fileURLWithPath: path!)
        let data = try? Data.init(contentsOf: jurl)
        let json = try? JSON.init(data: data!) //如果是下载下来的，就得先转成data类型
        
        let jsonModel = SJSONModel<SDataModel<SContenModel>>(jsonData:JSON(json))
        
        for obj in (jsonModel?.data!)! {
            let type = obj.type
            let content = obj.content
            self.sectionArr.append((type: type, contentlist:content!))
        }
        tableView.reloadData()
    }
}


extension SwiftyJSONTestController:UITableViewDelegate,UITableViewDataSource{
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
        let model = sectionArr[indexPath.section].contentlist[indexPath.row] as SContenModel
        cell.textLabel?.text = model.name
        cell.imageView?.sd_setImage(with: URL(string: model.img), placeholderImage: UIImage(named:"defaultHead"))
        return cell
    }
}
