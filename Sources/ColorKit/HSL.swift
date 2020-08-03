//
//  File.swift
//  
//
//  Created by Ashley Chapman on 03/08/2020.
//

import Foundation

struct HSL: CustomStringConvertible {
    
    // Variables
    public let hue: Double //0-360
    public let saturation: Double // 0-100
    public let lightness: Double // 0-100

    init(rgb: ColorName) {
        let maximum = max(rgb.red, max(rgb.green, rgb.blue))
        let minimum = min(rgb.red, min(rgb.green, rgb.blue))
        var h = 0.0
        var s = 0.0
        let l = (maximum + minimum) / 2.0;

        let delta = maximum - minimum
        if delta != 0 {
            if l > 0.5 {
                s = delta / (2.0 - maximum - minimum)
            } else {
                s = delta / (maximum + minimum)
            }
            if maximum == rgb.red {
                h = (rgb.green - rgb.blue) / delta + (rgb.green < rgb.blue ? 6.0 : 0)
            } else if maximum == rgb.green {
                h = (rgb.blue - rgb.red) / delta + 2.0
            } else if maximum == rgb.blue {
                h = (rgb.red - rgb.green) / delta + 4.0
            }
            h /= 6.0;
            h *= 3.6;
        }
        self.hue = h * 100.0
        self.saturation = s * 100.0
        self.lightness = l * 100.0
    }

    public func isLight(cutoff: Double = 50) -> Bool {
        return lightness >= cutoff
    }

    public func isDark(cutoff: Double = 50) -> Bool {
        return lightness <= cutoff
    }

    public var description: String {
        return "<HSL(hue: \(hue), saturation: \(saturation), lightness: \(lightness))>"
    }
}
