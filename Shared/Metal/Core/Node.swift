//
//  Node.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 04.01.2021.
//

import MetalKit
import simd

class Node: CoordProps {
    
    private var children: [Node] = []
    
    var position: simd_float3 = .zero
    var scale: simd_float3 = .one
    var rotation: simd_float3 = .zero
    var objectMatrix: matrix_float4x4 {
        var result = matrix_identity_float4x4
        result.translate(position)
        result.scale(scale)
        result.rotate(angle: rotation.x, .xAxis)
        result.rotate(angle: rotation.y, .yAxis)
        result.rotate(angle: rotation.z, .zAxis)
        return result
    }
    
    var object: Mesh?

    private func updateCoords() {
        
//        objectMatrix = result
//        memcpy(objectMatrixBuffer?.contents(), &objectMatrix, matrix_float4x4.stride)
    }
}

extension Node: Renderable {
    func render(time: Float, renderer: Renderer, encoder: MTLRenderCommandEncoder, parentTransform: matrix_float4x4) {
        var currentTransform = parentTransform * objectMatrix
        if let gameObject = self.object {
            encoder.setVertexBytes(&currentTransform, length: matrix_float4x4.size, index: 1)
            gameObject.encode(encoder)
        }
        for node in children {
            node.render(time: time, renderer: renderer, encoder: encoder, parentTransform: currentTransform)
        }
    }
}

extension Node: Updatable {
    func update(time: Float) {
        if let gameObject = self.object {
            gameObject.update(deltaTime: time)
        }
        for node in children {
            node.update(time: time)
        }
    }
}
