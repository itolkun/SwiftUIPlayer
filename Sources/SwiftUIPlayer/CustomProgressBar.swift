//
//  File.swift
//  
//
//  Created by Айтолкун Анарбекова on 29.11.2023.
//

import SwiftUI
import AVKit

@available(iOS 14.0, *)
public struct CustomProgressBar: UIViewRepresentable {
    
    @Binding var value: Float
    @Binding var avPlayer: AVPlayer
    @Binding var isPlaying: Bool
    
    let timecodes: [Timecode]
        
    private var smallThumbImage: UIImage {
        createThumbImage(size: CGSize(width: 16, height: 16), color: .white)
    }
    
    public func makeUIView(context: UIViewRepresentableContext<CustomProgressBar>) -> UISlider {
        let dashedSlider = DashedSlider(
            avPlayer: self.avPlayer, timecodes: timecodes
        )
        dashedSlider.maximumTrackTintColor = .clear
        dashedSlider.minimumTrackTintColor = .clear
        dashedSlider.setThumbImage(smallThumbImage, for: .normal)
        dashedSlider.value = value
        dashedSlider.addTarget(
            context.coordinator,
            action: #selector(context.coordinator.changed(slider:)),
            for: .valueChanged
        )
        
        context.coordinator.addSliderValueTimeObserver(
            player: avPlayer
        )
        
        
        return dashedSlider
    }
    
    public func updateUIView(
        _ uiView: UISlider,
        context: UIViewRepresentableContext<CustomProgressBar>
    ) {
        uiView.value = value
        uiView.setNeedsDisplay()
    }
    
    func updateSliderValue() {
        let currentTime = avPlayer.currentTime()
        let duration = avPlayer.currentItem?.duration ?? CMTime.zero
        
        if !duration.isIndefinite {
            let value = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
            self.value = value
        }
    }
    
    private func createThumbImage(size: CGSize, color: UIColor) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { context in
            let rect = CGRect(origin: .zero, size: size)
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.fillEllipse(in: rect)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        CustomProgressBar.Coordinator(parent1: self)
    }
    
    public class Coordinator: NSObject {
        var parent: CustomProgressBar

        private var sliderTimeObserver: Any?
        
        init(parent1: CustomProgressBar) {
            parent = parent1
        }

        @objc func changed(slider: UISlider) {
            let duration = parent.avPlayer.currentItem?.duration.seconds ?? 0
            let targetTime = CMTime(seconds: Double(slider.value) * duration, preferredTimescale: 1)
            parent.avPlayer.seek(to: targetTime)
        }

        func addSliderValueTimeObserver(player: AVPlayer) {
            if sliderTimeObserver == nil {
                sliderTimeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { time in
                    self.parent.updateSliderValue()
                }
            }
        }
        
        func detachSliderValueTimeObserver() {
            if let observer = sliderTimeObserver {
                parent.avPlayer.removeTimeObserver(observer)
                sliderTimeObserver = nil
            }
        }
        
        deinit {
            detachSliderValueTimeObserver()
        }
    }
}

@available(iOS 14.0, *)
class DashedSlider: UISlider {
    
    var avPlayer: AVPlayer
    let timecodes: [Timecode]

    init(avPlayer: AVPlayer, timecodes: [Timecode]) {
        self.avPlayer = avPlayer
        self.timecodes = timecodes
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let dashHeight: CGFloat = 4.0
    let timeCodeColor = UIColor(.black).cgColor
    let trackLine = UIColor.gray.cgColor
    let viewedColor = UIColor.white.cgColor
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let viewedX = rect.size.width * CGFloat(value)
        
        context?.setFillColor(trackLine)
        let trackLine = CGRect(x: 0, y: (rect.size.height - dashHeight) / 2, width: rect.size.width, height: dashHeight)
        context?.fill(trackLine)
                
        context?.setFillColor(viewedColor)
        let viewedLine = CGRect(x: 0, y: (rect.size.height - dashHeight) / 2, width: viewedX, height: dashHeight)
        context?.fill(viewedLine)
        
        let totalDuration = CMTimeGetSeconds(
            avPlayer.currentItem?.asset.duration ?? CMTime(seconds: 0, preferredTimescale: 1)
        )
        
        for timecode in timecodes {
            let x = CGFloat(timecode.time.seconds / totalDuration) * rect.size.width
            let dashRect = CGRect(x: x, y: (rect.size.height - dashHeight) / 2, width: 4, height: dashHeight)
            context?.setFillColor(timeCodeColor)
            context?.fill(dashRect)
        }
    }
}
