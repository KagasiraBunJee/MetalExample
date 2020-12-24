//
//  MetalParticle.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 24.12.2020.
//

import MetalKit

struct MetalParticle {
    var color: simd_float4
    var position: simd_float2
    var angle: Float
}

struct MetalRoseParticleEmitter {
    var particles: [MetalParticle] = []
    let particleCount = 360
    
    init() {
        for i in 0...particleCount {
            particles.append(
                MetalParticle(color: simd_float4(0, 0, 0, 1), position: .zero, angle: Float(i).radians)
            )
        }
    }
}
