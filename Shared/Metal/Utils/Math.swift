//
//  Math.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 24.12.2020.
//

import MetalKit
import GLKit

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
    
    static func orthographic(left: Float, right: Float, bottom: Float, top: Float, near: Float, far: Float) -> [Float] {
        let ral = right + left
        let rsl = right - left
        let tab = top + bottom
        let tsb = top - bottom
        let fan = far + near
        let fsn = far - near
        return [2.0 / rsl, 0.0, 0.0, 0.0,
            0.0, 2.0 / tsb, 0.0, 0.0,
            0.0, 0.0, -2.0 / fsn, 0.0,
            -ral / rsl, -tab / tsb, -fan / fsn, 1.0]
    }
    
    static func makeLook(
        eye: simd_float3,
        look: simd_float3,
        up: simd_float3
      ) -> matrix_float4x4 {

        let target = eye + look
        return GLKMatrix4MakeLookAt(
          eye.x,
          eye.y,
          eye.z,
          target.x,
          target.y,
          target.z,
          up.x,
          up.y,
          up.z
        ).to_matrix_float4x4()
      }
}
