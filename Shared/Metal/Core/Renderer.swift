//
//  Renderer.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 23.12.2020.
//

import MetalKit

class Renderer: NSObject {
    private var commandQueue: MTLCommandQueue?
    private var depthStencilState: MTLDepthStencilState?
    private var device: MTLDevice
    private let uniformBufferManager: BufferManager
    private(set) var currentDrawableBuffer = 2
    
    var size: CGSize = .zero
    let scene = RendererScene()
    var aspectRatio: Float {
        didSet {
            scene.camera.aspectRatio = aspectRatio
        }
    }
    
    init(device: MTLDevice?, screenAspectRatio: Float) {
        guard let device = device else { fatalError(" no device ") }
        self.device = device
        self.aspectRatio = screenAspectRatio
        uniformBufferManager = BufferManager(device: device, inflightCount: 3, createBuffer: { (device) in
            return device.makeBuffer(length: Uniforms.size, options: [])
        })
        uniformBufferManager.createBuffers()
        super.init()
        createPipelineState()
    }
    
    private func createPipelineState() {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)
        commandQueue = device.makeCommandQueue()
    }
}

extension Renderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.size = size
        aspectRatio = Float(size.width/size.height)
    }

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor
        else { return }
        let commandBuffer = commandQueue?.makeCommandBuffer()
        
        guard let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        renderCommandEncoder.setDepthStencilState(depthStencilState)
        let uniformBuffer = uniformBufferManager.nextSync()
        let uniformContents = uniformBuffer.contents().bindMemory(to: Uniforms.self, capacity: 1)
        
        uniformContents.pointee.time = Engine.GameTime.totalTime
        uniformContents.pointee.view = scene.camera.viewMatrix
        uniformContents.pointee.inverseView = scene.camera.viewMatrix.inverse
        uniformContents.pointee.viewProjection = scene.camera.projectionMatrix * scene.camera.viewMatrix
        uniformContents.pointee.resolution = [
            Int32(size.width),
            Int32(size.height)
        ]
        
        renderCommandEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 0)
        renderCommandEncoder.setFragmentBuffer(uniformBuffer, offset: 0, index: 0)
        
        scene.render(time: 1.0/Float(view.preferredFramesPerSecond), renderer: self, encoder: renderCommandEncoder, parentTransform: matrix_identity_float4x4)
        renderCommandEncoder.endEncoding()
        
        commandBuffer?.addCompletedHandler({ [weak self] (_) in
            self?.uniformBufferManager.release()
        })
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
}
