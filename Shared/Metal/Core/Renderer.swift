//
//  Renderer.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 23.12.2020.
//

import MetalKit

class Renderer: NSObject {
    var commandQueue: MTLCommandQueue?
    var renderPipelineState: MTLRenderPipelineState?
    var clearPass: MTLComputePipelineState?
    var drawDotsPass: MTLComputePipelineState?
    var depthStencilState: MTLDepthStencilState?
    var samplerState: MTLSamplerState?
    
    let device: MTLDevice?

    var renderCanvasSize: CGSize = .zero
    var objects: [Mesh] = []
    var bufferManager: BufferManager
    
    let panSensivity:Float = 10.0
    var lastPanLocation: CGPoint!
    
//    var particles = [MetalParticle]()
//    var emmitersBuffer: MTLBuffer?
    
//    var time: Float = 0
//    var mtx: matrix_float4x4 = .init()
    
    var aspectRatio: Float {
        didSet {
            sceneProjection = Math.perspective(
                degreesFov: 45,
                aspectRatio: aspectRatio,
                near: 0.1,
                far: 1000)
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
        bufferManager = BufferManager(device: device, maxBuffersInFlight: 3)
        super.init()
        createPipelineState()
    }
    
    @objc
    func pan(panGesture: UIPanGestureRecognizer) {
        
        switch (panGesture.state) {
        case .began:
            lastPanLocation = panGesture.location(in: panGesture.view)
        case .changed:
            let pointInView = panGesture.location(in: panGesture.view)
            let xDelta = Float((lastPanLocation.x - pointInView.x)/renderCanvasSize.width) * panSensivity
            let yDelta = Float((lastPanLocation.y - pointInView.y)/renderCanvasSize.height) * panSensivity
            objects[0].rotation.y -= xDelta
            objects[0].rotation.x -= yDelta
            lastPanLocation = pointInView
            break
        default: break
        }
    }
    
    func add(object: Mesh) {
        objects.append(object)
    }
    
    private func createPipelineState() {
        let library = Engine.device?.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "first_vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "first_fragment_shader")
        let clearFunc = library?.makeFunction(name: "clear_pass_func")
        let drawDots = library?.makeFunction(name: "draw_dots")
        
        let vertexDescriptor = MTLVertexDescriptor()
        
        //position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0
        
        //color
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = simd_float3.size
        
        //texCoords
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].bufferIndex = 0
        vertexDescriptor.attributes[2].offset = simd_float3.size + simd_float4.size
        
        //hasTexture
        vertexDescriptor.attributes[3].format = .int
        vertexDescriptor.attributes[3].bufferIndex = 0
        vertexDescriptor.attributes[3].offset = simd_float3.size + simd_float4.size + simd_float2.size
        
        vertexDescriptor.layouts[0].stride = Vertex.stride
        
        let renderPipelineStateDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineStateDescriptor.vertexFunction = vertexFunction
        renderPipelineStateDescriptor.fragmentFunction = fragmentFunction
        renderPipelineStateDescriptor.vertexDescriptor = vertexDescriptor
        renderPipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float

        renderPipelineState = try? device?.makeRenderPipelineState(descriptor: renderPipelineStateDescriptor)
        
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilState = device?.makeDepthStencilState(descriptor: depthStencilDescriptor)
        
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.minFilter = MTLSamplerMinMagFilter.nearest
        samplerDescriptor.magFilter = MTLSamplerMinMagFilter.nearest
        samplerDescriptor.mipFilter = MTLSamplerMipFilter.nearest
        samplerDescriptor.maxAnisotropy = 1
        samplerDescriptor.sAddressMode = MTLSamplerAddressMode.clampToEdge
        samplerDescriptor.tAddressMode = MTLSamplerAddressMode.clampToEdge
        samplerDescriptor.rAddressMode = MTLSamplerAddressMode.clampToEdge
        samplerDescriptor.normalizedCoordinates = true
        samplerDescriptor.lodMinClamp = 0
        samplerDescriptor.lodMaxClamp = FLT_MAX
        
        do {
            if let clearFunc = clearFunc {
                clearPass = try device?.makeComputePipelineState(function: clearFunc)
            }
            if let drawDots = drawDots {
                drawDotsPass = try device?.makeComputePipelineState(function: drawDots)
            }
            samplerState = try device?.makeSamplerState(descriptor: samplerDescriptor)
        } catch let error {
            debugPrint("makeComputePipelineState drawDots error: ", error)
        }
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
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let renderPipelineState = self.renderPipelineState
//              let clearPass = self.clearPass,
//              let drawDotsPass = self.drawDotsPass
        else { return }
        _ = bufferManager.queueReuseSemaphor.wait(timeout: DispatchTime.distantFuture)
        let commandBuffer = commandQueue?.makeCommandBuffer()
        
        guard let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        renderCommandEncoder.setRenderPipelineState(renderPipelineState)
        renderCommandEncoder.setDepthStencilState(depthStencilState)
        for object in objects {
            object.encode(renderCommandEncoder)
            object.update(deltaTime: 1.0/Float(view.preferredFramesPerSecond))
            if let samplerState = samplerState {
                renderCommandEncoder.setFragmentSamplerState(samplerState, index: 0)
            }
            renderCommandEncoder.setVertexBytes(&sceneProjection, length: matrix_float4x4.stride, index: 2)
            renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: object.vertexCount)
        }
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
            self?.bufferManager.queueReuseSemaphor.signal()
        })
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
}
