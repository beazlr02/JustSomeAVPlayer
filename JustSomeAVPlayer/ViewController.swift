//
//  ViewController.swift
//  JustSomeAVPlayer
//
//  Created by Ross Beazley on 05/08/2019.
//  Copyright © 2019 Ross Beazley. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var avplayer : AVPlayer!
    @IBOutlet weak var avplayerHolder : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        testPlayStream()
        
    }

    func testPlayStream()  {
        
        let urlstring = "http://modav-lab-packager.api.bbci.co.uk:7080/usp/labsamples/l2v/prod/iptv_hd_abr_v1_hls/news_l2v.ism/.m3u8"
         avplayer = AVPlayer(url: URL(string: urlstring)!)
        
        
        let playerLayer = AVPlayerLayer(player: avplayer)
        playerLayer.frame = self.avplayerHolder.bounds;
        self.avplayerHolder.layer.addSublayer(playerLayer)
        
        avplayer.play()
        
        
        observeTheAccessLog()
    }
    
    func observeTheAccessLog()
    {/*
        [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(playerItemAccessLogDidProcessNewEntry:)
            name:AVPlayerItemNewAccessLogEntryNotification
            object:_currentlyPlayingPlayerItem];
        
        
        */
        
        NotificationCenter.default.addObserver(self, selector: #selector(newAccessLog(_:)), name: NSNotification.Name.AVPlayerItemNewAccessLogEntry, object: nil)
    }
    
    @objc public func newAccessLog(_ notification:Notification)
    {
        if let playerItem : AVPlayerItem = notification.object as! AVPlayerItem {
            if let accessLog = playerItem.accessLog() {
                if let log = accessLog.events.last {
                    print("Access log \(log.numberOfBytesTransferred )")
                }
            }
        }
    }
    
    @IBAction func playButton()
    {
        avplayer.play()
    }
    
    @IBAction func pauseButton()
    {
        avplayer.pause()
    }
    
    @IBAction func stopButton()
    {
        avplayer.replaceCurrentItem(with: nil)
    }
    
    @IBAction func dumpAccessLog()
    {
        print("Dumping access logs")
        if let accessLog = avplayer.currentItem?.accessLog() {
            accessLog.events.forEach { print($0.description) }
            
            
            let enc = String.Encoding(rawValue: accessLog.extendedLogDataStringEncoding)
            let accessLogString = String(data: accessLog.extendedLogData() ?? Data(), encoding: enc )
            print(accessLogString)
        }
        
    }
    
    @IBAction func dumpErrorLog()
    {
        print("Dumping error logs")
        if let errorLog = avplayer.currentItem?.errorLog() {
            errorLog.events.forEach{ print($0.description) }
            
            let enc = String.Encoding(rawValue: errorLog.extendedLogDataStringEncoding)
            let logString = String(data: errorLog.extendedLogData() ?? Data(), encoding: enc )
            print(logString)
        }
    }
}

