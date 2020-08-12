//
//  ColorContext.swift
//  ColorPickerTest
//
//  Created by Ashley Chapman on 09/08/2020.
//

import Combine
import SwiftUI

public class ColorContext: ObservableObject {
    
    // Variables
    @Published public var color: Color = Color.random() {
        willSet {
            objectWillChange.send()
            //self.components.update(color: self.color)
        }
    }
    
    @Published public var components: ColorComponent = ColorComponent() {
        willSet {
            objectWillChange.send()
        }
        didSet {
            self.color = self.components.getColor()
        }
    }
    
    private var redComponentSubscriber: AnyCancellable?
    private var greenComponentSubscriber: AnyCancellable?
    private var blueComponentSubscriber: AnyCancellable?
    private var alphaComponentSubscriber: AnyCancellable?
    
    private var hueComponentSubscriber: AnyCancellable?
    private var saturationComponentSubscriber: AnyCancellable?
    private var brightnessComponentSubscriber: AnyCancellable?
    
    private var debounceDelay: Int = 16
    
    public init(color: Color = Color.random()) {
        self.color = color
        self.components = ColorComponent(color: self.color)
        
        self.subscriber()
    }
    
    private func subscriber() {
        self.RGBASubscribers()
        self.HSBSubscribers()
    }
    
    private func RGBASubscribers() {
        redComponentSubscriber = self.components.$red
            .debounce(for: .milliseconds(self.debounceDelay), scheduler: RunLoop.main)
            .sink(receiveValue: { v in
                self.didRGBAChanged()
        })
        
        greenComponentSubscriber = self.components.$green
            .debounce(for: .milliseconds(self.debounceDelay), scheduler: RunLoop.main)
            .sink(receiveValue: { v in
                self.didRGBAChanged()
        })
        
        blueComponentSubscriber = self.components.$blue
            .debounce(for: .milliseconds(self.debounceDelay), scheduler: RunLoop.main)
            .sink(receiveValue: { v in
                self.didRGBAChanged()
        })
        
        alphaComponentSubscriber = self.components.$alpha
            .debounce(for: .milliseconds(self.debounceDelay), scheduler: RunLoop.main)
            .sink(receiveValue: { v in
                self.didRGBAChanged()
        })
    }
    
    private func HSBSubscribers() {
        hueComponentSubscriber = self.components.$hue
            .debounce(for: .milliseconds(self.debounceDelay), scheduler: RunLoop.main)
            .sink(receiveValue: { v in
                self.didHSBChanged()
        })
        
        saturationComponentSubscriber = self.components.$saturation
            .debounce(for: .milliseconds(self.debounceDelay), scheduler: RunLoop.main)
            .sink(receiveValue: { v in
                self.didHSBChanged()
        })
        
        brightnessComponentSubscriber = self.components.$brightness
            .debounce(for: .milliseconds(self.debounceDelay), scheduler: RunLoop.main)
            .sink(receiveValue: { v in
                self.didHSBChanged()
        })
    }
    
    private func didHSBChanged() {
        if self.components.red != Double(self.color.components().r) {
            self.components.red = Double(self.color.components().r)
        }
        if self.components.green != Double(self.color.components().g) {
            self.components.green = Double(self.color.components().g)
        }
        if self.components.blue != Double(self.color.components().b) {
            self.components.blue = Double(self.color.components().b)
        }
        if self.components.alpha != Double(self.color.components().a) {
            self.components.alpha = Double(self.color.components().a)
        }
    }
    
    private func didRGBAChanged() {
        if self.components.hue != Double(self.color.components().hue) {
            self.components.hue = Double(self.color.components().hue)
        }
        if self.components.saturation != Double(self.color.components().saturation) {
            self.components.saturation = Double(self.color.components().saturation)
        }
        if self.components.brightness != Double(self.color.components().brightness) {
            self.components.brightness = Double(self.color.components().brightness)
        }
    }
}

public class ColorComponent: ObservableObject {
    
    // Variables
    @Published public var red: Double = 0 {
        willSet {
            objectWillChange.send()
        }
        didSet {
            if self.red != oldValue {
                self.changeRGBAColor()
            }
        }
    }
    @Published public var green: Double = 0 {
        willSet {
            objectWillChange.send()
        }
        didSet {
            if self.green != oldValue {
                self.changeRGBAColor()
            }
        }
    }
    
    @Published public var blue: Double = 0 {
        willSet {
            objectWillChange.send()
        }
        didSet {
            if self.blue != oldValue {
                self.changeRGBAColor()
            }
        }
    }
    
    @Published public var alpha: Double = 0 {
        willSet {
            objectWillChange.send()
        }
        didSet {
            if self.alpha != oldValue {
                self.changeRGBAColor()
            }
        }
    }
    
    @Published public var hue: Double = 0 {
        willSet {
            objectWillChange.send()
        }
        
        didSet {
            if self.hue != oldValue {
                self.changeHSBColor()
            }
        }
    }
    
    @Published public var saturation: Double = 0 {
        willSet {
            objectWillChange.send()
        }
        
        didSet {
            if self.saturation != oldValue {
                self.changeHSBColor()
            }
        }
    }
    
    @Published public var brightness: Double = 0 {
        willSet {
            objectWillChange.send()
        }
        
        didSet {
            if self.brightness != oldValue {
                self.changeHSBColor()
            }
        }
    }
    
    private var sampleColor: Color = Color.random() {
        didSet {
            //self.updateChannelValues()
        }
    }
    
    public init(color: Color = Color.random()) {
        self.sampleColor = color
        self.red = Double(color.components().r)
        self.green = Double(color.components().g)
        self.blue = Double(color.components().b)
        self.alpha = Double(color.components().a)
        self.hue = Double(color.components().hue)
        self.saturation = Double(color.components().saturation)
        self.brightness = Double(color.components().brightness)
    }
    
    public func getColor() -> Color {
        return self.sampleColor
    }
    
    private func changeHSBColor() {
        self.sampleColor.setHSB(hue: self.hue, saturation: self.saturation, brightness: self.brightness)
    }
    
    private func changeRGBAColor() {
        self.sampleColor.setRGB(red: self.red, green: self.green, blue: self.blue)
    }
}
