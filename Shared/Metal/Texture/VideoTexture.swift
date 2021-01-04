//
//  VideoTexture.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 04.01.2021.
//

import Foundation
import AVFoundation

public final class VideoTexture {
    private let player: AVPlayer
    private let playerItemVideoOutput: AVPlayerItemVideoOutput
    private let textureCache: CVMetalTextureCache
    
    init?(renderer: Renderer, videoUrl: URL) {
        var textCache: CVMetalTextureCache?
        guard let device = Engine.device else { return nil }
        if CVMetalTextureCacheCreate(
            kCFAllocatorDefault,
            nil,
            device,
            nil,
            &textCache
        ) != kCVReturnSuccess {
            debugPrint("Unable to allocate texture cache.")
            return nil
        }
        
        self.textureCache = textCache!
        
        let asset = AVURLAsset(url: videoUrl)
        
        playerItemVideoOutput = AVPlayerItemVideoOutput(pixelBufferAttributes: [
            String(kCVPixelBufferPixelFormatTypeKey): Int(kCVPixelFormatType_32BGRA)
        ])
        
        let playerItem = AVPlayerItem(asset: asset)
        playerItem.add(playerItemVideoOutput)
        
        player = AVPlayer(playerItem: playerItem)
        player.actionAtItemEnd = .none
    }
    
    /**
     Causes the video to begin playing
     - Parameters:
     - repeat: If true the video will repeat from the beginning once it has completed
     */
    public func play(repeat: Bool) {
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: self.player.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.player.seek(to: CMTime.zero)
            self?.player.play()
        }
        
        player.play()
    }
    
    /// Pauses the video
    public func pause() {
        player.pause()
    }
    
    /**
     When called will extract a MTLTexture from the video.
     - Parameters:
     hostTime: The timestamp of the frame to extract. If nil CACurrentMediaTime is used.
     */
    public func createTexture(hostTime: CFTimeInterval?) -> MTLTexture? {
        var currentTime = CMTime.invalid
        currentTime = playerItemVideoOutput.itemTime(forHostTime: hostTime ?? CACurrentMediaTime())
        
        guard playerItemVideoOutput.hasNewPixelBuffer(forItemTime: currentTime),
              let pixelBuffer = playerItemVideoOutput.copyPixelBuffer(
                forItemTime: currentTime,
                itemTimeForDisplay: nil) else {
            return nil
        }
        
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        
        var cvTextureOut: CVMetalTexture?
        CVMetalTextureCacheCreateTextureFromImage(
            kCFAllocatorDefault,
            self.textureCache,
            pixelBuffer,
            nil,
            .bgra8Unorm,
            width,
            height,
            0,
            &cvTextureOut
        )
        
        guard let cvTexture = cvTextureOut, let inputTexture = CVMetalTextureGetTexture(cvTexture) else {
            debugPrint("Failed to create metal texture")
            return nil
        }
        return inputTexture
    }
}
