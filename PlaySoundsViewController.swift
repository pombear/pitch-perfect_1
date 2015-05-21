//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Lambri Danchev on 23/04/15.
//  Copyright (c) 2015 Lambri Danchev. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var stopPlaybackButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var darthvaderButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!


    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
//            var filePathUrl = NSURL.fileURLWithPath(filePath)
//        }else {
//            println("the filePath is empty")
//        }
//---------------------------------------------------------------------------------------
        // Setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker, error: nil)
        // var options = AVAudioSessionCategoryOptions.DefaultToSpeaker
        
//----------------------------------------------------------------------------------------
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
//----------------------------------------------------------------------------------------
        //AVAudioSessionCategoryOptions,
        // Initialize and prepare the player
        audioPlayer.delegate = self
        audioPlayer.meteringEnabled = true;    
//----------------------------------------------------------------------------------------
    }

    override func viewWillAppear(animated: Bool) {
        //TODO: Hide the stop Button
        stopButton.hidden = true
        playButton.enabled = true
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        //Play audio slooooowly here...
        //println("playAudio slowly");
        playAudioWithVariableSpeed(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        //Play audio fastly here...
        //println("playAudio fastly");
        playAudioWithVariableSpeed(2.0)
    }
    
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        //Play audio like Chipmunk
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        //TODO: play audio like DarthVader
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playDryWetReverb(sender: UIButton) {
        playAudioWithWetDryMixReverb(100)
    }
    
    @IBAction func playWithEcho(sender: UIButton) {
        playAudioWithDelay(2)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        stopButton.enabled = false
        stopButton.hidden = true
        playButton.hidden = false
        playButton.enabled = true
    }
    
    func playAudioWithVariableSpeed(speed: Float){
        audioPlayer.stop()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        playButton.hidden = true
        stopButton.hidden = false
        stopButton.enabled = true
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        playButton.hidden = true
        stopButton.hidden = false
        stopButton.enabled = true
    }
    
    func playAudioWithWetDryMixReverb(blender: Float){
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changeReverbEffect = AVAudioUnitReverb()
        changeReverbEffect.wetDryMix = blender
        audioEngine.attachNode(changeReverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeReverbEffect, format: nil)
        audioEngine.connect(changeReverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        playButton.hidden = true
        stopButton.hidden = false
        stopButton.enabled = true
    }
    
    func playAudioWithDelay(delay: NSTimeInterval){
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changeDelayTime = AVAudioUnitDelay()
        changeDelayTime.delayTime = delay
        audioEngine.attachNode(changeDelayTime)
        
        audioEngine.connect(audioPlayerNode, to: changeDelayTime, format: nil)
        audioEngine.connect(changeDelayTime, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        playButton.hidden = true
        stopButton.hidden = false
        stopButton.enabled = true
    }
    
    @IBAction func playAudio(sender: UIButton){
        audioPlayer.stop()
        audioPlayer.rate = 1.0
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        playButton.hidden = true
        stopButton.hidden = false
        stopButton.enabled = true
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        if(flag){
            stopButton.enabled = false
            stopButton.hidden = true
            playButton.hidden = false
            playButton.enabled = true
        }else {
            println("Playing sound was not successful!")
            //
        }
    }


}
