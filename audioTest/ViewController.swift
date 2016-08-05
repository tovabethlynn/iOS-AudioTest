//
//  ViewController.swift
//  audioTest
//
//  Created by Tova Grobert on 4/26/16.
//  Copyright © 2016 Toes. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    var soundRecorder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    
    var fileName = "audioFile.wav"
    var wavPathTest = ""
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.enabled = false
        
        setUpRecorder()
        
    }
    
    func setUpRecorder() {
        
        let recordSettings = [AVFormatIDKey : NSNumber(int: Int32(kAudioFormatLinearPCM)),
            AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Max.rawValue)),
            AVNumberOfChannelsKey : NSNumber(int: 2),
            AVSampleRateKey : NSNumber(float: Float(44100.0))
        ]
        
        
        do {
            soundRecorder = try AVAudioRecorder(URL: self.getFileURL()!, settings: recordSettings)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        } catch {
            print(error)
            print("something wrong")
        }

    }
    
    func getCacheDirectory() -> NSString {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        return paths[0]
        
    }
    
    func getFileURL() -> NSURL? {
        
        let path = getCacheDirectory().stringByAppendingPathComponent(fileName)
        
        wavPathTest = path
        
        let filePath = NSURL(fileURLWithPath: path)
        
        return filePath
        
    }
    
    @IBAction func record(sender: UIButton) {
        
        if sender.titleLabel?.text == "Record" {
            
            soundRecorder.record()
            sender.setTitle("Stop", forState: .Normal)
            playButton.enabled = false
            
        } else {
            
            soundRecorder.stop()
            sender.setTitle("Record", forState: .Normal)
            playButton.enabled = true
            
        }
    }
    
    @IBAction func play(sender: UIButton) {
        
        if sender.titleLabel?.text == "Play" {
            
            recordButton.enabled = false
            sender.setTitle("Stop", forState: .Normal)
            
            preparePlayer()
            soundPlayer.play()
            
        } else {
            
            soundPlayer.stop()
            sender.setTitle("Play", forState: .Normal)
            recordButton.enabled = true
            
        }
        
    }
    
    func preparePlayer() {
        
        do {
            try soundPlayer = AVAudioPlayer(contentsOfURL: getFileURL()!)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        } catch {
            print("error on prep to play")
        }
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        playButton.enabled = true
        print("did finish recording")
        
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.enabled = true
        playButton.setTitle("Play", forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

