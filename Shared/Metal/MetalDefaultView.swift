//
//  MetalDefaultView.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 23.12.2020.
//

import MetalKit

class MetalCustomView: MTKView {
    
    var vertexBuffer: MTLBuffer?
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device ?? MTLCreateSystemDefaultDevice())
        prepare()
    }
    
    private func prepare() {
        self.framebufferOnly = false
        self.device = Engine.device
        self.colorPixelFormat = .bgra8Unorm
        self.depthStencilPixelFormat = .depth32Float
        self.clearColor = .from(.orange)
    }
}
