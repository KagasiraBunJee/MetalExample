//
//  Engine.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 23.12.2020.
//

import MetalKit

class Engine {
    public static var device = MTLCreateSystemDefaultDevice()
    
    class GameTime {
        private(set) static var totalTime: Float = 0
        static func updateTime(deltaTime: Float) {
            totalTime += deltaTime
        }
    }
    
    class Input {
        static var previousMouseLoc: CGPoint = .zero
        static var mouseLocation: CGPoint = .zero
        static var mouseDeltaLocation: CGPoint = .zero
        
        static var zoomValue: Float = 0
    }
}
