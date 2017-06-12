//
//  ScrollViewController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/16.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class ScrollViewController: BaseViewController {
    
    var number:Int!
    
    let colorMap = [
        1 : UIColor.blue,
        2 : UIColor.green,
        3 : UIColor.blue
    ]
    
    var ctime : UIDatePicker!
    var leftTime : Int = 180
    var timer:Timer!
    
    var webView:UIWebView = UIWebView.init(frame: CGRect.init(x: 10, y: 100, width: WIDTH-20, height: 400))
    
    init(number initNumber:Int) {
        self.number = initNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "scrollView"
        let numlabel = UILabel.init(frame: CGRect.init(x: 130, y: 50, width: 200, height: 30))
        numlabel.text = "第\(number!)页"
        numlabel.textColor = UIColor.white
        view.addSubview(numlabel)
        view.backgroundColor = colorMap[number]
        if number == 1 {
            datePicker()
        }else if number == 2{
            dateCountDown()
        }else if number == 3 {
            loadWebView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
//第一页

//第二页
extension ScrollViewController{
    func dateCountDown(){
        ctime = UIDatePicker.init(frame: CGRect.init(x: 10, y: 20, width: WIDTH - 20, height: 200))
        ctime.datePickerMode = .countDownTimer //倒计时模式
        ctime.countDownDuration = TimeInterval(leftTime) //这个倒计时数字必须是60的整数倍
        ctime.addTarget(self, action: #selector(timeDateChanged), for: .valueChanged)
        view.addSubview(ctime)
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 10, y: ctime.bounds.size.height + ctime.bounds.origin.y, width: WIDTH - 20, height: 50)
        btn.setTitle("开始倒计时", for: .normal)
        btn.addTarget(self, action: #selector(startCountDown), for: .touchUpInside)
        view.addSubview(btn)
    }
    
    func timeDateChanged(dateP:UIDatePicker){
        showMsg("你选择倒计时为:\(ctime.countDownDuration)")
    }
    
    func startCountDown(sneder:UIButton){
        leftTime = Int(ctime.countDownDuration)
        self.ctime.isEnabled = false
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(tickdown), userInfo: nil, repeats: true)
    }
    
    func tickdown(){
        leftTime -= 1
        ctime.countDownDuration = TimeInterval(leftTime)
        if leftTime <= 0  {
            timer.invalidate()
            ctime.isEnabled = true
        }
    }
}

extension ScrollViewController{
    func datePicker(){
        //时间选择器
        let datePicker = UIDatePicker.init(frame: CGRect.init(x: 10, y: HEIGHT - 250, width: WIDTH - 20, height: 200))
        datePicker.locale = Locale.init(identifier: "zh_CN") //设置中文显示
        datePicker.datePickerMode = .date //设置只显示日期
        datePicker.setValue(UIColor.red, forKey: "textColor") //修改选中的文字颜色
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        view.addSubview(datePicker)
        
    }
    func dateChanged(dateP:UIDatePicker){
        //设置日期样式
        let formater = DateFormatter()
        formater.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        showMsg(formater.string(from: dateP.date))
    }
}

//第三页
extension ScrollViewController{
    func loadWebView(){
        view.addSubview(webView)
        
        let segment = UISegmentedControl.init(frame: CGRect.init(x: 10, y: 10, width: WIDTH-20, height: 40))
        segment.backgroundColor = UIColor.gray
        segment.tintColor = UIColor.orange
        segment.insertSegment(withTitle: "webView", at: 0, animated: false)
        segment.insertSegment(withTitle: "webKit", at: 1, animated: false)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
       
        view.addSubview(segment)
        segmentValueChanged(sender: segment)
    }
    
    func segmentValueChanged(sender:UISegmentedControl){
        let index = sender.selectedSegmentIndex
        switch index {
        case 0:
            let html = "<h1>欢迎来到：<a href='http://www.baidu.com'>百度</a></h1>"
            webView.loadHTMLString(html, baseURL: nil)
        case 1:
            let path = Bundle.main.path(forResource: "test1", ofType: "pdf")
            if path != nil {
                let urlStr = URL.init(fileURLWithPath: path!)
                webView.loadRequest(URLRequest(url:urlStr))
            }
            
        default:
            print("no")
        }
    }
    
}
