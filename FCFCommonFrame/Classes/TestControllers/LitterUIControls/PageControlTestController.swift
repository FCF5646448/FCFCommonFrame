//
//  PageControlTestController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/5/31.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

class PageControlTestController: BaseViewController {

    var course = [(name:"Swift",pic:"swift"),(name:"Xcode",pic:"xcode"),(name:"Java",pic:"java"),(name:"PHP",pic:"php"),(name:"JS",pic:"js"),(name:"React",pic:"react"),(name:"Ruby",pic:"ruby"),(name:"HTML",pic:"html"),(name:"C#",pic:"c#")]
    
    var scrollView:UIScrollView!
    var pageControl:UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PageControl"
        createUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func createUI(){
        scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: WIDTH, height: ContentHeight))
        scrollView.contentSize = CGSize.init(width: WIDTH * CGFloat(course.count), height: ContentHeight)
        scrollView.backgroundColor = UIColor.haxString(hex: "eeeeee")
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        for (seq,item) in course.enumerated() {
            let page = UIView.init(frame: CGRect.init(x: CGFloat(seq) * WIDTH, y: 0, width: WIDTH, height: ContentHeight))
            let imgeView = UIImageView.init(image: UIImage.init(named: item.pic))
            imgeView.frame = CGRect.init(x: 0, y: 0, width: page.width, height: page.height)
            imgeView.contentMode = .scaleAspectFit //这里设置成Fill，图片布局会出现问题,估计是图片大小超过了view的大小
            page.addSubview(imgeView)
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: page.width, height: 24))
            label.text = item.name
            label.textAlignment = .center
            page.addSubview(label)
            self.scrollView.addSubview(page)
        }
        
        //
        pageControl = UIPageControl.init(frame: CGRect.init(x: 0, y: ContentHeight - 50, width: WIDTH, height: 50))
        pageControl.currentPageIndicatorTintColor = UIColor.haxString(hex: MainColor)
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.numberOfPages = course.count
        pageControl.currentPage = 0
        self.view.addSubview(pageControl)
        pageControl.addTarget(self, action: #selector(pageControlPageChanged), for: .valueChanged)
    }
    
    func pageControlPageChanged(sender:UIPageControl){
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true) //这个方法用的不熟
    }

}

extension PageControlTestController:UIScrollViewDelegate{
    //每次滚动结束后调用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width) //scrollView.contentOffset这个不是很熟
        pageControl.currentPage = page
    }
    
}
