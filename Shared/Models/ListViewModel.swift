//
//  ListViewModel.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 21.12.2020.
//

import Foundation
import Combine
import SwiftUI
import AVFoundation

class ListViewModel: ObservableObject {
    
    @Published var items = [String]()
    @Published var selectedItem: String?
    @Published var videoBuffer: CMSampleBuffer?
    @Published var startReading: Bool = false
    var videoService: VideoPlaybackService?
    
    private let context = CIContext(options: nil)
    private var lastTimeStamp = CMTime.zero
    
    func fetchItems() {
        self.items = [
            "Item 1",
            "Item 2",
            "Item 3"
        ]
        
        guard let fileUrl = Bundle.main.path(forResource: "videoplayback", ofType: "mp4") else { debugPrint("no file");return }
        self.videoService = VideoPlayback(file: URL(fileURLWithPath: fileUrl))
        self.videoService?.delegate = self
        self.videoService?.startReading()
        startReading = true
    }
    
    func selectItem(item: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.selectedItem = item
        }
    }
    
//    func resized(image: UIImage, for size: CGSize) -> UIImage? {
//        let renderer = UIGraphicsImageRenderer(size: size)
//        return renderer.image { (context) in
//            image.draw(in: CGRect(origin: .zero, size: size))
//        }
//    }
}

extension ListViewModel: VideoPlaybackDelegate {
    func videoPlayback(playback: VideoPlaybackService, audioSampleBuffer: CMSampleBuffer?) {
        
    }
    
//    func videoPlayback(playback: VideoPlaybackService, videoSampleBuffer: CMSampleBuffer?, timestamp: CMTime, delay: Double) {
//        guard let videoSampleBuffer = videoSampleBuffer else { return }
//        if let imageBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(videoSampleBuffer) {
//            let ciimage : CIImage = CIImage(cvPixelBuffer: imageBuffer)
//            if let cgImage:CGImage = context.createCGImage(ciimage, from: ciimage.extent) {
//                DispatchQueue.main.async { [weak self] in
//                    self?.videoImage = UIImage(cgImage: cgImage)
//                }
//            }
//        }
//    }
    func videoPlayback(playback: VideoPlaybackService, videoSampleBuffer: CMSampleBuffer?, timestamp: CMTime, delay: Double) {
        guard let videoSampleBuffer = videoSampleBuffer else { return }
        DispatchQueue.main.async { [weak self] in
            self?.videoBuffer = videoSampleBuffer
        }
    }
}
