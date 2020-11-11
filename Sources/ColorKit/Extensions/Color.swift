//
//  File.swift
//  
//
//  Created by Ashley Chapman on 03/08/2020.
//

import Foundation
import SwiftUI

#if os(iOS) || os(tvOS) || os(watchOS)
  import UIKit
#elseif os(OSX)
  import AppKit
#endif

public extension Color {
    
    public init(hex: String) {
        let hexWithouthash = hex.replacingOccurrences(of: "#", with: "", options: .literal, range: nil)
        let phex = hexWithouthash.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: phex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch phex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    public mutating func setRGB(red: Double, green: Double, blue: Double) {
        self = Color(red: red, green: green, blue: blue)
    }
    
    public mutating func setHSB(hue: Double, saturation: Double, brightness: Double) {
        self = Color(hue: hue, saturation: saturation, brightness: brightness)
    }
    
    public static func random() -> Color {
          let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
          let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
          let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
                
          return Color(hue: Double(hue), saturation: Double(saturation), brightness: Double(brightness))
    }
    
    public static func darkness(color: Color, factor: Double) -> Color {
        
        let coms = color.components()
        var red = CGFloat(coms.r * 255)
        var green = CGFloat(coms.g * 255)
        var blue = CGFloat(coms.b * 255)
        //var alpha = 1.0
        
        var cfactor: CGFloat = -CGFloat(factor + 0.01)
        
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
        
        return Color(red: Double(red / 255), green: Double(green / 255), blue: Double(blue / 255))
    }
    
    public func darkness(factor: Double) -> Color {
        
        let coms = self.components()
        var red = CGFloat(coms.r * 255)
        var green = CGFloat(coms.g * 255)
        var blue = CGFloat(coms.b * 255)
        //var alpha = 1.0
        
        var cfactor: CGFloat = -CGFloat(factor + 0.01)
        
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
        
        return Color(red: Double(red / 255), green: Double(green / 255), blue: Double(blue / 255))
    }
    
    public static func lightness(color: Color, factor: Double) -> Color {
        
        let coms = color.components()
        var red = CGFloat(coms.r * 255)
        var green = CGFloat(coms.g * 255)
        var blue = CGFloat(coms.b * 255)
        //var alpha = 1.0
        
        var cfactor: CGFloat = CGFloat(factor + 0.01)
        
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
            red = CGFloat(54 * factor)
            green = CGFloat(54 * factor)
            blue = CGFloat(54 * factor)
        }
        
        return Color(red: Double(red / 255), green: Double(green / 255), blue: Double(blue / 255))
    }
    
    public func lightness(factor: Double) -> Color {
        
        let coms = self.components()
        var red = CGFloat(coms.r * 255)
        var green = CGFloat(coms.g * 255)
        var blue = CGFloat(coms.b * 255)
        //var alpha = 1.0
        
        var cfactor: CGFloat = CGFloat(factor + 0.01)
        
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
            red = CGFloat(54 * factor)
            green = CGFloat(54 * factor)
            blue = CGFloat(54 * factor)
        }
        
        return Color(red: Double(red / 255), green: Double(green / 255), blue: Double(blue / 255))
    }
    
    public static func getHexString(color: Color) -> String {
        
        let coms = color.components()
        let r = CGFloat(coms.r)
        let g = CGFloat(coms.g)
        let b = CGFloat(coms.b)
        //var a = CGFloat(1)
        
        return String(
            format: "#%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
    
    public static func setHexString(hex: String) -> Color {
        return Color(hex: hex)
    }
    
    public static func textColor(color: Color, correctness: Double = 1) -> Color {
        
        var d = CGFloat(0)

        let coms = color.components()
        let r = CGFloat(coms.r)
        let g = CGFloat(coms.g)
        let b = CGFloat(coms.b)

        // Counting the perceptive luminance - human eye favors green color...
        let luminance = 1 - ((0.299 * r) + (0.587 * g) + (0.114 * b))

        if luminance < 0.5 {
            d = CGFloat(0 + (0.4 * correctness)) // bright colors - black font
        } else {
            d = CGFloat(1 - (0.4 * correctness)) // dark colors - white font
        }

        return Color(red: Double(d), green: Double(d), blue: Double(d))
    }
    
    public func textColor(correctness: Double = 1) -> Color {
        
        var d = CGFloat(0)

        let coms = self.components()
        let r = CGFloat(coms.r)
        let g = CGFloat(coms.g)
        let b = CGFloat(coms.b)

        // Counting the perceptive luminance - human eye favors green color...
        let luminance = 1 - ((0.299 * r) + (0.587 * g) + (0.114 * b))

        if luminance < 0.5 {
            d = CGFloat(0 + (0.4 * correctness)) // bright colors - black font
        } else {
            d = CGFloat(1 - (0.4 * correctness)) // dark colors - white font
        }

        return Color(red: Double(d), green: Double(d), blue: Double(d))
    }
    
    public static func systemColorScheme(color: Color) -> ColorScheme {
        
        let coms = color.components()
        let r = CGFloat(coms.r)
        let g = CGFloat(coms.g)
        let b = CGFloat(coms.b)

        // Counting the perceptive luminance - human eye favors green color...
        let luminance = 1 - ((0.299 * r) + (0.587 * g) + (0.114 * b))

        if luminance < 0.5 {
            return .light
        } else {
            return .dark
        }
    }
    
    public func colorScheme() -> ColorScheme {
        
        let coms = self.components()
        let r = CGFloat(coms.r)
        let g = CGFloat(coms.g)
        let b = CGFloat(coms.b)
        //var a = CGFloat(1)

        // Counting the perceptive luminance - human eye favors green color...
        let luminance = 1 - ((0.299 * r) + (0.587 * g) + (0.114 * b))

        if luminance < 0.5 {
            return .light
        } else {
            return .dark
        }
    }
    
    public static func brightness(color: Color, factor: Double) -> Color {
        
        let coms = color.components()
        var red: Double? = Double(coms.r) * 255
        var green: Double? = Double(coms.g) * 255
        var blue: Double? = Double(coms.b) * 255
        var cfactor: Double = factor + 0.01
        
        if (factor < 0) {
            cfactor = 1 + cfactor
            red! *= cfactor
            green! *= cfactor
            blue! *= cfactor
        } else {
            red! = (255 - red!) * cfactor + red!
            green! = (255 - green!) * cfactor + green!
            blue! = (255 - blue!) * cfactor + blue!
        }
        
        return Color(red: red! / 255, green: green! / 255, blue: blue! / 255)
    }
    
    public static func average(colors: [Color]) -> Color {
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        var redArray: [CGFloat] = []
        var greenArray: [CGFloat] = []
        var blueArray: [CGFloat] = []
        
        for i in 0..<colors.count {
            
            let color = colors[i]
            let coms = color.components()
            let r: CGFloat = CGFloat(coms.r)
            let g: CGFloat = CGFloat(coms.g)
            let b: CGFloat = CGFloat(coms.b)
            
            redArray.append(r)
            greenArray.append(g)
            blueArray.append(b)
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
        
        red /= CGFloat(redArray.count)
        green /= CGFloat(greenArray.count)
        blue /= CGFloat(blueArray.count)
        
        return Color(red: Double(red), green: Double(green), blue: Double(blue))
    }
    
    public func between(_ color: Color, percentage: CGFloat) -> Color {
        
        let coms1 = self.components()
        let coms2 = color.components()
        let percentage = max(min(percentage, 100), 0) / 100
        switch percentage {
        case 0: return self
        case 1: return color
        default:
            let (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (coms1.r, coms1.g, coms1.b, coms1.a)
            let (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (coms2.r, coms2.g, coms2.b, coms2.a)

            return Color(red: Double(CGFloat(r1 + (r2 - r1) * percentage)),
                         green: Double(CGFloat(g1 + (g2 - g1) * percentage)),
                         blue: Double(CGFloat(b1 + (b2 - b1) * percentage)),
                         opacity: Double(CGFloat(a1 + (a2 - a1) * percentage)))
        }
    }
    
    public func isLight(threshold: Double = 0.5) -> Bool {
        let components = self.components()
        let brightness = ((components.r * 299) + (components.g * 587) + (components.b * 114)) / 1000
        return (brightness > 0.5)
    }
    
    public func isDark(threshold: Double = 0.5) -> Bool {
        return !self.isLight(threshold: threshold)
    }
    
    public func isEqualTo(color: Color, withTolerance tolerance: CGFloat = 0.0) -> Bool {

        let coms1 = self.components()
        let coms2 = color.components()
        
        let r1 : CGFloat = coms1.r
        let g1 : CGFloat = coms1.g
        let b1 : CGFloat = coms1.b
        let a1 : CGFloat = coms1.a
        let r2 : CGFloat = coms2.r
        let g2 : CGFloat = coms2.g
        let b2 : CGFloat = coms2.b
        let a2 : CGFloat = coms2.a
        
        return
            abs(r1 - r2) <= tolerance &&
            abs(g1 - g2) <= tolerance &&
            abs(b1 - b2) <= tolerance &&
            abs(a1 - a2) <= tolerance
    }
    
    public func clashed(with color: Color) -> Bool {
        if self.isEqualTo(color: color) {
            return true
        } else {
            return false
        }
    }
    
    public func declash(with color: Color, factor: Double = 0.5) -> Color {
        
        var isClashing = self.clashed(with: color)
        
        if isClashing {
            if self.isLight() {
                return self.darkness(factor: factor)
            } else {
                return self.lightness(factor: factor)
            }
        } else {
            return self
        }
    }
    
    public func inverse() -> Color {
        
        let coms = self.components()
        let r: CGFloat = CGFloat(coms.r)
        let g: CGFloat = CGFloat(coms.g)
        let b: CGFloat = CGFloat(coms.b)
        let a: CGFloat = CGFloat(coms.a)

        return Color(red: 1.0-Double(r), green: 1.0 - Double(g), blue: 1.0 - Double(b), opacity: Double(a))
    }
    
    public func toName() -> String {
        let colorThesaurus = ColorThesaurus.closestMatch(color: self)
        return colorThesaurus.color.name
    }
    
    public func toRGBString() -> String {
        
        let coms = self.components()
        let r: CGFloat = CGFloat(coms.r)
        let g: CGFloat = CGFloat(coms.g)
        let b: CGFloat = CGFloat(coms.b)
        //let a: CGFloat = CGFloat(coms.a)

        return "(\(Int((r * 255))), \(Int((g * 255))), \(Int((b * 255))))"
    }
    public func toFloatString() -> String {
        
        let coms = self.components()
        let r: CGFloat = CGFloat(coms.r)
        let g: CGFloat = CGFloat(coms.g)
        let b: CGFloat = CGFloat(coms.b)
        //let a: CGFloat = CGFloat(coms.a)

        return "(\(r), \(g), \(b))"
    }
    
    public func toHex() -> String {
        
        let coms = self.components()
        let r: CGFloat = CGFloat(coms.r)
        let g: CGFloat = CGFloat(coms.g)
        let b: CGFloat = CGFloat(coms.b)
        //let a: CGFloat = CGFloat(coms.a)

        return String(
            format: "#%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
    
    #if os(iOS) || os(tvOS) || os(watchOS)
    public static func systemTheme(color: Color) -> UIUserInterfaceStyle {
        
        let coms = color.components()
        let r = CGFloat(coms.r)
        let g = CGFloat(coms.g)
        let b = CGFloat(coms.b)
        
        // Counting the perceptive luminance - human eye favors green color...
        let luminance = 1 - ((0.299 * r) + (0.587 * g) + (0.114 * b))

        if luminance < 0.5 {
            return .light
        } else {
            return .dark
        }
    }
    
    public func systemTheme() -> UIUserInterfaceStyle {
        
        let coms = self.components()
        let r = CGFloat(coms.r)
        let g = CGFloat(coms.g)
        let b = CGFloat(coms.b)

        // Counting the perceptive luminance - human eye favors green color...
        let luminance = 1 - ((0.299 * r) + (0.587 * g) + (0.114 * b))

        if luminance < 0.5 {
            return .light
        } else {
            return .dark
        }
    }
    
    public static func statusBarStyle(color: Color) -> UIStatusBarStyle {
        
        let coms = color.components()
        let r = CGFloat(coms.r)
        let g = CGFloat(coms.g)
        let b = CGFloat(coms.b)
        var a = CGFloat(1)

        // Counting the perceptive luminance - human eye favors green color...
        let luminance = 1 - ((0.299 * r) + (0.587 * g) + (0.114 * b))

        if luminance < 0.5 {
            return .darkContent
        } else {
            return .lightContent
        }
    }
    
    public func statusBarStyle() -> UIStatusBarStyle {
        
        let coms = self.components()
        var r = CGFloat(coms.r)
        var g = CGFloat(coms.g)
        var b = CGFloat(coms.b)
        var a = CGFloat(1)

        // Counting the perceptive luminance - human eye favors green color...
        let luminance = 1 - ((0.299 * r) + (0.587 * g) + (0.114 * b))

        if luminance < 0.5 {
            return .darkContent
        } else {
            return .lightContent
        }
    }
    
    public func toUIColor() -> UIColor {

        let components = self.components()
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }
    #elseif os(macOS)
    public func toNSColor() -> NSColor {
        let components = self.components()
        return NSColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }
    #endif
    
    public func toHSBComponents() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {

        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit) && os(macOS)
        typealias NativeColor = NSColor
        #endif
        
        var nativeHSB = NativeColor(self).toHSBComponents()
        
        var h: CGFloat = nativeHSB.hue
        var s: CGFloat = nativeHSB.saturation
        var b: CGFloat = nativeHSB.brightness
        
        return (h,s,b)
    }
    
    public func toRGBAComponents() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit) && os(macOS)
        typealias NativeColor = NSColor
        #endif

        var nativeRGBA = NativeColor(self).toRGBAComponents()
        
        var red: CGFloat = nativeRGBA.r
        var green: CGFloat = nativeRGBA.b
        var blue: CGFloat = nativeRGBA.g
        var alpha: CGFloat = nativeRGBA.a

        return (red, green, blue, alpha)
    }
    
    public func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat, hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
        
        return (self.toRGBAComponents().r,
                self.toRGBAComponents().g,
                self.toRGBAComponents().b,
                self.toRGBAComponents().a,
                self.toHSBComponents().hue,
                self.toHSBComponents().saturation,
                self.toHSBComponents().brightness)
    }
}
