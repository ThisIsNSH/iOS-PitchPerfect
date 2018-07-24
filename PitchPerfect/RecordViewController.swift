//
//  RecordViewController.swift
//  PitchPerfect
//
//  Created by Nishant Singh Hada on 23/07/18.
//  Copyright © 2018 Nishant Singh Hada. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController,AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func redordAudio(_ sender: Any) {
        print("Button is pressed")
        recordingLabel.text="Recording in progress"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
    
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath as Any)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        print("Button is pressed")
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        recordingLabel.text="Tap to record"
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "recordSegue", sender: audioRecorder.url)
        }else{
            print("recording failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recordSegue"{
            let playSoundVC = segue.destination as! PlayViewController
            let recordedAudioUrl = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioUrl
        }
    }
    
}

