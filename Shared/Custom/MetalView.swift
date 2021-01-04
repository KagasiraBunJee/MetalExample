//
//  MetalView.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 21.12.2020.
//

import MetalKit
import SwiftUI
import AVFoundation

struct MetalView {
    
    class Coordinator: NSObject, VideoPlaybackDelegate {
        var parent: MetalView
        let renderer: Renderer
        
        let cube = CubeObject()
        
        private var videoService: VideoPlaybackService?
        
        let semaphor = DispatchSemaphore(value: 1)
        var displayLayer = AVSampleBufferDisplayLayer()
        
        var audioEngine: AVAudioEngine = AVAudioEngine()
        var audioFilePlayer: AVAudioPlayerNode = AVAudioPlayerNode()
        var downMixer = AVAudioMixerNode()
        
        var avPlayer: AVAudioPlayer?
        var semphr: DispatchSemaphore?
        
        
        init(parent: MetalView, scaleRatio: Float) {
            self.parent = parent
            self.renderer = Renderer(device: Engine.device, screenAspectRatio: scaleRatio)
            super.init()
            self.renderer.add(object: cube)
            return
            let mixNode = AVAudioMixerNode()
//            guard let fileUrl = Bundle.main.path(forResource: "videoplayback", ofType: "mp4") else { debugPrint("no file");return }
//            self.videoService = VideoPlayback(file: URL(fileURLWithPath: fileUrl))
//            self.videoService?.delegate = self
//            self.videoService?.startReading()
//            var i = 0;
//            while (i < 20) { i += 1 }
//            cube.writePixelBuffer(buffer: self.videoService!.requestSampleBuffer()!)
//            parent.displayLayer.requestMediaDataWhenReady(on: DispatchQueue.main) { [weak self] in
//                if let buffer = self?.videoService?.requestSampleBuffer() {
//                    self?.parent.displayLayer.enqueue(buffer)
//                }
//            }
            guard let fileUrl = Bundle.main.path(forResource: "videoplayback", ofType: "mp4") else { debugPrint("no file");return }
            self.videoService = VideoPlayback(file: URL(fileURLWithPath: fileUrl))
            self.videoService?.startReading()
            
//            if let audioBuffer = self.videoService?.requestAuidoSampleBuffer() {
//                let blockBuffer = CMSampleBufferGetDataBuffer(audioBuffer)
//                let blockBufferDataLength = CMBlockBufferGetDataLength(blockBuffer!)
//                var blockBufferData  = [UInt8](repeating: 0, count: blockBufferDataLength)
//                let status = CMBlockBufferCopyDataBytes(blockBuffer!, atOffset: 0, dataLength: blockBufferDataLength, destination: &blockBufferData)
//                guard status == noErr else { return }
//                let data = Data(bytes: blockBufferData, count: blockBufferDataLength)
//
//                do {
//                    self.avPlayer = try AVAudioPlayer(data: data)
//                    self.avPlayer?.play()
//                } catch let error {
//                    debugPrint(error)
//                }
//            }
            
            do {
//                    try audioEngine.enableManualRenderingMode(.offline, format: audioFormat, maximumFrameCount: AVAudioFrameCount(samples))
//                    audioEngine.rend
//                    var inputNode = audioEngine.inputNode
                audioEngine.attach(downMixer)
                audioEngine.attach(audioFilePlayer)
//                    mixr.installTap(onBus: 0, bufferSize: AVAudioFrameCount(samples), format: mixr.outputFormat(forBus: 0)) { (buffer, audioTime) in
//                        debugPrint("mixer")
//                    }
//                    audioEngine.connect(inputNode, to: mixr, format: inputNode.inputFormat(forBus: 0))
//                    audioEngine.connect(mixr, to: audioPlayer, format: audioFormat)
                audioEngine.connect(audioFilePlayer, to: downMixer, format: downMixer.outputFormat(forBus: 0))
                audioEngine.connect(downMixer, to: audioEngine.mainMixerNode, format: audioEngine.mainMixerNode.outputFormat(forBus: 0))
                try audioEngine.start()
//
                audioFilePlayer.play()
                DispatchQueue.global(qos: .utility).async { [weak self] in
                    var i = 0
                    self?.semphr = DispatchSemaphore(value: 1)
                    while (i == 0) {
                        self?.semphr?.wait()
                        if let audioBuffer = self?.videoService?.requestAuidoSampleBuffer() {
                            guard let audioDescription = CMSampleBufferGetFormatDescription(audioBuffer) else { return }
                            let samples = CMSampleBufferGetNumSamples(audioBuffer)
                            let audioFormat = AVAudioFormat(cmAudioFormatDescription: audioDescription)
                            var audioBufferList = AudioBufferList()
                            var blockBuffer : CMBlockBuffer?
                            let res = CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(audioBuffer,
                                                                                    bufferListSizeNeededOut: nil,
                                                                                    bufferListOut: &audioBufferList,
                                                                                    bufferListSize: MemoryLayout<AudioBufferList>.size,
                                                                                    blockBufferAllocator: nil,
                                                                                    blockBufferMemoryAllocator: nil,
                                                                                    flags: 0,
                                                                                    blockBufferOut: &blockBuffer)
                            
                            let mBuffers = audioBufferList.mBuffers
                            let pcmBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: AVAudioFrameCount(samples))!
                            pcmBuffer.frameLength = AVAudioFrameCount(samples)
                            pcmBuffer.mutableAudioBufferList.pointee.mBuffers = mBuffers
                            pcmBuffer.mutableAudioBufferList.pointee.mNumberBuffers = 1
                            self?.audioFilePlayer.scheduleBuffer(pcmBuffer, at: nil, options: [], completionHandler: {
                                self?.semphr?.signal()
                            })
                        } else {
                            i = 1
                        }
                    }
                }
                
                
                
            } catch let error {
                debugPrint(error)
            }
            
            displayLayer.requestMediaDataWhenReady(on: DispatchQueue.main) { [weak self] in
                debugPrint("request")
                guard let buffer = self?.videoService?.requestSampleBuffer()
                else { return }
                
//                guard let audioDescription = CMSampleBufferGetFormatDescription(audioBuffer) else { return }
//                let samples = CMSampleBufferGetNumSamples(audioBuffer)
//                let audioFormat = AVAudioFormat(cmAudioFormatDescription: audioDescription)
//                var audioBufferList = AudioBufferList()
//                var blockBuffer : CMBlockBuffer?
//                let res = CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(audioBuffer,
//                                                                        bufferListSizeNeededOut: nil,
//                                                                        bufferListOut: &audioBufferList,
//                                                                        bufferListSize: MemoryLayout<AudioBufferList>.size,
//                                                                        blockBufferAllocator: nil,
//                                                                        blockBufferMemoryAllocator: nil,
//                                                                        flags: 0,
//                                                                        blockBufferOut: &blockBuffer)
//
//                let mBuffers = audioBufferList.mBuffers
//                let pcmBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: AVAudioFrameCount(samples))!
//                pcmBuffer.frameLength = AVAudioFrameCount(samples)
//                pcmBuffer.mutableAudioBufferList.pointee.mBuffers = mBuffers
//                pcmBuffer.mutableAudioBufferList.pointee.mNumberBuffers = 1
//                self?.audioPlayer.scheduleBuffer(pcmBuffer, at: nil, options: [], completionHandler: nil)
                
                self?.displayLayer.enqueue(buffer)
//                self?.cube.writePixelBuffer(buffer: buffer)
            }
        }
        
        func videoPlayback(playback: VideoPlaybackService, videoSampleBuffer: CMSampleBuffer?, timestamp: CMTime) {
//            _ = semaphor.wait(timeout: .distantFuture)
            if let buffer = videoSampleBuffer {
//                cube.writePixelBuffer(buffer: buffer)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, scaleRatio: 1)
    }
}

#if os(iOS)
extension MetalView: UIViewRepresentable {
    typealias UIViewType = MetalCustomView

    func makeUIView(context: Context) -> MetalCustomView {
        let view = MetalCustomView(frame: .zero, device: nil)
        
        let pan = UIPanGestureRecognizer(target: context.coordinator.renderer, action: #selector(context.coordinator.renderer.pan))
        view.addGestureRecognizer(pan)
        
        view.delegate = context.coordinator.renderer
        context.coordinator.renderer.aspectRatio = Float(view.contentScaleFactor)
        
        let displayLayer = context.coordinator.displayLayer
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

    func updateUIView(_ uiView: MetalCustomView, context: Context) {}
}
#else
extension MetalView: NSViewRepresentable {
    typealias NSViewType = MetalCustomView
    
    func makeNSView(context: Context) -> MetalCustomView {
        let view = MetalCustomView(frame: .zero, device: nil)
        view.delegate = context.coordinator.renderer
        return view
    }
    
    func updateNSView(_ nsView: MetalCustomView, context: Context) {}
}
#endif
