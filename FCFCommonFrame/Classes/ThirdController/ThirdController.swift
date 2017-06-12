//
//  ThirdController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/4/17.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class ThirdController: BaseViewController {
    let stepper = UIStepper()
    let label = UILabel.init(frame: CGRect.init(x: 10, y: 200, width: WIDTH - 20, height: 50))
    override func viewDidLoad() {
        super.viewDidLoad()
        steper()
        test()
        segmentTest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ThirdController{
    func segmentTest(){
        let seg = UISegmentedControl.init(items: ["老师","学生","残疾人"])
        seg.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40)
        
        seg.selectedSegmentIndex = 0
        seg.layer.borderWidth = 0.0
        seg.layer.borderColor = UIColor.clear.cgColor
        
        self.view.addSubview(seg)
    }
}

extension ThirdController : UIPickerViewDelegate,UIPickerViewDataSource{
    func test() {
        let picker = UIPickerView.init(frame: CGRect.init(x: 10, y: HEIGHT - 300, width: WIDTH - 20, height: 200))
        picker.dataSource = self
        picker.delegate = self
        picker.selectRow(1, inComponent: 0, animated: true)
        picker.selectRow(2, inComponent: 1, animated: true)
        picker.selectRow(3, inComponent: 2, animated: true)
        view.addSubview(picker)
    }
    //列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    //设置每一列的行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    //设置高度
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    //设置宽度
    func  pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if 0 == component {
            return 50
        }else{
            return (pickerView.width-50)/2.0
        }
    }
    //设置内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row) + "-" + String(component)
    }
    //uiview，如果有view则不会有title
    //    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    //        let img = UIImage.init(named: "deer")
    //        let imgView = UIImageView.init(image: img)
    //        return imgView
    //    }
    //选中
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        showMsg(String(row) + "-" + String(component))
    }
}


extension ThirdController{
    
    func steper(){
        
        stepper.frame = CGRect.init(x:(WIDTH-50)/2.0 , y: 100, width: 50, height: 40)
        stepper.minimumValue = 1.0
        stepper.maximumValue = 10.0
        stepper.value = 5.5
        stepper.stepValue = 0.5
        stepper.isContinuous = true
        stepper.wraps = true
        view.addSubview(stepper)
        stepper.addTarget(self, action: #selector(stepperValuechange), for: .valueChanged)
        label.text = "stepper当前值:\(stepper.value)"
        label.font = UIFont.init(name: "Zapfino", size: 15)
        label.textColor = UIColor.red
        label.backgroundColor = UIColor.gray
        label.textAlignment = .center
        view.addSubview(label)
    }
    
    func stepperValuechange(){
        label.text = "stepper当前值:\(stepper.value)"
    }
}
