//
//  MetalSizable+Protocol.swift
//  ProjectExamples
//
//  Created by Sergii Polishchuk on 23.12.2020.
//

import Foundation

protocol MetalSizable {}

extension MetalSizable {
    static var size: Int {
        return MemoryLayout<Self>.size
    }
    
    static var stride: Int {
        return MemoryLayout<Self>.stride
    }
    
    static func size(_ count: Int) -> Int {
        return MemoryLayout<Self>.size * count
    }
    
    static func stride(_ count: Int) -> Int {
        return MemoryLayout<Self>.stride * count
    }
}
