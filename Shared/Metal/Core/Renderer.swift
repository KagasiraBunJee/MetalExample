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
    
    let device: MTLDevice?

    var renderCanvasSize: CGSize = .zero
    
    var objects: [Mesh] = []
    
    var particles = [MetalParticle]()
    var emmitersBuffer: MTLBuffer?
    
    var time: Float = 0
    
    var mtx: matrix_float4x4 = .init()
    
    var aspectRatio: Float {
        didSet {
            sceneProjection = Math.perspective(
                degreesFov: 45,
                aspectRatio: Float(414)/Float(718),
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
        super.init()
        
        commandQueue = self.device?.makeCommandQueue()
        createPipelineState()
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
        vertexDescriptor.attributes[1].offset = SIMD3<Float>.size
        
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
        if let clearFunc = clearFunc {
            clearPass = try? device?.makeComputePipelineState(function: clearFunc)
        }
        do {
            
            if let drawDots = drawDots {
                drawDotsPass = try device?.makeComputePipelineState(function: drawDots)
            }
        } catch let error {
            debugPrint("makeComputePipelineState drawDots error: ", error)
        }
        
        let emmiters = [MetalRoseParticleEmitter().particles,
                        MetalRoseParticleEmitter().particles,
                        MetalRoseParticleEmitter().particles,
                        MetalRoseParticleEmitter().particles,
                        MetalRoseParticleEmitter().particles,
                        MetalRoseParticleEmitter().particles,
                        MetalRoseParticleEmitter().particles,
                        MetalRoseParticleEmitter().particles,
        ]
        particles = emmiters.flatMap { $0 }
//        mtx = makeOrthographicMatrix(left: 0, right: 414, bottom: 0, top: 414, near: -1, far: 1)
        
        //buffer for particles
        emmitersBuffer = device?.makeBuffer(bytes: particles,
                                            length: MemoryLayout<MetalParticle>.stride * particles.count,
                                            options: .cpuCacheModeWriteCombined)
    }
    
    func makeOrthographicMatrix(left: Float, right: Float, bottom: Float, top: Float, near: Float, far: Float) -> [Float] {
          let ral = right + left
          let rsl = right - left
          let tab = top + bottom
          let tsb = top - bottom
          let fan = far + near
          let fsn = far - near
        return [2.0 / rsl, 0.0, 0.0, 0.0,
            0.0, 2.0 / tsb, 0.0, 0.0,
            0.0, 0.0, -2.0 / fsn, 0.0,
            -ral / rsl, -tab / tsb, -fan / fsn, 1.0]
//        return matrix_float4x4(columns: (
//            simd_float4(2.0 / rsl, 0.0, 0.0, 0.0),
//            simd_float4(0.0, 2.0 / tsb, 0.0, 0.0),
//            simd_float4(0.0, 0.0, -2.0 / fsn, 0.0),
//            simd_float4(-ral / rsl, -tab / tsb, -fan / fsn, 1.0)
//        ))
    }
}

extension Renderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        renderCanvasSize = size
//        add(object: GameObject(vertices: [
//            Vertex(position: simd_float3(0.5, 0.5, 0), color: simd_float4(1, 0, 0, 1)),
//            Vertex(position: simd_float3(-0.5, 0.5, 0), color: simd_float4(0, 1, 0, 1)),
//            Vertex(position: simd_float3(-0.5, -0.5, 0), color: simd_float4(0, 0, 1, 1)),
//
//            Vertex(position: simd_float3(0.5, 0.5, 0), color: simd_float4(1, 0, 0, 1)),
//            Vertex(position: simd_float3(-0.5, -0.5, 0), color: simd_float4(0, 0, 1, 1)),
//            Vertex(position: simd_float3(0.5, -0.5, 0), color: simd_float4(1, 0, 1, 1))
//        ]))
//        add(object: CubeObject())
    }

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let renderPipelineState = self.renderPipelineState
//              let clearPass = self.clearPass,
//              let drawDotsPass = self.drawDotsPass
        else { return }
        let commandBuffer = commandQueue?.makeCommandBuffer()
        
        guard let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        renderCommandEncoder.setRenderPipelineState(renderPipelineState)
//        renderCommandEncoder.setDepthStencilState(depthStencilState)
        for object in objects {
            object.encode(renderCommandEncoder)
            object.update(deltaTime: 1.0/Float(view.preferredFramesPerSecond))
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
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
}
