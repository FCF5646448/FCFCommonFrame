//
//  MusicDemoController.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/9.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicDemoController: BaseViewController {

    var audioPlayer = MPMoviePlayerController() //媒体播放控件
    
    var timer:Timer? //计时
    
    var count = 0.0
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "简单的网络音频播放"
        progressView.setProgress(0, animated: false)
        onSetAudio(url: "http://mxd.766.com/sdo/music/data/3/m10.mp3")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        audioPlayer.stop()
        timer?.invalidate()
    }

    //播放歌曲
    func onSetAudio(url:String){
        //暂停当前歌曲的播放
        self.audioPlayer.stop()
        //获取歌曲文件
        self.audioPlayer.contentURL = URL.init(string: url)
        //播放
        self.audioPlayer.play()
        //计时器重置
        timer?.invalidate()
        timeLabel.text = "00:00"
        timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
    }
    
    func update(){
        //当前播放时间
        count += 0.4
        
        let c = audioPlayer.currentPlaybackTime
        if c > 0.0 {
            //总时长
            let t = audioPlayer.duration
            //计算百分比
            let p:CGFloat = CGFloat(c/t)
            //通过百分比设置进度条
            progressView.setProgress(Float(p), animated: true)
            //
            let all:Int = Int(c)
            let m:Int = all % 60
            let f:Int = Int(all/60)
            var time:String = ""
            if f < 10 {
                time = "0\(f):"
            }else{
                time = "\(f)"
            }
            if m < 10 {
                time += "0\(m)"
            }else{
                time += "\(m)"
            }
            timeLabel.text = time
        }else{
            if count > 400 {
                timer?.invalidate()
            }
        }
    }
    
    deinit {
        audioPlayer.stop()
        timer?.invalidate()
    }
    
}
