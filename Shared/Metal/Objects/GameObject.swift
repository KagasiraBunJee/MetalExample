//
//  GameObject.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 23.12.2020.
//

import MetalKit

struct Vertex: MetalSizable {
    var position: simd_float3
    var color: simd_float4
    var texCoord: simd_float2 = .zero
    var haveTexture: Int = 0
}

protocol Mesh: class {
    var vertexCount: Int { get }

    var position: simd_float3 { get set }
    var scale: simd_float3 { get set }
    var rotation: simd_float3 { get set }
    
    // Lifecycle
    func encode(_ encoder: MTLRenderCommandEncoder)
    func update(deltaTime: Float)
}

class GameObject: Mesh {
    private var vertices: [Vertex]
    private var vertexBuffer: MTLBuffer?
//    private var objectMatrixBuffer: MTLBuffer?
    private var pipelineState: MTLRenderPipelineState?
    private var objectMatrix: matrix_float4x4 {
        var initial = matrix_identity_float4x4
        initial.translate(position)
        initial.scale(scale)
        initial.rotate(angle: rotation.x, .xAxis)
        initial.rotate(angle: rotation.y, .yAxis)
        initial.rotate(angle: rotation.z, .zAxis)
        return initial
    }

    var position: simd_float3 = .zero
    var scale: simd_float3 = .one
    var rotation: simd_float3 = .zero
    
    var vertexCount: Int {
        return vertices.count
    }
    
    init(vertices: [Vertex], vertexBuffer: MTLBuffer?) {
        self.vertices = vertices
        self.vertexBuffer = Engine.device?.makeBuffer(bytes: vertices, length: Vertex.stride(vertices.count), options: .storageModeShared)
//        objectMatrixBuffer = Engine.device?.makeBuffer(length: matrix_float4x4.stride, options: .storageModeShared)
        
        let library = Engine.device?.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "first_vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "first_fragment_shader")
        
        let vertexDescriptor = MTLVertexDescriptor()
        
        //position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 2
        vertexDescriptor.attributes[0].offset = 0
        
        //color
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].bufferIndex = 2
        vertexDescriptor.attributes[1].offset = simd_float3.size
        
        //texCoords
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].bufferIndex = 2
        vertexDescriptor.attributes[2].offset = simd_float3.size + simd_float4.size
        
        //hasTexture
        vertexDescriptor.attributes[3].format = .int
        vertexDescriptor.attributes[3].bufferIndex = 2
        vertexDescriptor.attributes[3].offset = simd_float3.size + simd_float4.size + simd_float2.size
        
        vertexDescriptor.layouts[2].stride = Vertex.stride
        
        let renderPipelineStateDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineStateDescriptor.vertexFunction = vertexFunction
        renderPipelineStateDescriptor.fragmentFunction = fragmentFunction
        renderPipelineStateDescriptor.vertexDescriptor = vertexDescriptor
        renderPipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        pipelineState = try? Engine.device?.makeRenderPipelineState(descriptor: renderPipelineStateDescriptor)
    }
    
    func encode(_ encoder: MTLRenderCommandEncoder) {
        guard let pipelineState = pipelineState else { return }
        encoder.setRenderPipelineState(pipelineState)
        memcpy(vertexBuffer?.contents(), &vertices, Vertex.stride(vertices.count))
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 2)
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount)
    }
    
    func update(deltaTime: Float) {
        position.x += sin(deltaTime)
    }
}
