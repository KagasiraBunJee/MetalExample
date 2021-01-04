//
//  GeneralProtos.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 04.01.2021.
//

import MetalKit

protocol Renderable {
    func render(time: Float,
                renderer: Renderer,
                encoder: MTLRenderCommandEncoder,
                parentTransform: matrix_float4x4)
}

protocol Updatable {
    func update(time: Float)
}

protocol CoordProps {
    var position: simd_float3 { get set }
    var scale: simd_float3 { get set }
    var rotation: simd_float3 { get set }
    var objectMatrix: matrix_float4x4 { get }
}
