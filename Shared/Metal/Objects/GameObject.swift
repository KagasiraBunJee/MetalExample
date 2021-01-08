//
//  GameObject.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 23.12.2020.
//

import MetalKit

struct Vertex: MetalSizable {
    var position: simd_float3
    var normal: simd_float3 = .zero
    var color: simd_float4
    var texCoord: simd_float2 = .zero
}

protocol Mesh: class {
    var vertexCount: Int { get }

    var position: simd_float3 { get set }
    var scale: simd_float3 { get set }
    var rotation: simd_float3 { get set }
    
    // Lifecycle
    func encode(_ encoder: MTLRenderCommandEncoder)
}

class GameObject: Mesh {
    private var vertices: [Vertex]
    private var vertexBuffer: MTLBuffer?
    private(set) var vertexDescriptor = MTLVertexDescriptor()

    var position: simd_float3 = .zero
    var scale: simd_float3 = .one
    var rotation: simd_float3 = .zero
    
    var material: Material?
    
    var vertexCount: Int {
        return vertices.count
    }
    var instances: Int = 1
    
    var meshes: (modelIOMeshes: [MDLMesh], metalKitMeshes: [MTKMesh])?
    
    init(vertices: [Vertex], vertexBuffer: MTLBuffer?) {
        self.vertices = vertices
        self.vertexBuffer = Engine.device?.makeBuffer(bytes: vertices, length: Vertex.stride(vertices.count), options: .storageModeShared)
        
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
        
        vertexDescriptor.layouts[2].stride = Vertex.stride
    }
    
    init(objectName: String) {
        guard let assetUrl = Bundle.main.url(forResource: objectName, withExtension: "obj"),
              let device = Engine.device else {
            fatalError("no mesh or render device found")
        }
        
        //position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 2
        vertexDescriptor.attributes[0].offset = 0
        
        //normal
        vertexDescriptor.attributes[1].format = .float3
        vertexDescriptor.attributes[1].bufferIndex = 2
        vertexDescriptor.attributes[1].offset = simd_float3.size
        
        //color
        vertexDescriptor.attributes[2].format = .float4
        vertexDescriptor.attributes[2].bufferIndex = 2
        vertexDescriptor.attributes[2].offset = simd_float3.size + simd_float3.size
        
        //texCoords
        vertexDescriptor.attributes[3].format = .float2
        vertexDescriptor.attributes[3].bufferIndex = 2
        vertexDescriptor.attributes[3].offset = simd_float3.size + simd_float4.size + simd_float3.size
        
        vertexDescriptor.layouts[2].stride = Vertex.stride
        
        let meshDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
        (meshDescriptor.attributes[0] as? MDLVertexAttribute)?.name = MDLVertexAttributePosition
        (meshDescriptor.attributes[1] as? MDLVertexAttribute)?.name = MDLVertexAttributeNormal
        (meshDescriptor.attributes[2] as? MDLVertexAttribute)?.name = MDLVertexAttributeColor
        (meshDescriptor.attributes[3] as? MDLVertexAttribute)?.name = MDLVertexAttributeTextureCoordinate
        let bufferAllocator = MTKMeshBufferAllocator(device: device)
        
        let asset = MDLAsset(url: assetUrl, vertexDescriptor: meshDescriptor, bufferAllocator: bufferAllocator)
        do {
            meshes = try MTKMesh.newMeshes(asset: asset, device: device)
        } catch let error {
            debugPrint(error)
        }
        
        vertices = []
        
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.normalizedCoordinates = true
        samplerDescriptor.minFilter = .linear
        samplerDescriptor.magFilter = .linear
        samplerDescriptor.mipFilter = .linear
        let sampler = Engine.device?.makeSamplerState(descriptor: samplerDescriptor)
        guard let newSampler = sampler else { fatalError("no sampler created") }
        
        material = Material(texture: nil, samplerState: newSampler)
    }
    
    func encode(_ encoder: MTLRenderCommandEncoder) {
        
        if let material = material {
            var unsafeMaterial = material
            encoder.setFragmentBytes(&unsafeMaterial, length: Material.stride, index: 1)
            
            if let texture = material.texture, material.shouldUseTex {
                encoder.setFragmentTexture(texture, index: 0)
            }
            encoder.setFragmentSamplerState(material.samplerState, index: 0)
        }
        
        if meshes != nil {
            encodeMeshes(encoder)
        } else {
            memcpy(vertexBuffer?.contents(), &vertices, Vertex.stride(vertices.count))
            encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 2)
        }
    }
    
    func encodeMeshes(_ encoder: MTLRenderCommandEncoder) {
        guard let meshes = meshes else { return }
        for mesh in meshes.metalKitMeshes {
            for vertexBuffer in mesh.vertexBuffers {
                encoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 2)
                for subMesh in mesh.submeshes {
                    encoder.drawIndexedPrimitives(
                        type: subMesh.primitiveType,
                        indexCount: subMesh.indexCount,
                        indexType: subMesh.indexType,
                        indexBuffer: subMesh.indexBuffer.buffer,
                        indexBufferOffset: subMesh.indexBuffer.offset,
                        instanceCount: instances)
                }
            }
        }
    }
}
