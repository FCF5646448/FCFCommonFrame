//
//  EKEventStoreController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/31.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit
import EventKit

class EKEventStoreController: BaseViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var data:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Event获取系统日历"
        self.tableView.fcfRegister(BaseTableViewCell.self)
        self.tableView.tableFooterView = UIView()
        addeventStore()
    }
    
    //测试添加日志事件
    func addeventStore(){
        self.data.removeAll()
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted && error == nil {
                //新建一个事件 
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = "新增一个测试事件"
                event.startDate = Date()
                event.endDate = Date()
                event.notes = "这个是备注"
                event.calendar = eventStore.defaultCalendarForNewEvents
                do{
                    try eventStore.save(event, span: .thisEvent)
                }catch{}
                //获取所有的事件
                let startDate = Date().addingTimeInterval(-3600*24*90)
                let endDate = Date().addingTimeInterval(3600*24*90)
                let predicate2 = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
                if let ev = eventStore.events(matching: predicate2) as [EKEvent]! {
                    for i in ev {
                        var str = ""
                        str.append("标题\(i.title) ,")
                        print("标题\(i.title)")
                        str.append("StartTime\(i.startDate) ,")
                        print("开始时间\(i.startDate)")
                        str.append("EndDate\(i.endDate) ,")
                        print("结束时间\(i.endDate)")
                        self.data.append(str)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

extension EKEventStoreController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.fcfDequeueReusableCell(forIndexPath: indexPath) as BaseTableViewCell
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}
