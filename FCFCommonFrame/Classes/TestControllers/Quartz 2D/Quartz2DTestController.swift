//
//  Quartz2DTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/16.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit
import ObjectMapper

class XmlModel:BaseModel{
    var returnMsg:String = ""
    var returnCode:String = ""
    var data:xmlDataObj?
    
    override func mapping(map: Map) {
        returnMsg <- map["returnMsg"]
        returnCode <- map["returnCode"]
        data <- map["data"]
    }
}

class xmlDataObj: BaseModel {
    var id:String = ""
    var uid:String = ""
    var xml_str:String = ""
    override func mapping(map: Map) {
        id <- map["id"]
        uid <- map["uid"]
        xml_str <- map["xml_str"]
    }
}

//1、将每次画的东西先存到全局类里
//2、然后在app关闭的时候，将画的东西转成xml文档
//3、每次打开页面的时候，先从全局数组里拿到数据，没有的话，从xml里将数据拿到，然后缓存到数组里，生成新的图片。将图片放到全局数组里

//画图的原理就是每次从上一点画到下一点
class Quartz2DTestController: BaseViewController {

    @IBOutlet weak var drawContext: DrawContext!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var bgImage: UIImageView! //曲谱背景
    
    @IBOutlet weak var forwardBtn: UIButton!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var colorBtn: UIButton!
    
    @IBOutlet weak var fontSizeSlide: UISlider!
    
    var wBili:CGFloat = 1.0
    var hBili:CGFloat = 1.0
    
    var selectedColor:String = "000000" {
        didSet {
            self.colorBtn.backgroundColor = UIColor.haxString(hex: selectedColor)
            self.drawContext.changeBrushColor(color: selectedColor)
        }
    }
    
    var fontSize:CGFloat = 13.0 {
        didSet {
            self.drawContext.changeBrushSize(size: fontSize)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "画板"
        updateUI()
        let img = UIImage(named:"qupu")
        self.bgImage.image = img
        
        let imgW = img!.size.width
        let imgH = img!.size.height
        
        self.drawContext.pivot_x = imgW*1.0/2
        self.drawContext.pivot_y = imgH*1.0/2
        
        let ScreenW = self.bgImage.frame.width
        let ScreenH = self.bgImage.frame.height
        
        self.wBili =  ScreenW*1.0/imgW
        self.hBili = ScreenH*1.0/imgH
        
        self.drawContext.wBili = self.wBili
        self.drawContext.hBili = self.hBili
        
        segment.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        segment.selectedSegmentIndex = 0 //默认就是画曲线的画笔
        segmentValueChanged(seg: segment)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidEnterBackground, object: nil, queue: OperationQueue.main) { (notification) in
            //程序进入后台，就把缓存里的笔画存为当前的笔画
//            self.saveXml()
        }
        
    }
    
    func updateUI(){
        self.backBtn.layer.cornerRadius = 4
        self.backBtn.layer.masksToBounds = true
        self.forwardBtn.layer.cornerRadius = 4
        self.forwardBtn.layer.masksToBounds = true
        self.colorBtn.layer.cornerRadius = 4
        self.colorBtn.layer.masksToBounds = true
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("保存", for: .normal)
        btn.addTarget(self, action: #selector(saveXml), for: .touchUpInside)
        let rbtn = UIBarButtonItem(customView: btn)
        let btn2 = UIButton.init(type: .custom)
        btn2.frame = CGRect(x: 0, y: 44, width: 44, height: 44)
        btn2.setTitleColor(UIColor.white, for: .normal)
        btn2.setTitle("刷新", for: .normal)
        btn2.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        let rbtn2 = UIBarButtonItem(customView: btn2)
        
        self.navigationItem.rightBarButtonItems = [rbtn,rbtn2]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.drawContext.hasDraw {
            self.drawContext.restoreDraw()
        }else{
            //从xml中读取
            getDataFromXML()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.drawContext.removeUselessSave()
    }

    //复原 减笔画
    @IBAction func backoutSelected(_ sender: Any) {
        if self.drawContext.canBack() {
            drawContext.undo()
        }
    }
    
    //重做 加笔画
    @IBAction func redrawSelected(_ sender: Any) {
        if self.drawContext.canForward() {
            drawContext.redo()
        }
    }
    
    //换颜色
    @IBAction func colorBtnClicked(_ sender: Any) {
        if segment.selectedSegmentIndex == 4 {
            return
        }
        showColorPick()
    }
    
    //调整画笔大小
    @IBAction func fontSizeChanged(_ sender: Any) {
        fontSize = CGFloat((sender as! UISlider).value)
    }
    
    func segmentValueChanged(seg:UISegmentedControl){
        if seg.selectedSegmentIndex == 2 {
            self.drawContext.showTextVIewUIMsg()
        }else{
            self.drawContext.hideTextViewUIMsg()
        }
        switch seg.selectedSegmentIndex {
        case 0:
            //画笔
            self.drawContext.initBrush(type: .Pentype(.Curve), color: selectedColor, width: fontSize)
            break
        case 1:
            //形状,先默认是矩形
            self.drawContext.initBrush(type: .Formtype(.Rect), color: selectedColor, width: fontSize)
            break
        case 2:
            //文本
            self.drawContext.initBrush(type: .Text, color: selectedColor, width: fontSize)
            break
        case 3:
            //音符，当作文字来添加
            self.drawContext.initBrush(type: .Note, color: selectedColor, width: fontSize)
            break
        case 4:
            //橡皮擦,不需要选颜色
            self.drawContext.initBrush(type: .Eraser, color: selectedColor, width: fontSize)
            break
        default:
            break
        }
    }
    
    //选完颜色和大小
    func showColorPick() {
        let color = ColorPicker.init { (colorStr) in
            self.selectedColor = colorStr
        }
        color.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        color.definesPresentationContext = true
        color.modalPresentationStyle = .overCurrentContext
        self.present(color, animated: false, completion: nil)
    }
    
    deinit {
        
    }
    
}

extension Quartz2DTestController{
    //将xml的操作顺序放进数组里
    func getDataFromXML(){

        var pathArr:[PathModel] = []
        
        let filePath:String = NSHomeDirectory() + "/Documents/DrawText.xml"
        
        let url = URL(fileURLWithPath: filePath)
        //xml
        let xmlData = try! Data(contentsOf: url)
        //
        let doc = try! DDXMLDocument(data: xmlData, options: 0)
        
        let paths = try! doc.nodes(forXPath: "//Path") as! [DDXMLElement]
        
        for path in paths {
            let obj:PathModel = PathModel()
            if let pen_type = path.attribute(forName: "pen_type") {
                obj.pen_type = pen_type.stringValue
            }
            
            if let pen_shape = path.attribute(forName: "pen_shape") {
                obj.pen_shape = pen_shape.stringValue
            }
            
            if let pen_width = path.attribute(forName: "pen_width") {
                obj.pen_width = pen_width.stringValue
            }
            if let color = path.attribute(forName: "color") {
                
                var colorStr = color.stringValue
                if (colorStr?.hasPrefix("#"))! {
                    let range = colorStr!.index(colorStr!.startIndex, offsetBy: 0)..<colorStr!.index(colorStr!.startIndex, offsetBy: 1)
                    colorStr!.removeSubrange(range)
                }
                
                obj.color = colorStr
            }
            if let rotate_degree = path.attribute(forName: "rotate_degree"){
                obj.rotate_degree = rotate_degree.stringValue
            }
            if let pivot_x = path.attribute(forName: "pivot_x") {
                obj.pivot_x = pivot_x.stringValue
            }
            if let pivot_y = path.attribute(forName: "pivot_y") {
                obj.pivot_y = pivot_y.stringValue
            }
            if let point_list = path.attribute(forName: "point_list") {
                obj.point_list = point_list.stringValue
            }
            if let size = path.attribute(forName: "size") {
                obj.size = size.stringValue
            }
            if let text_rotate = path.attribute(forName: "text_rotate") {
                obj.text_rotate = text_rotate.stringValue
            }
            if let text_x = path.attribute(forName: "text_x") {
                obj.text_x = text_x.stringValue
            }
            if let text_y = path.attribute(forName: "text_y") {
                obj.text_y = text_y.stringValue
            }
            if let start_x = path.attribute(forName: "start_x") {
                obj.start_x  = start_x.stringValue
            }
            if let start_y = path.attribute(forName: "start_y") {
                obj.start_y = start_y.stringValue
            }
            if let end_x = path.attribute(forName: "end_x") {
                obj.end_x = end_x.stringValue
            }
            if let end_y = path.attribute(forName: "end_y") {
                obj.end_y = end_y.stringValue
            }
            if let symbol = path.attribute(forName: "symbol") {
                obj.symbol = symbol.stringValue
            }
            if let text = path.attribute(forName: "text") {
                obj.text = text.stringValue
            }
            pathArr.append(obj)
        }
        
        for obj in pathArr {
            if obj.pen_type == "HAND" {
                if obj.pen_shape == "HAND_WRITE" {
                    obj.type = .Pentype(.Curve)
                }else if obj.pen_shape == "ARROW"{
                    //  箭头
                }else if obj.pen_shape == "LINE"{
                    obj.type = .Pentype(.Line)
                }else if obj.pen_shape == "FILL_CIRCLE"{
                    //实心圆
                }else if obj.pen_shape == "HOLLOW_CIRCLE"{
                    obj.type = .Formtype(.Ellipse)
                }else if obj.pen_shape == "FILL_RECT"{
                    //
                }else if obj.pen_shape == "HOLLOW_RECT"{
                    obj.type = .Formtype(.Rect)
                }else if obj.pen_shape == "SYMBOL"{
                    obj.type = .Note
                }
                    
            }else if obj.pen_type == "ERASER" {
                obj.type = .Eraser
            }else if obj.pen_type == "TEXT" {
                obj.type = .Text
            }
            self.autoDraw(obj: obj)
        }
    }
    
    func autoDraw(obj:PathModel){
        var dwidth:CGFloat = 0.0
        switch obj.type! {
        case .Pentype(.Curve):
            print("曲线")
            self.segment.selectedSegmentIndex = 0
            self.colorBtn.backgroundColor = UIColor.haxString(hex: obj.color!)
            
            dwidth = obj.pen_width != nil ? obj.pen_width!.floatValue/2.0 : 20
            
            self.drawContext.initBrush(type: .Pentype(.Curve), color: obj.color, width: dwidth)
            if let pointStr = obj.point_list {
                self.draw(points: pointStr)
            }
            
        case .Pentype(.Line):
            print("直线")
//            self.segment.selectedSegmentIndex = 0
            self.colorBtn.backgroundColor = UIColor.haxString(hex: obj.color!)
            dwidth = obj.pen_width != nil ? obj.pen_width!.floatValue/2.0 : 20
           self.drawContext.initBrush(type: .Pentype(.Line), color: obj.color, width: dwidth)
            if let x = obj.start_x, let y = obj.start_y {
                self.drawPoint(point: CGPoint(x: x.floatValue, y: y.floatValue), state: .begin)
            }
            if let x = obj.end_x, let y = obj.end_y {
                self.drawPoint(point: CGPoint(x: x.floatValue, y: y.floatValue), state: .ended)
            }
        case .Pentype(.ImaginaryLine):
            print("虚线")
//            self.segment.selectedSegmentIndex = 0
            self.colorBtn.backgroundColor = UIColor.haxString(hex: obj.color!)
            dwidth = obj.pen_width != nil ? obj.pen_width!.floatValue/2.0 : 20
            self.drawContext.initBrush(type: .Pentype(.ImaginaryLine), color: obj.color, width: dwidth)
            if let x = obj.start_x, let y = obj.start_y {
                self.drawPoint(point: CGPoint(x: x.floatValue, y: y.floatValue), state: .begin)
            }
            if let x = obj.end_x, let y = obj.end_y {
                self.drawPoint(point: CGPoint(x: x.floatValue, y: y.floatValue), state: .ended)
            }
        case .Formtype(.Rect):
            print("矩形")
            self.segment.selectedSegmentIndex = 1
            self.colorBtn.backgroundColor = UIColor.haxString(hex: obj.color!)
            dwidth = obj.pen_width != nil ? obj.pen_width!.floatValue/2.0 : 20
            self.drawContext.initBrush(type: .Formtype(.Rect), color: obj.color, width: dwidth)
            if let x = obj.start_x, let y = obj.start_y {
                self.drawPoint(point: CGPoint(x: x.floatValue, y: y.floatValue), state: .begin)
            }
            if let x = obj.end_x, let y = obj.end_y {
                self.drawPoint(point: CGPoint(x: x.floatValue, y: y.floatValue), state: .ended)
            }
        case .Formtype(.Ellipse):
            print("椭圆")
            self.segment.selectedSegmentIndex = 1
            self.colorBtn.backgroundColor = UIColor.haxString(hex: obj.color!)
            dwidth = obj.pen_width != nil ? obj.pen_width!.floatValue/2.0 : 20
            self.drawContext.initBrush(type: .Formtype(.Ellipse), color: obj.color, width: dwidth)
            if let x = obj.start_x, let y = obj.start_y {
                self.drawPoint(point: CGPoint(x: x.floatValue, y: y.floatValue), state: .begin)
            }
            if let x = obj.end_x, let y = obj.end_y {
                self.drawPoint(point: CGPoint(x: x.floatValue, y: y.floatValue), state: .ended)
            }
        case .Eraser:
            print("橡皮擦")
            self.segment.selectedSegmentIndex = 4
            self.colorBtn.backgroundColor = UIColor.haxString(hex: obj.color!)
            dwidth = obj.pen_width != nil ? obj.pen_width!.floatValue/2.0 : 20
            self.drawContext.initBrush(type: .Eraser, color: obj.color, width: dwidth)
            if let pointStr = obj.point_list {
                self.draw(points: pointStr)
            }
        case .Note:
            print("音符")
            self.segment.selectedSegmentIndex = 3
            self.colorBtn.backgroundColor = UIColor.haxString(hex: obj.color!)
            dwidth = obj.pen_width != nil ? obj.pen_width!.floatValue/2.0 : 20
            self.drawContext.initBrush(type: .Note, color: obj.color, width: dwidth)
            if let x = obj.end_x, let y = obj.end_y,let symbol = obj.symbol {
                self.drawPoint(point: CGPoint(x: x.floatValue, y: y.floatValue), state: .begin , text: symbol)
            }
        case .Text:
            print("文本")
            self.segment.selectedSegmentIndex = 2
            self.colorBtn.backgroundColor = UIColor.haxString(hex: obj.color!)
            dwidth = obj.size != nil ? obj.size!.floatValue/2.0 : 20
            self.drawContext.initBrush(type: .Text, color: obj.color, width: dwidth)
            if let x = obj.text_x, let y = obj.text_y,let text = obj.text {
                self.drawPoint(point: CGPoint(x: x.floatValue, y: y.floatValue), state: .begin,text: text)
            }
        }
        
        if self.segment.selectedSegmentIndex == 2 {
            self.drawContext.showTextVIewUIMsg()
        }else{
            self.drawContext.hideTextViewUIMsg()
        }
    
        self.fontSizeSlide.setValue((Float(dwidth > CGFloat(35.0) ? CGFloat(35.0) : dwidth)), animated: false)
        self.fontSize = (dwidth > CGFloat(35.0) ? CGFloat(35.0) : dwidth)
    
    }
    
    //画线，橡皮擦
    func draw(points:String){
        let pointStrArr = points.components(separatedBy: "-") // componentsSeparatedByString("-")
        var pointsArr:[CGPoint] = []
        for str in pointStrArr {
            if str == "" {
                continue
            }
            let point:CGPoint = CGPointFromString(str)
            pointsArr.append(point)
        }
        
        for i in 0..<pointsArr.count {
            var point = pointsArr[i]
            point.x = point.x * self.wBili
            point.y = point.y * self.hBili
            if i == 0 {
                self.drawContext.drawPoints(state: .begin, point: point)
            }else if i == pointsArr.count - 1 {
                self.drawContext.drawPoints(state: .ended, point: point)
            }else{
                self.drawContext.drawPoints(state: .moved, point: point)
            }
        }
    }
    
    func drawPoint(point:CGPoint,state:DrawingState,text:String?=nil) {
        var p = point
        p.x = p.x * self.wBili
        p.y = p.y * self.hBili
        switch state {
        case .begin:
            self.drawContext.drawPoints(state: .begin, point: p, textStr: text)
        case .moved:
            self.drawContext.drawPoints(state: .moved, point: p, textStr: text)
        case .ended:
            self.drawContext.drawPoints(state: .ended, point: p, textStr: text)
        }
    }
    
    //将全局数组里的数据按画画顺序存进xml文本中
    func saveXml(){
        self.drawContext.saveDrawToXML()
    }
    
    func refresh(){
        func download(){
            var params = [String:AnyObject]()
            params["uid"] = "1" as AnyObject
            DownloadManager.DownloadGet(host: "http://gangqinputest.yusi.tv/", path: "urlparam=note/xmlstr/getxmlbyuid", params: params, successed: {[weak self] (JsonString) in
                print(JsonString ?? "")
                let result = Mapper<XmlModel>().map(JSONString: JsonString!)
                if let obj = result{
                    if obj.returnCode == "0000" && obj.data != nil {
                        if obj.data!.xml_str != "" {
                            let filePath:String = NSHomeDirectory() + "/Documents/DrawText.xml"
                            try! obj.data!.xml_str.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
                        }
                        //读取
                    }else{
                        print("获取数据失败")
                    }
                }else{
                    print("获取数据失败")
                }
            }) {[weak self] (error) in
                print("\(String(describing: error))")
            }
        }
    }
}
