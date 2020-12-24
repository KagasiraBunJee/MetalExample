//
//  VideoRenderView.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 22.12.2020.
//

import Foundation
import SwiftUI
import AVFoundation

struct VideoRenderView {
    
    var displayLayer = AVSampleBufferDisplayLayer()
    
    class Coordinator: NSObject {
        var parent: VideoRenderView
        private var videoService: VideoPlaybackService?

        init(_ parent: VideoRenderView) {
            self.parent = parent
            super.init()
//            return
//            guard let fileUrl = Bundle.main.path(forResource: "videoplayback", ofType: "mp4") else { debugPrint("no file");return }
//            self.videoService = VideoPlayback(file: URL(fileURLWithPath: fileUrl))
//            self.videoService?.startReading()
//            parent.displayLayer.requestMediaDataWhenReady(on: DispatchQueue.main) { [weak self] in
//                if let buffer = self?.videoService?.requestSampleBuffer() {
//                    self?.parent.displayLayer.enqueue(buffer)
//                }
//            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

#if os(iOS)
extension VideoRenderView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.layer.addSublayer(displayLayer)
        displayLayer.preventsDisplaySleepDuringVideoPlayback = true
        if let newTimebase = try? CMTimebase(masterClock: CMClockGetHostTimeClock()) {
            CMTimebaseSetTime(newTimebase, time: CMTimeMake(value: 0, timescale: 1))
            CMTimebaseSetRate(newTimebase, rate: 1.0)
            debugPrint("new timebase", newTimebase)
            displayLayer.controlTimebase = newTimebase
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        displayLayer.frame = CGRect(origin: .zero, size: CGSize(width: 400, height: 200))
    }
}
#else
extension VideoRenderView: NSViewRepresentable {
    
    typealias NSViewType = NSView
    
    func makeNSView(context: Context) -> NSView {
        return NSView()
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        
    }
    
}
#endif
