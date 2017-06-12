//
//  JSONTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/7.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class JSONTestController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var data = ["JSONSerialization原生","SwifyJSON","ObjectMapper"]
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "JSON相关"
        tableView.tableFooterView = UIView()
        tableView.fcfRegister(BaseTableViewCell.self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension JSONTestController:UITableViewDelegate,UITableViewDataSource{
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
        case "JSONSerialization原生":
            let vc = JSONSerializationTestController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case "SwifyJSON":
            let vc = SwiftyJSONTestController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
