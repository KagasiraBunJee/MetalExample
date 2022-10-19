//
//  Node.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 04.01.2021.
//

import MetalKit
import simd

class Node: CoordProps {
    
    var pipelineState: MTLRenderPipelineState?
    
    var children: [Node] = []
    
    var position: simd_float3 = .zero
    var scale: simd_float3 = .one
    var rotation: simd_float3 = .zero
    var objectMatrix: matrix_float4x4 {
        var result = matrix_identity_float4x4
        result.translate(position)
        result.scale(scale)
//        result.rotate(quat: rotation)
        result.rotate(angle: rotation.x, [1, 0, 0])
        result.rotate(angle: rotation.y, [0, 1, 0])
        result.rotate(angle: rotation.z, [0, 0, 1])
        return result
    }
    
    var name = "Node"
    
    var object: GameObject?
    
    init(object: GameObject? = nil) {
        self.object = object
        createRenderPipelineState()
    }
    
    func createRenderPipelineState() {
        guard object != nil else { return }
        let library = Engine.device?.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "first_vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "first_fragment_shader")
        
        let renderPipelineStateDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineStateDescriptor.vertexFunction = vertexFunction
        renderPipelineStateDescriptor.fragmentFunction = fragmentFunction
        renderPipelineStateDescriptor.vertexDescriptor = object?.vertexDescriptor
        renderPipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        do {
            pipelineState = try Engine.device?.makeRenderPipelineState(descriptor: renderPipelineStateDescriptor)
            debugPrint("success pipelineState")
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        
    }
    
    func addChild(node: Node) {
        children.append(node)
    }
}

extension Node: Renderable {
    @objc
    func render(time: Float, renderer: Renderer, encoder: MTLRenderCommandEncoder, parentTransform: matrix_float4x4) {
        var currentTransform = parentTransform * objectMatrix
        if let gameObject = self.object {
            guard let pipelineState = pipelineState else { return }
            encoder.setRenderPipelineState(pipelineState)
            encoder.setVertexBytes(&currentTransform, length: matrix_float4x4.stride, index: 1)
            gameObject.encode(encoder)
            encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: gameObject.vertexCount)
        }
        for node in children {
            node.render(time: time, renderer: renderer, encoder: encoder, parentTransform: currentTransform)
        }
    }
}

extension Node: Updatable {
    func update(time: Float) {
        for node in children {
            node.update(time: time)
        }
    }
}
