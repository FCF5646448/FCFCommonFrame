//
//  XMLParserTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/6.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit
import ObjectMapper

enum Identity {
    case teacher
    case student
}

class XMLParserTestController: BaseViewController {
    //xmlparser 是一行一行按字段解析的
    @IBOutlet weak var tableView: UITableView!
    var currentParsedElement:String? //当前解析的元素名
    var currentParsedElementValue:String? //当前解析的元素的值
    
    var data:[(name:String,age:String,identity:Identity)] = []
    
    var name:String = ""
    var age:String = ""
    var currentIdentify:Identity = .student //当前身份
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.fcfRegister(BaseTableViewCell.self)
        title = "XMLParser"
        let param = XMLParser(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "data", ofType: "xml")!))
        param?.delegate = self
        param?.parse() // 开始解析
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension XMLParserTestController:XMLParserDelegate{
    //开始解析
    func parserDidStartDocument(_ parser: XMLParser) {
        print("Start parserDidStartDocument")
    }
    //遇到一个开始标签时调用
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentParsedElement = elementName
        if currentParsedElement == "studentList" {
            currentIdentify = .student
        }else if currentParsedElement == "teacherList"{
            currentIdentify = .teacher
        }
    }
    //遇到字符串时调用
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let str = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if currentParsedElement == "name" {
            name += str
        }else if currentParsedElement == "age"{
            age += str
        }
    }
    //遇到结束标签时调用
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if name != "" && age != "" {
            data.append((name: name, age: age, identity: currentIdentify))
            name = ""
            age = ""
        }
    }
    //完成解析时调用
    func parserDidEndDocument(_ parser: XMLParser) {
        print("End parserDidStartDocument")
        self.tableView.reloadData()
    }
}

extension XMLParserTestController:UITableViewDelegate,UITableViewDataSource{
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

