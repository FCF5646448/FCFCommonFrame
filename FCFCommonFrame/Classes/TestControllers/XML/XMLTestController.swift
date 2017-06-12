//
//  XMLTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/6.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class XMLTestController: BaseViewController,XMLParserDelegate {

    @IBOutlet weak var tableView: UITableView!
    var data:[String] = ["XMLParser原生解析","KissXML"]
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "XML相关"
        tableView.tableFooterView = UIView()
        tableView.fcfRegister(BaseTableViewCell.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension XMLTestController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.fcfDequeueReusableCell(forIndexPath: indexPath) as BaseTableViewCell
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch data[indexPath.row] {
        case "XMLParser原生解析":
            let vc = XMLParserTestController()
            vc.hidesBottomBarWhenPushed = false
            self.navigationController?.pushViewController(vc, animated: true)
        case "KissXML":
            let vc = KissXMLTestController()
            vc.hidesBottomBarWhenPushed = false
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
