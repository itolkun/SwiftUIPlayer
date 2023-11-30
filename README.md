# SwiftUIPlayer
SwiftUIPlayer is developed by [Aitolkun Anarbekova](https://www.linkedin.com/in/aitolkun/)

## Installation

Navigate to your Xcode project then select `Add Package Dependencies`:
```
https://github.com/itolkun/SwiftUIPlayer.git
```
or search for `SwiftUIPlayer`

## Example
```swift
import SwiftUI
import SwiftUIPlayer
import AVKit

struct ContentView: View {
    let url = "https://video-previews.elements.envatousercontent.com/h264-video-previews/315b5d0f-cca5-41c0-824f-e99e2dcfbe6d/40108191.mp4"
    
    let timecodes = [
        Timecode(title: "Intro", time: CMTime(seconds: 0, preferredTimescale: 1)),
        Timecode(title: "Chapter - 1", time: CMTime(seconds: 9, preferredTimescale: 1)),
        Timecode(title: "Chapter - 2", time: CMTime(seconds: 30, preferredTimescale: 1)),
        Timecode(title: "Chapter - 3", time: CMTime(seconds: 55, preferredTimescale: 1)),
        Timecode(title: "Chapter - 4", time: CMTime(seconds: 69, preferredTimescale: 1))
    ]

    var body: some View {
         SwiftUIPlayer(url: url, timecodes: timecodes)
    }
}
```

## Features

- [x] Easily add a timecodes on your player
- [x] Support for SwiftUI
- [x] Runs on iOS

## Compatibility
This project is written in Swift 5.0 and requires Xcode 15 or newer to build and run.

SwiftUIPlayer is compatible with iOS 14.0 +.

























