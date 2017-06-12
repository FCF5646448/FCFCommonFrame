//
//  KissXMLTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/6.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class KissXMLTestController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var data:[(name:String,age:String,identity:Identity)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "KissXML"
        tableView.tableFooterView = UIView()
        tableView.fcfRegister(BaseTableViewCell.self)
        testXML()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension KissXMLTestController{
    func testXML(){
        let file = Bundle.main.path(forResource: "data", ofType: "xml")
        let url = URL.init(fileURLWithPath: file!)
        //获取xml文件内容
        let xmlData = try! Data.init(contentsOf: url)
        //构造xml文件内容
        let doc = try! DDXMLDocument.init(data: xmlData, options: 0)
        //利用xpath来定位节点(xpath是xml的定位语法，类似数据库中的SQL功能)
        let students = try! doc.nodes(forXPath: "//student") as! [DDXMLElement]
        for stu in students {
            let uid = stu.attribute(forName: "id")!.stringValue //内置节点获取方式
            let name = stu.forName("name")!.stringValue //单独的节点获取方式
            let identity:Identity = .student
            let age = stu.forName("age")!.stringValue
            data.append((name: name!, age: age!, identity: identity))
        }
        
        let teachers = try! doc.nodes(forXPath: "//teacher") as! [DDXMLElement] //数组
        for tea in teachers {
            let uid = tea.attribute(forName: "id")!.stringValue
            let name = tea.forName("name")!.stringValue
            let age = tea.forName("age")!.stringValue
            let identity:Identity = .teacher
            data.append((name: name!, age: age!, identity: identity))
        }
        
        //遍历mobile下所有tel节点
        let classE = try! doc.nodes(forXPath: "//class") as! [DDXMLElement]
        let mobiles = classE[0].forName("mobile") as! DDXMLElement
        for element in mobiles.elements(forName: "tel") {
            print(element.stringValue ?? "")
        }
    }
}

extension KissXMLTestController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.fcfDequeueReusableCell(forIndexPath: indexPath) as BaseTableViewCell
        cell.textLabel?.text = String.init(format: "%@: name(%@) age(%@)", (data[indexPath.row].identity == .teacher ? "T":"S"),data[indexPath.row].name,data[indexPath.row].age)
        return cell
    }
}
