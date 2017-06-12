//
//  ScrollViewTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/9.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class ScrollViewTestController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        scroller()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension ScrollViewTestController:UIScrollViewDelegate{
    func scroller(){
        
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: WIDTH, height: ContentHeight))
        scrollView.delegate = self
        scrollView.contentSize = CGSize.init(width:WIDTH * 3 , height: ContentHeight)
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = true
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        
        for i in 0..<3 {
            let scrollViewVC = ScrollViewController.init(number: i+1)
            scrollViewVC.view.frame = CGRect.init(x: WIDTH * CGFloat(i), y: 0, width: WIDTH, height: ContentHeight)
            scrollView.addSubview(scrollViewVC.view)
            self.addChildViewController(scrollViewVC)
        }
        view.addSubview(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("x:\(scrollView.contentOffset.x),y:\(scrollView.contentOffset.y)")
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("正在缩放")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        for subview in scrollView.subviews {
            if (subview.firstViewController()?.isKind(of: ScrollViewController.self))! {
                return subview
            }
        }
        return nil
    }
    
}
