//
//  WebViewTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/17.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class WebViewTestController: BaseViewController {

    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var progBar: UIProgressView!
    var timer:Timer!
    var tf:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTextField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        webview.goBack()
    }
    
    @IBAction func forwardBtnClicked(_ sender: Any) {
        webview.goForward()
    }
    
}

extension WebViewTestController:UITextFieldDelegate{
    func addTextField(){
        tf = UITextField(frame: CGRect.init(x: 0, y: 0, width: WIDTH - 80, height: 25))
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.placeholder = "请输入网址"
        tf.delegate = self
        tf.adjustsFontSizeToFitWidth = true
        tf.minimumFontSize = 13
        tf.returnKeyType = .search
        tf.clearButtonMode = .unlessEditing
        tf.keyboardType = .webSearch
        self.navigationItem.titleView = tf
        webview.delegate = self
        webview.scrollView.bounces = false
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(loadProgress), userInfo: nil, repeats: true)
        timer.invalidate()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let url = textField.text {
            let urlTemp:NSMutableString = NSMutableString(string: url)
            
            if !urlTemp.hasPrefix("http") {
                if urlTemp.hasPrefix("www") {
                    urlTemp.insert("http://", at: 0)
                }else{
                    urlTemp.insert("http://www.", at: 0)
                }
            }
            if !urlTemp.hasSuffix(".com") {
                urlTemp.append(".com")
            }
            loadUrl(urlStr: urlTemp as String)
        }
        return true
    }
    
    func loadUrl(urlStr:String){
        let url = URL.init(string: urlStr)
        let request = URLRequest(url:url!)
        webview.loadRequest(request)
    }
    
    func loadProgress(){
        if progBar.progress >= 1.0 {
            timer.invalidate()
        }else{
            progBar.setProgress(progBar.progress + 0.02, animated: true)
        }
    }
}

extension WebViewTestController:UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        //开始加载
        showdownLoading()
        progBar.setProgress(0, animated: true)
        timer.fire()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //加载完成
        hidedownLoading()
        progBar.setProgress(1, animated: true)
        timer.invalidate()
    }
    //加载失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        hidedownLoading()
        timer.invalidate()
        progBar.setProgress(0, animated: true)
        //加载错误
        if error._code == NSURLErrorCancelled {
            return
        }
        
        showMsg("加载失败")
    }
    
    //拦截网页上的点击事件,return true表示加载链接，return false表示不加载这个链接
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url
        let scheme = url?.scheme
//        if let URL = url,scheme ==  {
//            这里加上自定义的东西
//        }
        return true
    }
    
}





