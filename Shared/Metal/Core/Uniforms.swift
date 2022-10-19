//
//  Uniforms.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 04.01.2021.
//

import simd

struct Uniforms: MetalSizable {
  var time: Float
  var resolution: simd_float2
  var view: matrix_float4x4
  var inverseView: matrix_float4x4
  var viewProjection: matrix_float4x4
}
