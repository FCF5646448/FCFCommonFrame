//
//  XmlManager.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/30.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class Item {
    var name:String = ""
    var attributes:[String:String]?
    var nodes:[Node]?
    
    init(name:String) {
        self.name = name
        nodes = []
    }
    func addNode(node:Node){
        nodes?.append(node)
    }
}

class Node {
    var name = ""
    var attributes:[String:String]?
    var subNode:Node?
    init(name:String) {
        self.name = name
    }
}

extension String{
    func elementStartTag()->String{
        return "<" + self
    }
    func elementEntAttributesTag()->String{
        return self + ">"
    }
    func elementEndTag() -> String {
        return "</" + self + ">"
    }
}

class XmlManager: NSObject {
    private let xmlHead = "<?xml version='1.0' encoding='UTF-8'?>"
    private var dirPath = ""
    private var filePath = ""
    private var fileName = ""
    var items:[Item]?
    
    init(dir:String,fileName:String) {
        super.init()
        self.dirPath = dir
        self.fileName = fileName
        self.filePath = dirPath + fileName
        items = []
    }
    
    //保存xml文件
    func saveXml(){
        let data = NSMutableData()
        
        //xml文件声明
        data.append("\(xmlHead)\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        //遍历item
        for i in 0..<items!.count {
            let item = items![i]
            data.append("<\(item.name)>\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            if item.attributes != nil {
                //获取item属性
                let itemStr:String = ItemToString(item: item)
                //
                data.append("\(itemStr)\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            }
            //
            let nodes = item.nodes
            for i in 0..<nodes!.count {
                let node = nodes![i]
                let nodeStr:String = NodeToString(node: node)
                data.append("\(nodeStr)\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            }
            
            data.append("\(item.name)\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            
            data.write(toFile: filePath, atomically: true)
        }
        
        let dataStr = String(data:data as Data , encoding: String.Encoding.utf8)
        print(dataStr)
    }
    
    //添加节点
    func ItemToString(item:Item)->String{
        //拼接结点
        let nodeName = item.name
        var nodeStr:String = nodeName.elementStartTag() + " "
        
        if item.attributes?.count == 0 {
            return nodeStr
        }
        
        //拼接结点属性
        for (key,value) in item.attributes! {
            nodeStr += "\(key)=\"\(value)\" "
        }
        nodeStr += ">"
        return nodeStr
    }
    
    //添加属性
    func NodeToString(node:Node)->String{
        //拼接结点
        let nodeName = node.name
        var nodeStr:String = nodeName.elementStartTag() + " "
        //拼接节点 属性
        for (key,value) in (node.attributes)! {
            nodeStr += "\(key)=\"\(value)\" "
        }
        nodeStr += "/>"
        return nodeStr
    }
    
    
}
