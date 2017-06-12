//
//  UserDefaultTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/9.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class UserDefaultTestController: BaseViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getuuid()
        originData()
        labelSave()
        mineModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

//简单存储字符串
extension UserDefaultTestController{
    func getuuid(){
        let userid = UserDefaults.standard.string(forKey: "uuid")
        if userid != nil {
            label.text = userid
        }else{
            let uuid_ref = CFUUIDCreate(nil)
            let uuid_Str = CFUUIDCreateString(nil, uuid_ref)
            let uuid = uuid_Str! as String
            UserDefaults.standard.set(uuid, forKey: "uuid")
            label.text = uuid
        }
    }
}
//存储原生数据
extension UserDefaultTestController{
    func originData(){
        let userDefault = UserDefaults.standard
        //Any
        userDefault.set("fcf",forKey: "Object")
        let objectValue = userDefault.object(forKey: "Object")
        print(objectValue!)
        //Int
        userDefault.set(12345, forKey: "Int")
        print(userDefault.integer(forKey: "Int"))
        //Float
        userDefault.set(3.2, forKey: "Float")
        print(userDefault.float(forKey: "Float"))
        //Double
        userDefault.set(5.23434, forKey: "Double")
        print(userDefault.double(forKey: "Double"))
        //Bool
        userDefault.set(true, forKey: "Bool")
        print(userDefault.bool(forKey: "Bool"))
        //URL
        userDefault.set(URL.init(string: "www.baidu.com"), forKey: "url")
        print(userDefault.url(forKey: "url")!)
        //NSNumber
        userDefault.set(NSNumber.init(value: 22), forKey: "NSNumber")
        print(userDefault.object(forKey: "NSNumber") as! NSNumber)
        //Array
        userDefault.set(["1","2","3"],forKey:"Array")
        print(userDefault.array(forKey: "Array") as! [String])
        //Dictionary
        userDefault.set(["1":"fcf","2":"feng"], forKey: "Dictionary")
        print(userDefault.dictionary(forKey: "Dictionary") as! [String:String])
    }
}
//对系统对象的存储(label和imageview)
extension UserDefaultTestController{
    func labelSave(){
        let userdefault = UserDefaults.standard
        //UILabel存储，先将对象转成Data
        let label = UILabel.init(frame: CGRect.init(x: 50, y: 100, width: 200, height: 50))
        label.text = "UILabel存入userdefault"
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.blue
        let labeldata = NSKeyedArchiver.archivedData(withRootObject: label)
        userdefault.set(labeldata, forKey: "labelData")
        
        //读取
        let labelObjdata = userdefault.data(forKey: "labelData")
        let mylabel = NSKeyedUnarchiver.unarchiveObject(with: labelObjdata!) as? UILabel
        self.view.addSubview(mylabel!)
        
        
        //UIImage的存储,得将image先转成另一个image，否则取出来是nil
        let img1 = UIImage.init(named: "sz")
        let img2 = UIImage.init(cgImage: img1!.cgImage!, scale: img1!.scale, orientation: img1!.imageOrientation)
        let dataImg = NSKeyedArchiver.archivedData(withRootObject: img2)
        //存储
        userdefault.set(dataImg, forKey: "dataimg")
        
        //取
        let imgObjData = userdefault.data(forKey: "dataimg")
        //还原对象
        let myImg = NSKeyedUnarchiver.unarchiveObject(with: imgObjData!) as! UIImage
        self.view.backgroundColor = UIColor(patternImage: myImg)
    }
}

//存储自定义模型，要求是该类实现了NSCoding协议来进行归档和反归档(序列号和反序列化)

class UserDefaultsTestObj: NSObject,NSCoding {
    var name:String
    var phone:String
    //构造方法
    required init(name:String = "",phone:String="") {
        self.name = name
        self.phone = phone
    }
    //从object解析回来
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "Name") as? String ?? ""
        self.phone = aDecoder.decodeObject(forKey: "Phone") as? String ?? ""
    }
    //编码成object
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(phone, forKey: "Phone")
    }
}

extension UserDefaultTestController{
    func mineModel(){
        let userdefault = UserDefaults.standard
        let model = UserDefaultsTestObj.init(name: "fcf", phone: "18701640657")
        //实例对象转成data
        let modelData = NSKeyedArchiver.archivedData(withRootObject: model)
        userdefault.set(modelData, forKey: "myModel")
        //读取
        let myModelData = userdefault.data(forKey: "myModel")
        let myModel = NSKeyedUnarchiver.unarchiveObject(with: myModelData!) as! UserDefaultsTestObj
        label2.text = "\(myModel.name),\(myModel.phone)"
        print(myModel.name,myModel.phone)
    }
}






