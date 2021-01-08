//
//  Material.swift
//  ProjectExamples
//
//  Created by Sergei on 1/6/21.
//

import MetalKit

struct Material: MetalSizable {
    var color: simd_float4 = .zero {
        didSet {
            shouldUseMatColor = true
            shouldUseTex = false
        }
    }
    private(set) var shouldUseMatColor: Bool = true
    private(set) var shouldUseTex: Bool = false
    var texture: MTLTexture? {
        didSet {
            shouldUseMatColor = false
            shouldUseTex = true
        }
    }
    var samplerState: MTLSamplerState?
    
    init(color: simd_float4) {
        self.color = color
    }
    
    init(texture: MTLTexture?, samplerState: MTLSamplerState) {
        self.texture = texture
        self.samplerState = samplerState
        shouldUseMatColor = false
        shouldUseTex = true
    }
}
