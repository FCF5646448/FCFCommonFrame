//
//  TableView.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/19.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

//数据提供协议
protocol ChatDataSource{
    //返回对话记录的全部行数
    func rowsForChatTable(_ tableView:TableView)->Int
    //返回某一行的内容
    func chatTableView(_ tableView:TableView,dataForRow row:Int)->MessageItem
}

enum ChatBubbleTypingType{
    case nobody
    case me
    case somebody
}

class TableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    //用于保存所有消息
    var bubbleSection:NSMutableArray!
    //数据源，用于与WebchatViewController交换数据
    var chatDataSource:ChatDataSource!
    
    var snapInterval:TimeInterval!
    var typingBubble:ChatBubbleTypingType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.snapInterval = TimeInterval(60*60*24)
        self.typingBubble = ChatBubbleTypingType.nobody
        self.bubbleSection = NSMutableArray()
        
        self.backgroundColor = UIColor.clear
        self.separatorStyle = .none
        self.delegate = self
        self.dataSource = self
    }
    
    override func reloadData() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        self.bubbleSection = NSMutableArray()
        var count = 0
        if self.chatDataSource != nil {
            count = self.chatDataSource.rowsForChatTable(self)
            if count > 0 {
                let bubbleData = NSMutableArray()
                for i in 0..<count {
                    let objc = self.chatDataSource.chatTableView(self, dataForRow: i)
                    bubbleData.add(objc)
                }
                
                bubbleData.sort(comparator: sortDate)
                
                var last = ""
                var currentSection = NSMutableArray()
                //
                let dformatter = DateFormatter()
                
                dformatter.dateFormat = "dd"
                for i in 0..<count {
                    let data = bubbleData[i] as! MessageItem
                    //使用日期格式器格式化日期，日期不同，就新分组
                    let datestr = dformatter.string(from: data.date as Date)
                    if datestr != last {
                        currentSection = NSMutableArray()
                        self.bubbleSection.add(currentSection)
                    }
                    (self.bubbleSection[self.bubbleSection.count-1] as AnyObject).add(data)
                    last = datestr
                }
            }
        }
        super.reloadData()
        //
        let secno = self.bubbleSection.count - 1
        let indexPath = IndexPath(row: (self.bubbleSection[secno] as AnyObject).count, section: secno)
        self.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
    }
    
    
    func sortDate(_ m1:Any,m2:Any)->ComparisonResult{
        if (m1 as! MessageItem).date.timeIntervalSince1970 < (m2 as! MessageItem).date.timeIntervalSince1970 {
            return ComparisonResult.orderedAscending
        }else{
            return ComparisonResult.orderedDescending
        }
    }
    
    //
    func numberOfSections(in tableView: UITableView) -> Int {
        var result = self.bubbleSection.count
        if self.typingBubble != ChatBubbleTypingType.nobody {
           result = result + 1
        }
        return result
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section >= self.bubbleSection.count {
            return 0
        }
        return (self.bubbleSection[section] as AnyObject).count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return TableHeaderViewCell.getHeight()
        }
        
        let section = self.bubbleSection[indexPath.section] as! NSMutableArray
        let data = section[indexPath.row - 1]
        let item = data as! MessageItem
        let height = max(item.insets.top + item.view.frame.height + item.insets.bottom, 52) + 17
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = self.fcfDequeueReusableCell(forIndexPath: indexPath) as TableHeaderViewCell
            let section = self.bubbleSection[indexPath.row] as! NSMutableArray
            let data = section[indexPath.row] as! MessageItem
            cell.setDate(data.date)
            return cell
        }
        
        let cell = self.fcfDequeueReusableCell(forIndexPath: indexPath) as MsgTableViewCell
        let section = self.bubbleSection[indexPath.section]as! NSMutableArray
        let data = section[indexPath.row - 1] as! MessageItem
        cell.rebuildUserInterface(data: data)
        return cell
    }
}
