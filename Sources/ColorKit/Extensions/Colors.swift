//
//  File.swift
//  
//
//  Created by Ashley Chapman on 18/10/2020.
//

import Foundation
import SwiftUI

#if os(iOS) || os(tvOS) || os(watchOS)
  import UIKit
#elseif os(OSX) || os(macOS)
  import AppKit
#endif

public extension Color {
 
    // Variables
    // Label Colors
    static var label: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIColor.label.toColor()
        #elseif os(OSX) || os(macOS)
        return NSColor.labelColor.toColor()
        #endif
    }
    
    static var secondaryLabel: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIColor.secondaryLabel.toColor()
        #elseif os(OSX) || os(macOS)
        return NSColor.secondaryLabelColor.toColor()
        #endif
    }
    
    static var tertiaryLabel: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIColor.tertiaryLabel.toColor()
        #elseif os(OSX) || os(macOS)
        return NSColor.tertiaryLabelColor.toColor()
        #endif
    }
    
    static var quaternaryLabel: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIColor.quaternaryLabel.toColor()
        #elseif os(OSX) || os(macOS)
        return NSColor.quaternaryLabelColor.toColor()
        #endif
    }
    
    
    // Fill Colors
    static var systemFill: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIColor.systemFill.toColor()
        #elseif os(OSX) || os(macOS)
        return NSColor.textBackgroundColor.toColor()
        #endif
    }
    
    static var secondarySystemFill: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIColor.secondarySystemFill.toColor()
        #elseif os(OSX) || os(macOS)
        return NSColor.windowBackgroundColor.toColor()
        #endif
    }
    
    static var tertiarySystemFill: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIColor.tertiarySystemFill.toColor()
        #elseif os(OSX) || os(macOS)
        return NSColor.underPageBackgroundColor.toColor()
        #endif
    }
    
    static var quaternarySystemFill: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIColor.quaternarySystemFill.toColor()
        #elseif os(OSX) || os(macOS)
        return NSColor.scrubberTexturedBackground.toColor()
        #endif
    }
    
    // Text Colors
    static var placeholderText: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIColor.placeholderText.toColor()
        #elseif os(OSX) || os(macOS)
        return NSColor.placeholderTextColor.toColor()
        #endif
    }
    
    // Standard Content Background Colors
    static var systemBackground: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIColor.systemBackground.toColor()
        #elseif os(OSX) || os(macOS)
        return NSColor.windowBackgroundColor.toColor()
        #endif
    }
    
    static var secondarySystemBackground: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIColor.secondarySystemBackground.toColor()
        #elseif os(OSX) || os(macOS)
        return NSColor.windowFrameTextColor.toColor()
        #endif
    }
    
    static var tertiarySystemBackground: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIColor.tertiarySystemBackground.toColor()
        #elseif os(OSX) || os(macOS)
        return NSColor.underPageBackgroundColor.toColor()
        #endif
    }
    
    // Grouped Content Background Colors
    static var systemGroupedBackground: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIColor.systemGroupedBackground.toColor()
        #elseif os(OSX) || os(macOS)
        return NSColor.scrubberTexturedBackground.toColor()
        #endif
    }
    
    static var secondaryGroupedSystemBackground: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIColor.secondarySystemGroupedBackground.toColor()
        #elseif os(OSX) || os(macOS)
        return NSColor.underPageBackgroundColor.toColor()
        #endif
    }
    
    static var tertiaryGroupedSystemBackground: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIColor.tertiarySystemGroupedBackground.toColor()
        #elseif os(OSX) || os(macOS)
        return NSColor.windowFrameTextColor.toColor()
        #endif
    }
    
    // Separator Colors
    static var separator: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIColor.separator.toColor()
        #elseif os(OSX) || os(macOS)
        return NSColor.separatorColor.toColor()
        #endif
    }
    
    static var opaqueSeparator: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIColor.opaqueSeparator.toColor()
        #elseif os(OSX) || os(macOS)
        return NSColor.separatorColor.toColor()
        #endif
    }
    
    // Link Colors
    static var link: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIColor.link.toColor()
        #elseif os(OSX) || os(macOS)
        return NSColor.linkColor.toColor()
        #endif
    }
    
    // Nonadaptable Colors
    static var darkText: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIColor.darkText.toColor()
        #elseif os(OSX) || os(macOS)
        return NSColor.textColor.toColor()
        #endif
    }
    
    static var lightText: Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return UIColor.lightText.toColor()
        #elseif os(OSX) || os(macOS)
        return NSColor.textColor.toColor()
        #endif
    }
    
    #if os(OSX) || os(macOS)
        
    #endif
}
