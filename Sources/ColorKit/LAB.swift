//
//  File.swift
//  
//
//  Created by Ashley Chapman on 03/08/2020.
//

import Foundation

struct LAB: CustomStringConvertible {
    public let l: Double
    public let a: Double
    public let b: Double

    //    init(l: Double, a: Double, b: Double) {
    //        self.l = l
    //        self.a = a
    //        self.b = b
    //    }

    init(xyz: XYZ) {
        var x = xyz.x / 95.047
        var y = xyz.y / 100.0
        var z = xyz.z / 108.883

        if x > 0.008856 {
            x = pow(x, 1.0/3.0)
        } else {
            x = 7.787 * x + 16.0 / 116.0
        }

        if y > 0.008856 {
            y = pow(y, 1.0/3.0)
        } else {
            y = (7.787 * y) + (16.0 / 116.0)
        }

        if z > 0.008856 {
            z = pow(z, 1.0/3.0)
        } else {
            z = 7.787 * z + 16.0 / 116.0
        }

        self.l = 116.0 * y - 16.0
        self.a = 500.0 * (x - y)
        self.b = 200.0 * (y - z)
    }

    // CIE1994 distance
    public func distance(other: LAB) -> Double {
        let k1 = 0.045
        let k2 = 0.015

        let C1 = sqrt(a * a + b * b)
        let C2 = sqrt(other.a * other.a + other.b * other.b)

        let deltaA = a - other.a
        let deltaB = b - other.b
        let deltaC = C1 - C2
        let deltaH2 = deltaA * deltaA + deltaB * deltaB - deltaC * deltaC
        let deltaH = (deltaH2 > 0.0) ? sqrt(deltaH2) : 0.0;
        let deltaL = l - other.l;

        let sC = 1.0 + k1 * C1
        let sH = 1.0 + k2 * C1

        let vL = deltaL / 1.0
        let vC = deltaC / (1.0 * sC)
        let vH = deltaH / (1.0 * sH)

        let deltaE = sqrt(vL * vL + vC * vC + vH * vH)
        return deltaE
    }
    
    public var description: String {
        return "<LAB(l: \(l), a: \(a), b: \(b))>"
    }
}
