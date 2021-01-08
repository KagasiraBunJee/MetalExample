//
//  InstancedPawns.swift
//  ProjectExamples
//
//  Created by Sergei on 1/6/21.
//

import MetalKit

class InstancedPawns: Node {
    
    private var instances: Int
    private var objectsCoordBuffer: MTLBuffer
    
    var cubesWide: Int
    var cubesHigh: Int
    var cubesBack: Int
    
    let vidTexSource = VideoTexture(videoUrl: Bundle.main.url(forResource: "videoplayback", withExtension: "mp4")!)
    
    init(cubesWide: Int, cubesHigh: Int, cubesBack: Int) {
        self.cubesWide = cubesWide
        self.cubesHigh = cubesHigh
        self.cubesBack = cubesBack
        self.instances = cubesWide * cubesHigh * cubesBack
        guard let buffer = Engine.device?.makeBuffer(length: matrix_float4x4.stride(instances), options: .storageModeShared) else {
            fatalError("creating buffers error for \(cubesWide * cubesHigh * cubesBack) lengh")
        }
        objectsCoordBuffer = buffer
        super.init(object: CubeObject())
        generateCubes()
        position.z = -2
        vidTexSource?.play(repeat: true)
    }
    
    override func createRenderPipelineState() {
        let library = Engine.device?.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "instanced_vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "first_fragment_shader")
        
        let renderPipelineStateDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineStateDescriptor.vertexFunction = vertexFunction
        renderPipelineStateDescriptor.fragmentFunction = fragmentFunction
        renderPipelineStateDescriptor.vertexDescriptor = object?.vertexDescriptor
        renderPipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        pipelineState = try? Engine.device?.makeRenderPipelineState(descriptor: renderPipelineStateDescriptor)
    }
    
    private func generateCubes() {
        for _ in 0..<instances {
            let _node = Node()
            addChild(node: _node)
        }
    }
    
    override func render(time: Float, renderer: Renderer, encoder: MTLRenderCommandEncoder, parentTransform: matrix_float4x4) {
        let bufferPointer = objectsCoordBuffer.contents().bindMemory(to: matrix_float4x4.self, capacity: children.count)
//        rotation *= simd_quatf(angle: Float(15 * sin(Engine.GameTime.totalTime)).radians * time, axis: [0, 1, -1])
        
        position.z -= sin(Engine.GameTime.totalTime) / 2
        
        let currentTransform = parentTransform * objectMatrix
        
        let halfWide: Float = Float(cubesWide / 2)
        let halfHigh: Float = Float(cubesHigh / 2)
        let halfBack: Float = Float(cubesBack / 2)
        
        let engineTime = Engine.GameTime.totalTime
        var index: Int = 0
        let gap: Float = cos(engineTime / 2) * 15
        for y in stride(from: -halfHigh, to: halfHigh, by: 1.0) {
            let posY = Float(y * gap)
            for x in stride(from: -halfWide, to: halfWide, by: 1.0) {
                let posX = Float(x * gap)
                for z in stride(from: -halfBack, to: halfBack, by: 1.0) {
                    let posZ = Float(z * gap)
                    children[index].position.y = posY
                    children[index].position.x = posX
                    children[index].position.z = posZ
//                    children[index].rotation *= simd_quatf(angle: Float(15).radians * time, axis: [0.5, 1, -1])
//                    children[index].rotation.z -= time * 2
//                    children[index].rotation.y -= time * 2
                    children[index].scale.x = 2.5
                    children[index].scale.y = 1.5
                    bufferPointer.advanced(by: index).pointee = currentTransform * children[index].objectMatrix
                    index += 1
                }
            }
        }
        
//        for (index, childNode) in children.enumerated() {
//            // TODO: try to use advance in array
//            bufferPointer.advanced(by: index).pointee = currentTransform * childNode.objectMatrix
//        }
        guard let pipelineState = pipelineState else { return }
        encoder.setVertexBuffer(objectsCoordBuffer, offset: 0, index: 1)
        encoder.setRenderPipelineState(pipelineState)
        let vertexCount = object?.vertexCount ?? 0
        if let vidTexture = vidTexSource?.createTexture(hostTime: nil) {
            object?.material?.texture = vidTexture
        }
        object?.encode(encoder)
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount, instanceCount: children.count)
    }
}

