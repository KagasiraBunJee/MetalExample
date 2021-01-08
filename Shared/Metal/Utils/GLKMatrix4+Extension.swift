//
//  GLKMatrix4+Extension.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 04.01.2021.
//

import GLKit
import simd

extension GLKMatrix4 {
    func to_matrix_float4x4() -> matrix_float4x4 {
        return matrix_float4x4(simd_float4(m00, m01, m02, m03),
                               simd_float4(m10, m11, m12, m13),
                               simd_float4(m20, m21, m22, m23),
                               simd_float4(m30, m31, m32, m33))
    }
}
