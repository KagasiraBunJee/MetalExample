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
        super.init(vertices: SquareObject.squareVertecies, vertexBuffer: vertexBuffer)
    }
}
