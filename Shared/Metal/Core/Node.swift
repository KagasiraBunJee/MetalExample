//
//  Node.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 04.01.2021.
//

import MetalKit

class Node {
    var position: simd_float3 = .zero
    var scale: simd_float3 = .one
    var rotation: simd_float3 = .zero
    
    var matrix: matrix_float4x4 {
        var result = matrix_identity_float4x4
        result.scale(scale)
        result.rotate(angle: rotation.x, .xAxis)
        result.rotate(angle: rotation.y, .yAxis)
        result.rotate(angle: rotation.z, .zAxis)
        return result
    }
}
