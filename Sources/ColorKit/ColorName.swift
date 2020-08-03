//
//  File.swift
//  
//
//  Created by Ashley Chapman on 03/08/2020.
//

import Foundation

struct ColorName: Equatable, CustomStringConvertible {
    
    // Variables
    public var name: String
    public var red: Double
    public var green: Double
    public var blue: Double
    public var alpha: Double
    
    public init(name: String, red: Double, green: Double, blue: Double, alpha: Double) {
        
        self.name = name
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public init(_ red: Double, _ green: Double, _ blue: Double, _ alpha: Double) {
        
        self.name = ""
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    // Returns a value between 0.0 and 100.0, where 100.0 is a perfect match
    public func distanceTo(other: ColorName) -> ColorDistance {
        let xyz1 = XYZ(rgb: self)
        let xyz2 = XYZ(rgb: other)
        let lab1 = LAB(xyz: xyz1)
        let lab2 = LAB(xyz: xyz2)
        return lab1.distance(other: lab2)
    }

    public var description: String {
        return "<RGBA(r: \(red), g: \(green), b: \(blue), a: \(alpha))>"
    }
    
    private func clampedPrecondition(val: Double) {
        
        var value = val
        
        if val > 1 {
            let tmp = val - 1
            value = val - tmp
        } else if val < 0 {
            value = abs(val)
        }
        
        precondition(value >= 0.0 && value <= 1.0, "value (\(value) must be betweem 0.0 and 1.0)")
    }
    
}

func ==(lhs: ColorName, rhs: ColorName) -> Bool {
    return lhs.red == rhs.red && lhs.green == rhs.green && lhs.blue == rhs.blue && lhs.alpha == rhs.alpha
}
