//
//  ControllableNode.swift
//  ProjectExamples
//
//  Created by Sergei on 1/4/21.
//

import Foundation
import simd
#if os(macOS)
import AppKit
#endif

class ControllableNode: Node {
    
    enum MoveDirection: UInt16 {
        case none = 0x0
        case up = 0x7E
        case down = 0x7D
        case left = 0x7B
        case right = 0x7C
    }
    
    let cube = CubeObject()
//    let square = SquareObject()
    var event: Any?
    
    var moveDir: MoveDirection = .none
    var rotate: Bool = false
    
    override init() {
        super.init()
        object = cube
        
        event = NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .leftMouseDragged, .keyUp]) { [weak self] (event) -> NSEvent? in
            if event.type == .keyDown || event.type == .keyUp {
                if let dir = MoveDirection(rawValue: event.keyCode), event.type == .keyDown {
                    self?.moveDir = dir
                } else {
                    self?.moveDir = .none
                }
            } else if event.type == .leftMouseDragged {
                debugPrint(event)
            }
            
            return event
        }
    }
    
    override func render(time: Float,
                         renderer: Renderer,
                         encoder: MTLRenderCommandEncoder,
                         parentTransform: matrix_float4x4) {
        let velocity: Float = 3.0
        let changingValue = velocity*time
        switch moveDir {
        case .up:
            position.y += changingValue
        case .down:
            position.y -= changingValue
        case .left:
            position.x -= changingValue
        case .right:
            position.x += changingValue
        default: break
        }
//        rotation = simd_quatf(angle: Float(90).radians, axis: [1, 0, 0])
//        if (rotation.angle != Float(90).radians) {
//            rotation *= simd_quatf(angle: Float(90 * time), axis: [1, 0, 0])
//        }
//        rotation *= simd_quatf(angle: Float(90), axis: [1, 0, 0])
        super.render(time: time, renderer: renderer, encoder: encoder, parentTransform: parentTransform)
    }
}
