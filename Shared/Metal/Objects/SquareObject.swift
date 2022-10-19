//
//  SquareObject.swift
//  ProjectExamples
//
//  Created by Sergei on 1/5/21.
//

import MetalKit

class SquareObject: GameObject {
    static var squareVertecies = [
        Vertex(position: simd_float3(1, 1, 0), color: [1, 0, 0, 1], texCoord: [1, 0]),
        Vertex(position: simd_float3(-1, 1, 0), color: [0, 1, 0, 1], texCoord: [0, 0]),
        Vertex(position: simd_float3(-1, -1, 0), color: [0, 0, 1, 1], texCoord: [0, 1]),
        
        Vertex(position: simd_float3(1, 1, 0), color: [1, 0, 0, 1], texCoord: [1, 0]),
        Vertex(position: simd_float3(-1, -1, 0), color: [0, 0, 1, 1], texCoord: [0, 1]),
        Vertex(position: simd_float3(1, -1, 0), color: [1, 0, 1, 1], texCoord: [1, 1])
    ]
    
    init(vertexBuffer: MTLBuffer? = nil) {
        super.init(vertices: SquareObject.squareVertecies, vertexBuffer: nil)
//        let bufferAllocator = MTKMeshBufferAllocator(device: Engine.device!)
//
//        let sphereMesh = MDLMesh(boxWithExtent: vector_float3(1, 1, 1), segments: vector_uint3(3, 3, 3), inwardNormals: false, geometryType: .triangles, allocator: bufferAllocator)
//        super.init(mesh: sphereMesh)
        
//        let texLoader = MTKTextureLoader(device: Engine.device!)
//        let tex = try? texLoader.newTexture(name: "no_cover", scaleFactor: 1.0, bundle: .main, options: [.generateMipmaps: true])
//
//
//        let samplerDescriptor = MTLSamplerDescriptor()
//        samplerDescriptor.normalizedCoordinates = true
//        samplerDescriptor.minFilter = .linear
//        samplerDescriptor.magFilter = .linear
//        samplerDescriptor.mipFilter = .linear
//        let sampler = Engine.device?.makeSamplerState(descriptor: samplerDescriptor)
//        guard let newSampler = sampler, let loadedTex = tex else { fatalError("no sampler created") }
//
//        material = Material(texture: loadedTex, samplerState: newSampler)
    }
}
