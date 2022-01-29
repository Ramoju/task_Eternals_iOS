//
//  AudioViewController.swift
//  task_Eternals_iOS
//
//  Created by Sravan Sriramoju on 2022-01-27.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    @IBOutlet weak var recordBTNLB: UIButton!
    
    @IBOutlet weak var playBTNLB: UIButton!
    
    var soundRecorder : AVAudioRecorder!
    var soundPlayer : AVAudioPlayer!
        
    var fileName: String = "audioFile.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        playBTNLB.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }
        
        func setupRecorder() {
            let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
            print(audioFilename)
            let recordSetting = [ AVFormatIDKey : kAudioFormatAppleLossless,
                                  AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                                  AVEncoderBitRateKey : 320000,
                                  AVNumberOfChannelsKey : 2,
                                  AVSampleRateKey : 44100.2] as [String : Any]
            
            do {
                soundRecorder = try AVAudioRecorder(url: audioFilename, settings: recordSetting )
                soundRecorder.delegate = self
                soundRecorder.prepareToRecord()
            } catch {
                print(error)
            }
        }
        
        func setupPlayer() {
            let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
            do {
                soundPlayer = try AVAudioPlayer(contentsOf: audioFilename)
                soundPlayer.delegate = self
                soundPlayer.prepareToPlay()
                soundPlayer.volume = 1.0
            } catch {
                print(error)
            }
        }
        
        func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
            playBTNLB.isEnabled = true
        }
        
        func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            recordBTNLB.isEnabled = true
            playBTNLB.setTitle("Play", for: .normal)
        }
    
    @IBAction func recordACT(_ sender: UIButton) {
        if recordBTNLB.titleLabel?.text == "Record" {
            soundRecorder.record()
            recordBTNLB.setTitle("Stop", for: .normal)
            playBTNLB.isEnabled = false
        } else {
            soundRecorder.stop()
            recordBTNLB.setTitle("Record", for: .normal)
            playBTNLB.isEnabled = false
        }
    }
    
    
    @IBAction func playACT(_ sender: UIButton) {
        if playBTNLB.titleLabel?.text == "Play" {
            playBTNLB.setTitle("Stop", for: .normal)
            recordBTNLB.isEnabled = false
            setupPlayer()
            soundPlayer.play()
        } else {
            soundPlayer.stop()
            playBTNLB.setTitle("Play", for: .normal)
            recordBTNLB.isEnabled = false
        }
    }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
