//
//  File.swift
//  
//
//  Created by Ashley Chapman on 03/08/2020.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit) && os(macOS)
import AppKit
#endif

public class ColorThesaurus  {
    
    // Variables
    
    public static func closestMatch(color: Color) -> ColorMatch {
        
        let com = color.components()
        let value: ColorName = ColorName(Double(com.r), Double(com.g), Double(com.b), Double(com.a))
        
        return self.match(value: value)
        
    }
    
    #if canImport(UIKit)
    public static func closestMatch(color: UIColor) -> ColorMatch {
        let value: ColorName = ColorName(Double(color.redValue!), Double(color.greenValue!), Double(color.blueValue!), Double(color.alphaValue!))
        return self.match(value: value)
    }
    #endif
    
    #if canImport(AppKit) && os(macOS)
    public static func closestMatch(color: NSColor) -> ColorMatch {
        let value: ColorName = ColorName(Double(color.redValue!), Double(color.greenValue!), Double(color.blueValue!), Double(color.alphaValue!))
        return self.match(value: value)
    }
    #endif
    
    private static func match(value: ColorName) -> ColorMatch {
        
        let colorNames = ColorNames.names
        
        if let perfectMatch = colorNames.filter({ v in v.red == value.red && v.green == value.green && v.blue == value.blue && v.alpha == value.alpha }).first {
            return ColorMatch(color: perfectMatch, distance: 1.0)
        }

        // TODO: binary search based on lightness and/or saturation?

        let matches: [ColorMatch] = colorNames.map({ col in
            return ColorMatch(color: col, distance: col.distanceTo(other: value))
        })
        
        let sortedMatches = matches.sorted {
            $0.distance < $1.distance
        }

        return sortedMatches.first!
    }
}

public typealias ColorDistance = Double
