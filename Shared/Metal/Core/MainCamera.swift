//
//  MainCamera.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 04.01.2021.
//

import MetalKit

class MainCamera {
    
    private var buildProjection = true
    private var buildView = true
    private var _projectionMatrix = matrix_identity_float4x4
    private var _viewMatrix = matrix_identity_float4x4
    
    var origin: simd_float3 { didSet { buildView = true } }
    var look: simd_float3 { didSet { buildView = true } }
    var up: simd_float3 { didSet { buildView = true } }
    var fovYDegrees: Float { didSet { buildProjection = true } }
    var aspectRatio: Float { didSet { buildProjection = true } }
    var zNear: Float { didSet { buildProjection = true } }
    var zFar: Float { didSet { buildProjection = true } }
    
    public var projectionMatrix: matrix_float4x4 {
        return Math.perspective(degreesFov: fovYDegrees,
                                aspectRatio: aspectRatio,
                                near: zNear,
                                far: zFar)
    }
    
    public var viewMatrix: matrix_float4x4 {
        return Math.makeLook(eye: origin, look: look, up: up)
    }
    
//    public var viewMatrix: matrix_float4x4 {
//        var identity = matrix_identity_float4x4
//        identity.translate(-origin)
//        return identity
//    }
    
    init(origin: simd_float3,
         look: simd_float3,
         up: simd_float3,
         fovYDegrees: Float,
         aspectRatio: Float,
         zNear: Float,
         zFar: Float)
    {
        self.origin = origin
        self.look = look
        self.up = up
        self.fovYDegrees = fovYDegrees
        self.aspectRatio = aspectRatio
        self.zNear = zNear
        self.zFar = zFar
    }
}
