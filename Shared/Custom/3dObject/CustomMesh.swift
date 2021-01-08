//
//  CustomMesh.swift
//  ProjectExamples
//
//  Created by Sergei on 1/7/21.
//

import MetalKit


class CustomMesh: Node {
    
    init() {
        super.init()
        object = GameObject(objectName: "cruiser")
        let textureLoader = MTKTextureLoader(device: Engine.device!)
        guard
            let texture = try? textureLoader.newTexture(
                URL: Bundle.main.url(forResource: "cruiser", withExtension: "bmp")!,
                options: [.origin:MTKTextureLoader.Origin.bottomLeft])
        else { return }
//        rotation *= simd_quatf(angle: Float(90).radians, axis: [0, 1, 0])
        object?.material?.texture = texture
        createRenderPipelineState()
        position.z = 0
    }
    
}
