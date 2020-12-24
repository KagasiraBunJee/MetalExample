//
//  Math.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 24.12.2020.
//

import MetalKit

struct Math {
    static func perspective(degreesFov: Float, aspectRatio: Float, near: Float, far: Float) -> matrix_float4x4 {
        let fov = degreesFov.radians
        
        let t = tan(fov/2)
        
        let x: Float = 1 / (aspectRatio * t)
        let y: Float = 1 / t
        let z: Float = -((far + near) / (far - near))
        let w: Float = -((2 * far * near) / (far - near))
        
        var matrix = matrix_identity_float4x4
        matrix.columns = (
            simd_float4(x, 0, 0 ,0),
            simd_float4(0, y, 0, 0),
            simd_float4(0, 0, z, -1),
            simd_float4(0, 0, w, 0)
        )
        return matrix;
    }
}
