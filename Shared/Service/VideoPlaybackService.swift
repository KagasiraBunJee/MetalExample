//
//  VideoPlaybackService.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 22.12.2020.
//

import Foundation
import AVFoundation
import CoreImage

@objc
protocol VideoPlaybackDelegate {
    @objc optional func videoPlayback (playback: VideoPlaybackService, audioSampleBuffer: CMSampleBuffer?)
    @objc optional func videoPlayback (playback: VideoPlaybackService, videoSampleBuffer: CMSampleBuffer?, timestamp: CMTime, delay: Double)
}

@objc
protocol VideoPlaybackService {
    weak var delegate: VideoPlaybackDelegate? { get set }

    func startReading()
    func requestSampleBuffer() -> CMSampleBuffer?
}

class VideoPlayback: VideoPlaybackService {
    
//    private var player: AVPlayer
//    private var playerItem: AVPlayerItem
    private var assetReader: AVAssetReader
    private var asset: AVAsset
    
    // asset tracks
    private var audioAssetTrack: AVAssetTrack?
    private var videoAssetTrack: AVAssetTrack?
    
    // asset track outputs
    private var audioAssetTrackOutput: AVAssetReaderTrackOutput?
    private var videoAssetTrackOutput: AVAssetReaderTrackOutput?
    
    var videoSize = CGSize.zero
    weak var delegate: VideoPlaybackDelegate?
    
    var videoSamplesQueue = DispatchQueue.global(qos: .userInteractive)
    
    init(file: URL) {
//        self.playerItem = playerItem
//        AVAssetReader
//        self.player = AVPlayer(playerItem: playerItem)
        asset = AVAsset(url: file)
        assetReader = try! AVAssetReader(asset: asset)
        prepareOutputs()
    }
    
    private func prepareOutputs() {
        audioAssetTrack = asset.tracks(withMediaType: .audio).first
        videoAssetTrack = asset.tracks(withMediaType: .video).first
        
        if let audioAssetTrack = audioAssetTrack {
            debugPrint("adding audio to output")
            let audioOutputSettings = [
                AVFormatIDKey: kAudioFormatLinearPCM
            ]
            audioAssetTrackOutput = AVAssetReaderTrackOutput(track: audioAssetTrack, outputSettings: audioOutputSettings)
            if let audioAssetTrackOutput = audioAssetTrackOutput {
                assetReader.add(audioAssetTrackOutput)
            }
        }
        
        if let videoAssetTrack = videoAssetTrack {
            debugPrint("adding video to output")
            let videoOutputSettings = [
                String(kCVPixelBufferPixelFormatTypeKey): kCVPixelFormatType_32BGRA,
                String(kCVPixelBufferIOSurfacePropertiesKey): [:],
                String(kCVPixelBufferWidthKey): 400,
                String(kCVPixelBufferHeightKey): 200,
            ] as [String: Any]
            videoAssetTrackOutput = AVAssetReaderTrackOutput(track: videoAssetTrack, outputSettings: videoOutputSettings)
            
            if let videoAssetTrackOutput = videoAssetTrackOutput {
                assetReader.add(videoAssetTrackOutput)
            }
            
            var videoFormatDescription: CMVideoFormatDescription?
            if let videoFormatDescs = videoAssetTrack.formatDescriptions as? [CMVideoFormatDescription], videoFormatDescs.count > 0 {
                videoFormatDescription = videoFormatDescs.first
            }
            
            if let videoFormatDescription = videoFormatDescription {
                debugPrint("getting size from description")
                videoSize = CMVideoFormatDescriptionGetPresentationDimensions(videoFormatDescription, usePixelAspectRatio: false, useCleanAperture: false)
            } else {
                debugPrint("natural size")
                videoSize = videoAssetTrack.naturalSize
            }
            
        }
    }
    
    func setSampleBufferAttachments(_ sampleBuffer: CMSampleBuffer) {
        let attachments: CFArray! = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, createIfNecessary: true)
        let dictionary = unsafeBitCast(CFArrayGetValueAtIndex(attachments, 0),
            to: CFMutableDictionary.self)
        let key = Unmanaged.passUnretained(kCMSampleAttachmentKey_DisplayImmediately).toOpaque()
        let value = Unmanaged.passUnretained(kCFBooleanFalse).toOpaque()
        CFDictionarySetValue(dictionary, key, value)
        debugPrint("added")
    }
    
    func requestSampleBuffer() -> CMSampleBuffer? {
        guard let buffer = videoAssetTrackOutput?.copyNextSampleBuffer() else { return nil }
        setSampleBufferAttachments(buffer)
        let timestamp = CMSampleBufferGetPresentationTimeStamp(buffer)
//        CMSetAttachment(buffer, key: kCMSampleBufferAttachmentKey_EmptyMedia, value: kCFBooleanFalse, attachmentMode: kCMAttachmentMode_ShouldNotPropagate)
        return buffer
    }
    
    func startReading() {
        assetReader.startReading()
        return;
        videoSamplesQueue.async { [weak self] in
            guard let videoOutput = self?.videoAssetTrackOutput,
//                  let assetReader = self?.assetReader,
                  let this = self
            else { return }

            var hasBuffer = true
            var delay = 0.0
            while (hasBuffer) {
                guard let buffer = videoOutput.copyNextSampleBuffer() else { hasBuffer = false; break; }
                let timestamp = CMSampleBufferGetPresentationTimeStamp(buffer)
                self?.setSampleBufferAttachments(buffer)
//                CMSetAttachment(buffer, key: kCMSampleAttachmentKey_DisplayImmediately, value: kCFBooleanFalse, attachmentMode: kCMAttachmentMode_ShouldPropagate)
                self?.delegate?.videoPlayback?(playback: this, videoSampleBuffer: buffer, timestamp: timestamp, delay: CMTimeGetSeconds(timestamp) - delay)
                delay = CMTimeGetSeconds(timestamp)
//                self?.delegate?.videoPlayback?(playback: this, videoSampleBuffer: buffer)
            }
            debugPrint("finish reading")
        }
    }
}
