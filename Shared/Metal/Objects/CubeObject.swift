//
//  CubeObject.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 24.12.2020.
//

import MetalKit
import VideoToolbox

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
    
    static var cubeVertecies = [
        // Left
//        Vertex(position: simd_float3(-1, -1, -1), color: CubeObject.sideColors[0]),
//        Vertex(position: simd_float3(-1, -1, 1), color: CubeObject.sideColors[0]),
        Vertex(position: simd_float3(-1, -0.3, -1), color: CubeObject.sideColors[0]),
        Vertex(position: simd_float3(-1, -0.3, 1), color: CubeObject.sideColors[0]),
        Vertex(position: simd_float3(-1, 1, 1), color: CubeObject.sideColors[0]),
//        Vertex(position: simd_float3(-1, -1, -1), color: CubeObject.sideColors[0]),
        Vertex(position: simd_float3(-1, -0.3, -1), color: CubeObject.sideColors[0]),
        Vertex(position: simd_float3(-1, 1, 1), color: CubeObject.sideColors[0]),
        Vertex(position: simd_float3(-1, 1, -1), color: CubeObject.sideColors[0]),
        
        // Right
        Vertex(position: simd_float3(1, 1, 1), color: CubeObject.sideColors[1]),
//        Vertex(position: simd_float3(1, -1, -1), color: CubeObject.sideColors[1]),
        Vertex(position: simd_float3(1, -0.3, -1), color: CubeObject.sideColors[1]),
        Vertex(position: simd_float3(1, 1, -1), color: CubeObject.sideColors[1]),
//        Vertex(position: simd_float3(1, -1, -1), color: CubeObject.sideColors[1]),
        Vertex(position: simd_float3(1, -0.3, -1), color: CubeObject.sideColors[1]),
        Vertex(position: simd_float3(1, 1, 1), color: CubeObject.sideColors[1]),
//        Vertex(position: simd_float3(1, -1, 1), color: CubeObject.sideColors[1]),
        Vertex(position: simd_float3(1, -0.3, 1), color: CubeObject.sideColors[1]),
        
        // Top
        Vertex(position: simd_float3(1, 1, 1), color: CubeObject.sideColors[2]),
        Vertex(position: simd_float3(1, 1, -1), color: CubeObject.sideColors[2]),
        Vertex(position: simd_float3(-1, 1, -1), color: CubeObject.sideColors[2]),
        Vertex(position: simd_float3(1, 1, 1), color: CubeObject.sideColors[2]),
        Vertex(position: simd_float3(-1, 1, -1), color: CubeObject.sideColors[2]),
        Vertex(position: simd_float3(-1, 1, 1), color: CubeObject.sideColors[2]),
        
        // Bottom
        Vertex(position: simd_float3(1, -0.3, 1), color: CubeObject.sideColors[3]),
        Vertex(position: simd_float3(-1, -0.3, -1), color: CubeObject.sideColors[3]),
        Vertex(position: simd_float3(1, -0.3, -1), color: CubeObject.sideColors[3]),
        Vertex(position: simd_float3(1, -0.3, 1), color: CubeObject.sideColors[3]),
        Vertex(position: simd_float3(-1, -0.3, 1), color: CubeObject.sideColors[3]),
        Vertex(position: simd_float3(-1, -0.3, -1), color: CubeObject.sideColors[3]),
        
        // Back
        Vertex(position: simd_float3(1, 1, -1), color: CubeObject.sideColors[4]),
//        Vertex(position: simd_float3(-1, -1, -1), color: CubeObject.sideColors[4]),
        Vertex(position: simd_float3(-1, -0.3, -1), color: CubeObject.sideColors[4]),
        Vertex(position: simd_float3(-1, 1, -1), color: CubeObject.sideColors[4]),
        Vertex(position: simd_float3(1, 1, -1), color: CubeObject.sideColors[4]),
//        Vertex(position: simd_float3(1, -1, -1), color: CubeObject.sideColors[4]),
        Vertex(position: simd_float3(1, -0.3, -1), color: CubeObject.sideColors[4]),
//        Vertex(position: simd_float3(-1, -1, -1), color: CubeObject.sideColors[4]),
        Vertex(position: simd_float3(-1, -0.3, -1), color: CubeObject.sideColors[4]),
        
        // Front
        Vertex(position: simd_float3(1, 1, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(0, 1)),
        Vertex(position: simd_float3(-1, 1, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(1, 1)),
        Vertex(position: simd_float3(-1, -0.3, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(1, 0)),
        
        Vertex(position: simd_float3(1, 1, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(0, 1)),
        Vertex(position: simd_float3(-1, -0.3, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(1, 0)),
        Vertex(position: simd_float3(1, -0.3, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(0, 0)),
//        Vertex(position: simd_float3(-1, 1, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(1, 1)), // Top Left
//        Vertex(position: simd_float3(-1, -0.3, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(0, 0)), // Bottom Left
////        Vertex(position: simd_float3(-1, -1, 1), color: CubeObject.sideColors[5]),
////        Vertex(position: simd_float3(1, -1, 1), color: CubeObject.sideColors[5]),
//        Vertex(position: simd_float3(1, -0.3, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(0, 1)),
//        Vertex(position: simd_float3(1, 1, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(1, 0)),
//        Vertex(position: simd_float3(-1, 1, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(0, 0)),
//        Vertex(position: simd_float3(1, -0.3, 1), color: CubeObject.sideColors[5], texCoord: simd_float2(0, 1)),
//        Vertex(position: simd_float3(1, -1, 1), color: CubeObject.sideColors[5]),
    ]
    
    init(vertexBuffer: MTLBuffer? = nil) {
        super.init(vertices: CubeObject.cubeVertecies, vertexBuffer: vertexBuffer)
        scale = .one
        position.x = 0
        position.z = -5
    }
}

extension CubeObject: MetalSizable {}
