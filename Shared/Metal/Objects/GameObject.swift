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
    private var objectMatrixBuffer: MTLBuffer?
    private var objectMatrix = matrix_identity_float4x4

    var position: simd_float3 = .zero
    var scale: simd_float3 = .one
    var rotation: simd_float3 = .zero
    
    var timer: Timer?
    
    var vertexCount: Int {
        return vertices.count
    }
    
    init(vertices: [Vertex]) {
        self.vertices = vertices
        vertexBuffer = Engine.device?.makeBuffer(bytes: vertices, length: Vertex.stride(vertices.count), options: .cpuCacheModeWriteCombined)
        objectMatrixBuffer = Engine.device?.makeBuffer(length: matrix_float4x4.stride, options: .cpuCacheModeWriteCombined)
    }
    
    func encode(_ encoder: MTLRenderCommandEncoder) {
        encoder.setVertexBuffer(objectMatrixBuffer, offset: 0, index: 1)
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
    }
    
    func update(deltaTime: Float) {
        updateCoords()
    }
    
    private func updateCoords() {
        var initial = matrix_identity_float4x4
        initial.translate(position)
        initial.scale(scale)
        initial.rotate(angle: rotation.x, .xAxis)
        initial.rotate(angle: rotation.y, .yAxis)
        initial.rotate(angle: rotation.z, .zAxis)
        objectMatrix = initial
        memcpy(objectMatrixBuffer?.contents(), &objectMatrix, matrix_float4x4.stride)
    }
}
