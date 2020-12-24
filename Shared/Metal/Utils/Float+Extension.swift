//
//  Float+Extension.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 23.12.2020.
//

import Foundation

extension Float {
    var radians: Float {
        return self/180.0 * Float.pi
    }
    
    var degrees: Float {
        return self * (180.0 / Float.pi)
    }
}

extension Float: MetalSizable {}
