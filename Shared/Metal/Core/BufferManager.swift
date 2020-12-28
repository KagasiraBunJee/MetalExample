//
//  BufferManager.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 24.12.2020.
//

import MetalKit

class BufferManager: NSObject {
    
    private var device: MTLDevice
    private var buffers: [MTLBuffer] = []
    
    var maxBuffersInFlight: Int
    var queueReuseSemaphor: DispatchSemaphore
    
    init(device: MTLDevice, maxBuffersInFlight: Int) {
        self.device = device
        self.maxBuffersInFlight = maxBuffersInFlight
        queueReuseSemaphor = .init(value: maxBuffersInFlight)
        super.init()
    }
    
    func prepareBuffer(length: Int, label: String?) -> MTLBuffer? {
        for _ in 0..<maxBuffersInFlight {
            let buffer = device.makeBuffer(length: length, options: .storageModeShared)
            buffer?.label = label
            guard let newBuffer = buffer else { break }
            buffers.append(newBuffer)
        }
        return buffers.first
    }
}
