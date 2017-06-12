//
//  WebKitViewController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/17.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit
import WebKit

class WebKitViewController: BaseViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var progBar: UIProgressView!
    @IBOutlet weak var reloadBtn: UIButton!
    var webview:WKWebView!

    init(){
        webview = WKWebView.init(frame: CGRect.zero)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        webview.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
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
    
    @IBAction func reloadBtnClicked(_ sender: Any) {
        reloadBtn.setImage(UIImage.init(named: "reloadSelected"), for: .normal)
        webview.reload()//
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            if webview.canGoBack {
                backBtn.setImage(UIImage.init(named: "backSelected"), for: .normal)
            }else{
                backBtn.setImage(UIImage.init(named: "backUnselected"), for: .normal)
            }
            if webview.canGoForward{
                forwardBtn.setImage(UIImage.init(named: "forwardSelected"), for: .normal)
            }else{
                forwardBtn.setImage(UIImage.init(named: "forwardUnselected"), for: .normal)
            }
        }
        if keyPath == "estimatedProgress" {
            progBar.setProgress(Float(webview.estimatedProgress), animated: true)
        }
    }
    
    deinit {
        webview.removeObserver(self, forKeyPath: "loading")
        webview.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
}

extension WebKitViewController:WKNavigationDelegate{
    func createUI(){
        view.addSubview(webview)
        webview.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint.init(item: webview, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 2)
        let height = NSLayoutConstraint.init(item: webview, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: -44)
        let width = NSLayoutConstraint.init(item: webview, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        view.addConstraints([top,height,width]) //添加约束

        let url = URL.init(string: "http://www.gangqinpu.com/") //http://www.se5ji.com
        let request = URLRequest.init(url: url!)
        webview.load(request)
        webview.navigationDelegate = self
        webview.uiDelegate = self
    }
    //开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showdownLoading()
    }
    
    //加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        progBar.setProgress(0, animated: false)
    }
    
    //当内容开始返回时
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        hidedownLoading()
        reloadBtn.setImage(UIImage.init(named: "reloadUnselected"), for: .normal)
        self.title = webview.title
    }
    
    //加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        hidedownLoading()
        reloadBtn.setImage(UIImage.init(named: "reloadUnselected"), for: .normal)
        progBar.setProgress(0, animated: false)
        showMsg(error.localizedDescription) //发生错误
    }
    
//    //接受到服务器跳转请求之后
//    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
//        
//    }
//    
//    //收到响应后，决定是否跳转
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        
//    }
    
    //在发送请求前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if navigationAction.navigationType == WKNavigationType.linkActivated && !(navigationAction.request.url?.host?.lowercased().hasPrefix("http://www.gangqinpu.com"))!{
//            decisionHandler(WKNavigationActionPolicy.cancel) //如果不是以http://www.gangqinpu.com开头的东西就不进行跳转
//        }else{
            decisionHandler(WKNavigationActionPolicy.allow)
//        }
    }
    
    //遇到js target='_blank'的标签时创建新的webview
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webview.load(navigationAction.request)
        }
        return nil
    }
}

extension WebKitViewController:WKUIDelegate{
    //替换提示框
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController.init(title: webView.title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (aa) in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

