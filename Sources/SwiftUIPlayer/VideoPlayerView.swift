//
//  File.swift
//  
//
//  Created by Айтолкун Анарбекова on 29.11.2023.
//

import SwiftUI
import AVKit

@available(iOS 14.0, *)
struct VideoPlayerView: View {
    
    @State private var isPlaying = false
    @State private var showControls = true
    @State private var timer: Timer?
    
    @State private var isPLayerFullScreen = false
    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation
    
    @State var player: AVPlayer
    let timecodes: [Timecode]
    
    var body: some View {
        
        let controlButtons = PlayerControlButtons(
            isPlaying: $isPlaying,
            timer: $timer,
            showPlayerControlButtons: $showControls,
            isPlayerFullScreen: $isPLayerFullScreen,
            avPlayer: $player,
            timecodes: timecodes
        )
        
        let player = VideoPlayer(player: $player)
        VStack {
            
            ZStack {
                player
                if showControls {
                    controlButtons
                }
                
            }
            .padding(.top)
            .frame(height: frameHeight(for: orientation))
            .onTapGesture {
                withAnimation {
                    showControls.toggle()
                }
                if isPlaying {
                    startTimer()
                }
            }
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                    orientation = UIDevice.current.orientation
                }
            }
            .statusBar(hidden: true)
            .preferredColorScheme(.dark)
            .fullScreenCover(isPresented: $isPLayerFullScreen) {
                ZStack {
                    player
                    if showControls {
                        controlButtons
                    }
                }
                .onTapGesture {
                    withAnimation {
                        showControls.toggle()
                    }
                    if isPlaying {
                        startTimer()
                    }
                }
                .frame(height: frameHeightFullScreen(for: orientation))
                
            }
        }
    }
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
            withAnimation {
                showControls = false
            }
        }
    }
    
    
    private func frameHeightFullScreen(for orientation: UIDeviceOrientation) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        if orientation.isPortrait {
            return UIDevice.current.userInterfaceIdiom == .pad ? screenHeight * 0.4 : screenHeight * 0.33
        }
        else {
            return UIScreen.main.bounds.height
        }
    }
    
    private func frameHeight(for orientation: UIDeviceOrientation) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        if orientation.isLandscape {
            return UIDevice.current.userInterfaceIdiom == .pad ? screenHeight * 0.8 : screenHeight * 0.66
        }
        else {
            return UIDevice.current.userInterfaceIdiom == .pad ? screenHeight * 0.4 : screenHeight * 0.33
        }
    }
}
