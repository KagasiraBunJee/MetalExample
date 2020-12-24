//
//  CubeObject.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 24.12.2020.
//

import MetalKit

class CubeObject: GameObject {
    
    static var sideColors: [simd_float4] = [
        // left
        simd_float4(.random, 1),
        
        // right
        simd_float4(.random, 1),
        
        // top
        simd_float4(.random, 1),
        
        // bottom
        simd_float4(.random, 1),
        
        // front
        simd_float4(.random, 1),
        
        // back
        simd_float4(.random, 1),
    ]
    
    private static var cubeVertecies = [
        // Left
        Vertex(position: simd_float3(-1, -1, -1), color: CubeObject.sideColors[0]),
        Vertex(position: simd_float3(-1, -1, 1), color: CubeObject.sideColors[0]),
        Vertex(position: simd_float3(-1, 1, 1), color: CubeObject.sideColors[0]),
        Vertex(position: simd_float3(-1, -1, -1), color: CubeObject.sideColors[0]),
        Vertex(position: simd_float3(-1, 1, 1), color: CubeObject.sideColors[0]),
        Vertex(position: simd_float3(-1, 1, -1), color: CubeObject.sideColors[0]),
        
        // Right
        Vertex(position: simd_float3(1, 1, 1), color: CubeObject.sideColors[1]),
        Vertex(position: simd_float3(1, -1, -1), color: CubeObject.sideColors[1]),
        Vertex(position: simd_float3(1, 1, -1), color: CubeObject.sideColors[1]),
        Vertex(position: simd_float3(1, -1, -1), color: CubeObject.sideColors[1]),
        Vertex(position: simd_float3(1, 1, 1), color: CubeObject.sideColors[1]),
        Vertex(position: simd_float3(1, -1, 1), color: CubeObject.sideColors[1]),
        
        // Top
        Vertex(position: simd_float3(1, 1, 1), color: CubeObject.sideColors[2]),
        Vertex(position: simd_float3(1, 1, -1), color: CubeObject.sideColors[2]),
        Vertex(position: simd_float3(-1, 1, -1), color: CubeObject.sideColors[2]),
        Vertex(position: simd_float3(1, 1, 1), color: CubeObject.sideColors[2]),
        Vertex(position: simd_float3(-1, 1, -1), color: CubeObject.sideColors[2]),
        Vertex(position: simd_float3(-1, 1, 1), color: CubeObject.sideColors[2]),
        
        // Bottom
        Vertex(position: simd_float3(1, -1, 1), color: CubeObject.sideColors[3]),
        Vertex(position: simd_float3(-1, -1, -1), color: CubeObject.sideColors[3]),
        Vertex(position: simd_float3(1, -1, -1), color: CubeObject.sideColors[3]),
        Vertex(position: simd_float3(1, -1, 1), color: CubeObject.sideColors[3]),
        Vertex(position: simd_float3(-1, -1, 1), color: CubeObject.sideColors[3]),
        Vertex(position: simd_float3(-1, -1, -1), color: CubeObject.sideColors[3]),
        
        // Back
        Vertex(position: simd_float3(1, 1, -1), color: CubeObject.sideColors[4]),
        Vertex(position: simd_float3(-1, -1, -1), color: CubeObject.sideColors[4]),
        Vertex(position: simd_float3(-1, 1, -1), color: CubeObject.sideColors[4]),
        Vertex(position: simd_float3(1, 1, -1), color: CubeObject.sideColors[4]),
        Vertex(position: simd_float3(1, -1, -1), color: CubeObject.sideColors[4]),
        Vertex(position: simd_float3(-1, -1, -1), color: CubeObject.sideColors[4]),
        
        // Front
        Vertex(position: simd_float3(-1, 1, 1), color: CubeObject.sideColors[5]),
        Vertex(position: simd_float3(-1, -1, 1), color: CubeObject.sideColors[5]),
        Vertex(position: simd_float3(1, -1, 1), color: CubeObject.sideColors[5]),
        Vertex(position: simd_float3(1, 1, 1), color: CubeObject.sideColors[5]),
        Vertex(position: simd_float3(-1, 1, 1), color: CubeObject.sideColors[5]),
        Vertex(position: simd_float3(1, -1, 1), color: CubeObject.sideColors[5]),
    ]
    
    init() {
        super.init(vertices: CubeObject.cubeVertecies)
        scale = .one
        position.x = 0
        position.z = -10
    }
    
    override func update(deltaTime: Float) {
//        rotation.x += deltaTime
//        rotation.y += deltaTime
        super.update(deltaTime: deltaTime)
    }
}

extension CubeObject: MetalSizable {}
