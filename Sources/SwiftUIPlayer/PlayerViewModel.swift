//
//  File.swift
//  
//
//  Created by Айтолкун Анарбекова on 29.11.2023.
//

import Foundation
import AVKit

@available(iOS 14.0, *)
public class PlayerViewModel: ObservableObject {
    
    @Published var player = AVPlayer()
    public var timecodes: [Timecode]
    
    public init(url: String, timecodes: [Timecode]) {
        self.timecodes = timecodes
        if let videoURL = URL(string: url) {
            player = AVPlayer(url: videoURL)
        }
    }
    
}
