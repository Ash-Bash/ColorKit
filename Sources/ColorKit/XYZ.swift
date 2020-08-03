//
//  File.swift
//  
//
//  Created by Ashley Chapman on 03/08/2020.
//

import Foundation

struct XYZ: CustomStringConvertible {
    public let x: Double
    public let y: Double
    public let z: Double

    init(rgb: ColorName) {
        var red = rgb.red
        var green = rgb.green
        var blue = rgb.blue

        if red > 0.04045 {
            red = (red + 0.055) / 1.055
            red = pow(red, 2.4)
        } else {
            red = red / 12.92
        }

        if green > 0.04045 {
            green = (green + 0.055) / 1.055;
            green = pow(green, 2.4);
        } else {
            green = green / 12.92;
        }

        if blue > 0.04045 {
            blue = (blue + 0.055) / 1.055;
            blue = pow(blue, 2.4);
        } else {
            blue = blue / 12.92;
        }

        red *= 100.0
        green *= 100.0
        blue *= 100.0

        self.x = red * 0.4124 + green * 0.3576 + blue * 0.1805
        self.y = red * 0.2126 + green * 0.7152 + blue * 0.0722
        self.z = red * 0.0193 + green * 0.1192 + blue * 0.9505
    }

    public var description: String {
        return "<XYZ(x: \(x), y: \(y), z: \(z))>"
    }
}
