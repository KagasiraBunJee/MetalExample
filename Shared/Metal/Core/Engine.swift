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
}
