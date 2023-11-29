//
//  File.swift
//  
//
//  Created by Айтолкун Анарбекова on 29.11.2023.
//

import SwiftUI
import AVKit

@available(iOS 14.0, *)
struct VideoPlayer: UIViewControllerRepresentable {
    
    @Binding var player: AVPlayer
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<VideoPlayer>) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        
        controller.player = player
        controller.showsPlaybackControls = false
        return controller
        
    }
    
    func updateUIViewController(
        _ uiViewController: AVPlayerViewController,
        context: UIViewControllerRepresentableContext<VideoPlayer>
    ) {
    
    }
}
