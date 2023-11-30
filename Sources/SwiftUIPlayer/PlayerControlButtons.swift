//
//  File.swift
//  
//
//  Created by Айтолкун Анарбекова on 29.11.2023.
//

import SwiftUI
import AVKit

@available(iOS 14.0, *)
public struct PlayerControlButtons: View {
    
    @State private var soundOff = false
    @State private var sliderValue: Float = 0
    
    @Binding var isPlaying: Bool
    @Binding var timer: Timer?
    @Binding var showPlayerControlButtons: Bool
    @Binding var isPlayerFullScreen: Bool
    @Binding var avPlayer: AVPlayer
    let timecodes: [Timecode]
    
    private var currentTimeText: String {
       if let duration = avPlayer.currentItem?.duration.seconds {
            let currentTimeInSeconds = Double(sliderValue) * duration
            return formatTime(currentTimeInSeconds)
       }
       return "00:00"
   }
    private var timeLeftText: String {
        if let duration = avPlayer.currentItem?.duration.seconds {
            let totalTimeInSeconds = duration
            let remainingTimeInSeconds = totalTimeInSeconds - (Double(sliderValue) * totalTimeInSeconds)
            return formatTime(remainingTimeInSeconds)
        }
        return "00:00"
    }

    public var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            VStack {
                HStack {
                    Button {
                        isPlayerFullScreen.toggle()
                        startTimer(timeInterval: 5)
                    } label: {
                        Image(systemName: isPlayerFullScreen ? "xmark" :"arrow.up.left.and.arrow.down.right")
                            .frame(height: 20)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    Button {
                        soundOff.toggle()
                        avPlayer.isMuted = soundOff
                        startTimer(timeInterval: 5)
                    } label: {
                        Image(systemName: soundOff ? "speaker.slash.fill" : "speaker.wave.2.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                        
                    }
                    
                }
                .padding(.vertical, screenWidth * 0.01)
                Spacer()
                HStack {
                    Button {
                        seekBackward()
                        startTimer(timeInterval: 5)
                    } label: {
                        Image(systemName: "gobackward.10")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button {
                        if isPlaying {
                            isPlaying = false
                            avPlayer.pause()
                            timer?.invalidate()
                        }
                        else {
                            isPlaying = true
                            avPlayer.play()
                            startTimer(timeInterval: 5)
                        }
                    } label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 38).bold())
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    Button {
                        seekForward()
                        startTimer(timeInterval: 5)
                    } label: {
                        Image(systemName: "goforward.10")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    
                }
                .padding(.horizontal, screenWidth * 0.1)
                
                Spacer()
                VStack (spacing: 5) {
                    CustomProgressBar(
                        value: $sliderValue,
                        avPlayer: $avPlayer,
                        isPlaying: $isPlaying,
                        timecodes: timecodes
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { _ in
                                startTimer(timeInterval: 5)
                            }
                    )
                    HStack {
                        Text("\(currentTimeText) \\ \(timeLeftText)")
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, screenWidth * 0.03)
            .padding(.vertical, screenHeight * 0.03)
            .background(Color.black.opacity(0.4))
        }
    }

    private func startTimer(timeInterval: Double) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { timer in
            withAnimation {
                showPlayerControlButtons = false
            }
        }
    }
    
    private func formatTime(_ timeInSeconds: Double) -> String {
        if timeInSeconds.isFinite {
            let hours = Int(timeInSeconds) / 3600
            let minutes = (Int(timeInSeconds) % 3600) / 60
            let seconds = Int(timeInSeconds) % 60

            if hours > 0 {
                return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            } else {
                return String(format: "%02d:%02d", minutes, seconds)
            }
        } else {
            return "00:00"
        }
    }
    
    private func seekForward() {
        let currentTime = avPlayer.currentTime()
        let newTime = CMTimeAdd(currentTime, CMTime(seconds: 10, preferredTimescale: 1))
        avPlayer.seek(to: newTime)
    }
    
    private func seekBackward() {
        let currentTime = avPlayer.currentTime()
        let newTime = CMTimeSubtract(currentTime, CMTime(seconds: 10, preferredTimescale: 1))
        avPlayer.seek(to: newTime)
    }
}
