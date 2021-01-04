//
//  Renderer.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 23.12.2020.
//

import MetalKit

class Renderer: NSObject {
    var commandQueue: MTLCommandQueue?
    var clearPass: MTLComputePipelineState?
    var drawDotsPass: MTLComputePipelineState?
    var depthStencilState: MTLDepthStencilState?
    var samplerState: MTLSamplerState?
    
    let device: MTLDevice?

    var renderCanvasSize: CGSize = .zero
    var objects: [Mesh] = []
    
    let panSensivity:Float = 10.0
    var lastPanLocation: CGPoint!
    
    let scene = RendererScene()
    let uniformBufferManager: BufferManager
    
    var aspectRatio: Float {
        didSet {
            sceneProjection = Math.perspective(
                degreesFov: 45,
                aspectRatio: aspectRatio,
                near: 0.1,
                far: 1000)
            scene.camera.aspectRatio = aspectRatio
        }
    }
    var sceneProjection: matrix_float4x4
    
    init(device: MTLDevice?, screenAspectRatio: Float) {
        self.device = device
        self.aspectRatio = screenAspectRatio
        self.sceneProjection = Math.perspective(
            degreesFov: 45,
            aspectRatio: self.aspectRatio,
            near: 0.1,
            far: 1000)
        guard let device = device else { fatalError(" no device ") }
        uniformBufferManager = BufferManager(device: device, inflightCount: 3, createBuffer: { (device) in
            return device.makeBuffer(length: Uniforms.size, options: [])
        })
        uniformBufferManager.createBuffers()
        super.init()
        createPipelineState()
    }
    
    @objc
    func pan(panGesture: UIPanGestureRecognizer) {
        
//        switch (panGesture.state) {
//        case .began:
//            lastPanLocation = panGesture.location(in: panGesture.view)
//        case .changed:
//            let pointInView = panGesture.location(in: panGesture.view)
//            let xDelta = Float((lastPanLocation.x - pointInView.x)/renderCanvasSize.width) * panSensivity
//            let yDelta = Float((lastPanLocation.y - pointInView.y)/renderCanvasSize.height) * panSensivity
//            scene.root.object?.rotation.y -= xDelta
//            scene.root.object?.rotation.x -= yDelta
//            lastPanLocation = pointInView
//            break
//        default: break
//        }
    }
    
    func add(object: Mesh) {
//        objects.append(object)
        scene.root.object = object
    }
    
    private func createPipelineState() {
        
        
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilState = device?.makeDepthStencilState(descriptor: depthStencilDescriptor)
        
//        let samplerDescriptor = MTLSamplerDescriptor()
//        samplerDescriptor.minFilter = MTLSamplerMinMagFilter.nearest
//        samplerDescriptor.magFilter = MTLSamplerMinMagFilter.nearest
//        samplerDescriptor.mipFilter = MTLSamplerMipFilter.nearest
//        samplerDescriptor.maxAnisotropy = 1
//        samplerDescriptor.sAddressMode = MTLSamplerAddressMode.clampToEdge
//        samplerDescriptor.tAddressMode = MTLSamplerAddressMode.clampToEdge
//        samplerDescriptor.rAddressMode = MTLSamplerAddressMode.clampToEdge
//        samplerDescriptor.normalizedCoordinates = true
//        samplerDescriptor.lodMinClamp = 0
//        samplerDescriptor.lodMaxClamp = FLT_MAX
//        samplerState = device?.makeSamplerState(descriptor: samplerDescriptor)

        commandQueue = self.device?.makeCommandQueue()
        
//        let firstBuffer = bufferManager.prepareBuffer(length: Vertex.stride(CubeObject.cubeVertecies.count), label: "cube")
        
//        let emmiters = [MetalRoseParticleEmitter().particles,
//                        MetalRoseParticleEmitter().particles,
//                        MetalRoseParticleEmitter().particles,
//                        MetalRoseParticleEmitter().particles,
//                        MetalRoseParticleEmitter().particles,
//                        MetalRoseParticleEmitter().particles,
//                        MetalRoseParticleEmitter().particles,
//                        MetalRoseParticleEmitter().particles,
//        ]
//        particles = emmiters.flatMap { $0 }
//        mtx = makeOrthographicMatrix(left: 0, right: 414, bottom: 0, top: 414, near: -1, far: 1)
        
        //buffer for particles
//        emmitersBuffer = device?.makeBuffer(bytes: particles,
//                                            length: MemoryLayout<MetalParticle>.stride * particles.count,
//                                            options: .cpuCacheModeWriteCombined)
    }
}

extension Renderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        renderCanvasSize = size
        aspectRatio = Float(size.width/size.height)
    }

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor
//              let clearPass = self.clearPass,
//              let drawDotsPass = self.drawDotsPass
        else { return }
        let commandBuffer = commandQueue?.makeCommandBuffer()
        
        guard let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        renderCommandEncoder.setDepthStencilState(depthStencilState)
//        for object in objects {
//            object.encode(renderCommandEncoder)
//            object.update(deltaTime: 1.0/Float(view.preferredFramesPerSecond))
//            if let samplerState = samplerState {
//                renderCommandEncoder.setFragmentSamplerState(samplerState, index: 0)
//            }
//            renderCommandEncoder.setVertexBytes(&sceneProjection, length: matrix_float4x4.stride, index: 2)
//            renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: object.vertexCount)
//        }
        let uniformBuffer = uniformBufferManager.nextSync()
        let uniformContents = uniformBuffer.contents().bindMemory(to: Uniforms.self, capacity: 1)
        
        uniformContents.pointee.time = 0
        uniformContents.pointee.view = scene.camera.viewMatrix
        uniformContents.pointee.inverseView = scene.camera.viewMatrix.inverse
//        uniformContents.pointee.viewProjection = scene.camera.projectionMatrix * scene.camera.viewMatrix
        uniformContents.pointee.viewProjection = scene.camera.viewMatrix
        uniformContents.pointee.resolution = [
            Int32(renderCanvasSize.width * UIScreen.main.scale),
            Int32(renderCanvasSize.height * UIScreen.main.scale)
        ]
        
        renderCommandEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 0)
        renderCommandEncoder.setFragmentBuffer(uniformBuffer, offset: 0, index: 0)
        
//        scene.update(time: 1.0/Float(view.preferredFramesPerSecond))
        scene.render(time: 1.0/Float(view.preferredFramesPerSecond), renderer: self, encoder: renderCommandEncoder, parentTransform: matrix_identity_float4x4)
        renderCommandEncoder.endEncoding()
        
//        var uni = matrix_identity_float4x4
//        let computeCommandEncoder = commandBuffer?.makeComputeCommandEncoder()
//        computeCommandEncoder?.setComputePipelineState(drawDotsPass)
//        computeCommandEncoder?.setTexture(drawable.texture, index: 0)
//        computeCommandEncoder?.setBuffer(emmitersBuffer, offset: 0, index: 0)
//        computeCommandEncoder?.setBytes(&time, length: MemoryLayout<Float>.size, index: 1)
//        computeCommandEncoder?.setBytes(&uni, length: MemoryLayout<Float>.size * 16, index: 2)
//
//        let w = drawDotsPass.threadExecutionWidth
//        let h = drawDotsPass.maxTotalThreadsPerThreadgroup / w
//
//        let threadPerGrid = MTLSize(width: particles.count, height: 1, depth: 1)
//        let threadsPerThreadGroup = MTLSize(width: w, height: 1, depth: 1)
//        computeCommandEncoder?.dispatchThreads(threadPerGrid, threadsPerThreadgroup: threadsPerThreadGroup)
//        computeCommandEncoder?.endEncoding()
        
        commandBuffer?.addCompletedHandler({ [weak self] (_) in
            self?.uniformBufferManager.release()
        })
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
}
