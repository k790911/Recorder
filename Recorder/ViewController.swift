//
//  ViewController.swift
//  Recorder
//
//  Created by 김재훈 on 2023/01/14.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func recorder(_ sender: UIButton) {
        do {
            var fileURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            fileURL.append("/testRecord.wav")
            
            print(fileURL)
            
            do {
                let session = AVAudioSession.sharedInstance()
                try session.setCategory(.playAndRecord)
                try session.setActive(true)
            } catch {
                print("record session error occurs: \(error.localizedDescription)")
            }
            
            recorder = try AVAudioRecorder(url: URL(string: fileURL)!, settings: [:])
            recorder.delegate = self
            recorder.record()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func stopRecord(_ sender: UIButton) {
        
        recorder.stop()
        try? AVAudioSession.sharedInstance().setActive(false)
    }
    
    @IBAction func playAudio(_ sender: UIButton) {
        var urlString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        urlString.append("/testRecord.wav")
        
        //let url = Bundle.main.url(forResource: "testRecord", withExtension: "wav")
        
        print(urlString)
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, options: [.allowAirPlay, .allowBluetooth])
            try session.setActive(true)
        } catch {
            print("play session error occurs: \(error.localizedDescription)")
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            //player = try AVAudioPlayer(contentsOf: url!)
            player.delegate = self
            //player.prepareToPlay() // 역할이 무엇인지 확인 필요함
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print(#function)
        
        if flag {
            player.stop()
            try? AVAudioSession.sharedInstance().setActive(false)
            print("audio finish playing.")
        }
    }
}

