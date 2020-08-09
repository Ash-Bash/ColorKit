//
//  File.swift
//  
//
//  Created by Ashley Chapman on 03/08/2020.
//

import Foundation
import SwiftUI

#if canImport(AppKit) && os(macOS)
import AppKit

public extension NSColor {
    
    public var alphaValue: CGFloat? {
        get {
            var a: CGFloat = 0
            
            self.getWhite(nil, alpha: &a)
            
            return a
        }
    }

    public var whiteValue: CGFloat? {
        get {
            var w: CGFloat = 0
            
            self.getWhite(&w, alpha: nil)
            
            return w
        }
    }

    public var redValue: CGFloat? {
        get {
            var r: CGFloat = 0
            self.getRed(&r, green: nil, blue: nil, alpha: nil)
            
            return r
        }
    }
    public var greenValue: CGFloat? {
        get {
            var g: CGFloat = 0

            self.getRed(nil, green: &g, blue: nil, alpha: nil)
            
            return g
        }
    }
    public var blueValue: CGFloat? {
        get {
            var b: CGFloat = 0
            
            self.getRed(nil, green: nil, blue: &b, alpha: nil)
            return b
        }
    }
    
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            } else if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                     r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                     g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                     b = CGFloat(hexNumber & 0x0000ff) / 255
                     a = 1.0

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
    
    public static func random() -> NSColor {
          let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
          let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
          let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
                
          return NSColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    public static func darkness(color: NSColor, factor: Double) -> NSColor {
        
        var red: Double = Double(color.redValue! * 255)
        var green: Double = Double(color.greenValue! * 255)
        var blue: Double = Double(color.blueValue! * 255)
        var cfactor: Double = -(factor + 0.01)
        
        cfactor = 1 + cfactor
        red *= cfactor
        green *= cfactor
        blue *= cfactor
        
        if red < 0 {
            red = 0
        }
        
        if green < 0 {
            green = 0
        }
        
        if blue < 0 {
            blue = 0
        }
        
        return NSColor(red: CGFloat(red / 255), green: CGFloat(green / 255), blue: CGFloat(blue / 255), alpha: 1.0)
    }
    
    public func darkness(factor: Double) -> NSColor {
        
        var red: Double = Double(self.redValue! * 255)
        var green: Double = Double(self.greenValue! * 255)
        var blue: Double = Double(self.blueValue! * 255)
        var cfactor: Double = -(factor + 0.01)
        
        cfactor = 1 + cfactor
        red *= cfactor
        green *= cfactor
        blue *= cfactor
        
        if red < 0 {
            red = 0
        }
        
        if green < 0 {
            green = 0
        }
        
        if blue < 0 {
            blue = 0
        }
        
        return NSColor(red: CGFloat(red / 255), green: CGFloat(green / 255), blue: CGFloat(blue / 255), alpha: 1.0)
    }
    
    public static func lightness(color: NSColor, factor: Double) -> NSColor {
        
        var red: Double = Double(color.redValue! * 255)
        var green: Double = Double(color.greenValue! * 255)
        var blue: Double = Double(color.blueValue! * 255)
        var cfactor: Double = (factor + 0.01)
        
        cfactor = 1 + cfactor
        red *= cfactor
        green *= cfactor
        blue *= cfactor
        
        if red > 255 {
            red = 255
        }
        
        if green > 255 {
            green = 255
        }
        
        if blue > 255 {
            blue = 255
        }
        
        if red == 0 && green == 0 && blue == 0 {
            red =  (54 * factor)
            green = (54 * factor)
            blue = (54 * factor)
        }
        
        return NSColor(red: CGFloat(red / 255), green: CGFloat(green / 255), blue: CGFloat(blue / 255), alpha: 1.0)
    }
    
    public func lightness(factor: Double) -> NSColor {
        
        var red: Double = Double(self.redValue! * 255)
        var green: Double = Double(self.greenValue! * 255)
        var blue: Double = Double(self.blueValue! * 255)
        var cfactor: Double = (factor + 0.01)
        
        cfactor = 1 + cfactor
        red *= cfactor
        green *= cfactor
        blue *= cfactor
        
        if red > 255 {
            red = 255
        }
        
        if green > 255 {
            green = 255
        }
        
        if blue > 255 {
            blue = 255
        }
        
        if red == 0 && green == 0 && blue == 0 {
            red =  (54 * factor)
            green = (54 * factor)
            blue = (54 * factor)
        }
        
        return NSColor(red: CGFloat(red / 255), green: CGFloat(green / 255), blue: CGFloat(blue / 255), alpha: 1.0)
    }
    
    public static func averageColor(colors: [NSColor]) -> NSColor {
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        var redArray: [CGFloat] = []
        var greenArray: [CGFloat] = []
        var blueArray: [CGFloat] = []
        var alphaArray: [CGFloat] = []
        
        for i in 0..<colors.count {
            
            let color = colors[i]
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            
            color.getRed(&r, green: &g, blue: &b, alpha: &a)
            
            redArray.append(r)
            greenArray.append(g)
            blueArray.append(b)
            alphaArray.append(a)
        }
        
        for i in 0..<redArray.count {
            
            red += redArray[i]
        }
        
        for i in 0..<greenArray.count {
            
            green += greenArray[i]
        }
        
        for i in 0..<blueArray.count {
            
            blue += blueArray[i]
        }
        
        for i in 0..<alphaArray.count {
            
            alpha += alphaArray[i]
        }
        
        red /= CGFloat(redArray.count)
        green /= CGFloat(greenArray.count)
        blue /= CGFloat(blueArray.count)
        alpha /= CGFloat(alphaArray.count)
        
        return NSColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public static func getHexString(color: NSColor) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(
            format: "#%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
    
    public static func setHexString(hex: String) -> NSColor {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    return NSColor(red: r, green: g, blue: b, alpha: a)
                }
            } else if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    a = 1.0

                    return NSColor(red: r, green: g, blue: b, alpha: a)
                }
            }
        }

        return NSColor.clear
    }
    
    public static func textColor(color: NSColor, correctness: Double = 1) -> NSColor {
        var d = CGFloat(0)

        var r = CGFloat(0)
        var g = CGFloat(0)
        var b = CGFloat(0)
        var a = CGFloat(0)

        color.getRed(&r, green: &g, blue: &b, alpha: &a)

        // Counting the perceptive luminance - human eye favors green color...
        let luminance = 1 - ((0.299 * r) + (0.587 * g) + (0.114 * b))

        if luminance < 0.5 {
            d = CGFloat(0 + (0.4 * correctness)) // bright colors - black font
        } else {
            d = CGFloat(1 - (0.4 * correctness)) // dark colors - white font
        }

        return NSColor( red: d, green: d, blue: d, alpha: a)
    }
    
    public func textColor(correctness: Double = 1) -> NSColor {
        var d = CGFloat(0)

        var r = CGFloat(0)
        var g = CGFloat(0)
        var b = CGFloat(0)
        var a = CGFloat(0)

        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        // Counting the perceptive luminance - human eye favors green color...
        let luminance = 1 - ((0.299 * r) + (0.587 * g) + (0.114 * b))

        if luminance < 0.5 {
            d = CGFloat(0 + (0.4 * correctness)) // bright colors - black font
        } else {
            d = CGFloat(1 - (0.4 * correctness)) // dark colors - white font
        }

        return NSColor( red: d, green: d, blue: d, alpha: a)
    }
    
    public static func colorScheme(color: NSColor) -> ColorScheme {
        var r = CGFloat(0)
        var g = CGFloat(0)
        var b = CGFloat(0)
        var a = CGFloat(0)

        color.getRed(&r, green: &g, blue: &b, alpha: &a)

        // Counting the perceptive luminance - human eye favors green color...
        let luminance = 1 - ((0.299 * r) + (0.587 * g) + (0.114 * b))

        if luminance < 0.5 {
            return .light
        } else {
            return .dark
        }
    }
    
    public func colorScheme() -> ColorScheme {
        var r = CGFloat(0)
        var g = CGFloat(0)
        var b = CGFloat(0)
        var a = CGFloat(0)

        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        // Counting the perceptive luminance - human eye favors green color...
        let luminance = 1 - ((0.299 * r) + (0.587 * g) + (0.114 * b))

        if luminance < 0.5 {
            return .light
        } else {
            return .dark
        }
    }
    
    public func inverse() -> NSColor {
        var r:CGFloat = 0.0
        var g:CGFloat = 0.0
        var b:CGFloat = 0.0
        var a:CGFloat = 0.0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return NSColor(red: 1.0-r, green: 1.0 - g, blue: 1.0 - b, alpha: a)
    }
    
    public func between(_ color: NSColor, percentage: CGFloat) -> NSColor {
        let percentage = max(min(percentage, 100), 0) / 100
        switch percentage {
        case 0: return self
        case 1: return color
        default:
            var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            
            self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
            color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

            return NSColor(red: CGFloat(r1 + (r2 - r1) * percentage),
                           green: CGFloat(g1 + (g2 - g1) * percentage),
                           blue: CGFloat(b1 + (b2 - b1) * percentage),
                           alpha: CGFloat(a1 + (a2 - a1) * percentage))
        }
    }
    
    public func isEqualTo(color: NSColor, withTolerance tolerance: CGFloat = 0.0) -> Bool {

        var r1 : CGFloat = 0
        var g1 : CGFloat = 0
        var b1 : CGFloat = 0
        var a1 : CGFloat = 0
        var r2 : CGFloat = 0
        var g2 : CGFloat = 0
        var b2 : CGFloat = 0
        var a2 : CGFloat = 0

        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return
            abs(r1 - r2) <= tolerance &&
            abs(g1 - g2) <= tolerance &&
            abs(b1 - b2) <= tolerance &&
            abs(a1 - a2) <= tolerance
    }
    
    public func distance(match: NSColor) -> Int
    {
        var redDifference : CGFloat = 0
        var greenDifference : CGFloat = 0
        var blueDifference : CGFloat = 0

        redDifference = self.redValue! - match.redValue!;
        greenDifference = self.greenValue! - match.greenValue!;
        blueDifference = self.blueValue! - match.blueValue!;

        return Int(redDifference * redDifference + greenDifference * greenDifference + blueDifference * blueDifference)
    }
    
    public func toColor() -> Color {
        return Color(self)
    }
    
    public func toName() -> String {
        let colorThesaurus = ColorThesaurus.closestMatch(color: self)
        return colorThesaurus.color.name
    }
    
    public func toHex() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(
            format: "#%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
    
    public func toHSBComponents() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
        var h: CGFloat = 0.0
        var s: CGFloat = 0.0
        var b: CGFloat = 0.0
        
        self.getHue(&h, saturation: &s, brightness: &b, alpha: nil)
        
        return (h,s,b)
    }
    
    public func toRGBAComponents() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
    
    public func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat, hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {

        r = self.toRGBAComponents().r
        g = self.toRGBAComponents().g
        b = self.toRGBAComponents().b
        a = self.toRGBAComponents().a
        hue = self.toHSBComponents().hue
        saturation = self.toHSBComponents().saturation
        brightness = self.toHSBComponents().brightness
        
        return (r, g, b, a, hue, saturation, brightness)
    }
}
#endif
