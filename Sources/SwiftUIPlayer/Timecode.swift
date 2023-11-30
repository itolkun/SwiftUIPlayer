//
//  File.swift
//  
//
//  Created by Айтолкун Анарбекова on 29.11.2023.
//

import Foundation
import AVKit

public struct Timecode {
    let title: String
    let time: CMTime
    
    public init(title: String, time: CMTime) {
        self.title = title
        self.time = time
    }
}
