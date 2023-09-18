//
//  ManagerAudioBackground.swift
//  Alarm
//
//  Created by Carlos Mata on 9/7/23.
//

import AVFoundation

class ManagerAudioBackground: ObservableObject{

    private var audioPlayer: AVAudioPlayer?

    func setupAudioSession(){
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: .mixWithOthers)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
    }
    
    func playSongFromResourcesWithDelay(delayTime: [(id: String, seconds: TimeInterval)]){
        if let audioURL = Bundle.main.url(forResource: "song", withExtension: "mp3") {
            DispatchQueue.global(qos: .background).async {
                for alarm in delayTime {
                    do {
                        self.audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                        self.audioPlayer?.volume = 1.0
                        self.audioPlayer?.numberOfLoops = 0
                        let newTime = self.audioPlayer!.deviceCurrentTime + alarm.seconds
                        print(alarm.seconds)
                        self.audioPlayer?.play(atTime: newTime)
                    } catch {
                        print("Error initializing audio player: \(error.localizedDescription)")
                    }
                }
            }
        }else{
            print("Not working")
        }
    }
    
    func stopSong(){
        audioPlayer?.stop()
    }
}

