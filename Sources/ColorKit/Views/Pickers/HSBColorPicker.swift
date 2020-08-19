//
//  HSBColorPicke.swift
//  ColorPickerTest
//
//  Created by Ashley Chapman on 08/08/2020.
//

import SwiftUI
import Sliders
import Shapes

struct HueSliderStyle: LSliderStyle {
    var strokeWidth: CGFloat
    var trackPadding: CGFloat = 12
    
    private let hueColors = stride(from: 0, to: 1, by: 0.03).map {
        Color(hue: $0, saturation: 1, brightness: 1)
    }
    
    func makeThumb(configuration: LSliderConfiguration) -> some View {
        return ZStack {
            Circle()
                .fill(Color.white)
                .shadow(radius: 2)
            Circle()
                .fill(Color(hue: configuration.pctFill, saturation: 1, brightness: 1))
                .scaleEffect(0.8)
        }.frame(width: strokeWidth, height: strokeWidth)
    }
    
    func makeTrack(configuration: LSliderConfiguration) -> some View {
        let style: StrokeStyle = .init(lineWidth: self.strokeWidth - self.trackPadding, lineCap: .round)
        let gradient = LinearGradient(gradient: Gradient(colors: hueColors), startPoint: .leading, endPoint: .trailing)
        return AdaptiveLine(angle: configuration.angle)
            .stroke(gradient, style: style)
            .overlay(GeometryReader { proxy in
                Capsule()
                    .stroke(Color.secondary)
                    .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
                    .frame(width: proxy.size.width + (self.strokeWidth - self.trackPadding), height: self.strokeWidth - self.trackPadding)
                    .rotationEffect(configuration.angle)
            })
    }
}


public struct SaturationBrightnessStyle: TrackPadStyle {
    var hue: Double
    private var saturationColors: [Color] {
        return stride(from: 0, to: 1, by: 0.01).map {
            Color(hue: hue, saturation: $0, brightness: 1)
        }
    }
    
    public func makeThumb(configuration: TrackPadConfiguration) -> some View {
        ZStack {
            Circle()
                .foregroundColor(configuration.isActive ? .yellow : .white)
            Circle()
                .fill(Color(hue: self.hue, saturation: Double(configuration.pctX), brightness: Double(configuration.pctY)))
                .scaleEffect(0.8)
        }.frame(width: 40, height: 40)
    }
    public func makeTrack(configuration: TrackPadConfiguration) -> some View {
        let brightnessGradient = LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 1, blue: 1), Color(red: 0, green: 0, blue: 0)]), startPoint: .bottom, endPoint: .top)
        let saturationGradient = LinearGradient(gradient:Gradient(colors: saturationColors), startPoint: .leading, endPoint: .trailing)
        return ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(brightnessGradient)
            RoundedRectangle(cornerRadius: 5)
                .fill(saturationGradient)
                .drawingGroup(opaque: false, colorMode: .extendedLinear)
                .blendMode(.plusDarker)
        }.overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary, lineWidth: 2))
    }
}

struct HSBColorPicker: View {
    @Binding var hue: Double
    @Binding var saturation: Double
    @Binding var brightness: Double
    var sliderHeight: CGFloat = 40
    
    @ViewBuilder var sliderInput: some View {
        let val: Binding<String> = Binding<String>(get: {
            String(Int(self.hue * 255))
        }, set: {
            if let value = NumberFormatter().number(from: $0) {
                self.hue = value.doubleValue / 255
            }
        })
        
        Spacer()
        TextField("Hue", text: val)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: 92, height: 48)
            .padding(.leading, 20)
            .padding(.trailing, -15)
    }
    
    var body: some View {
        let brightnessSaturation = Binding(get: {CGPoint(x: self.saturation, y: self.brightness)},
                                           set: { (new) in
                                            self.saturation  = Double(new.x)
                                            self.brightness = Double(new.y)
        })
        
        return VStack(spacing: 30) {
            TrackPad(value: brightnessSaturation, rangeX: 0.01...1, rangeY: 0.01...1)
                .trackPadStyle(SaturationBrightnessStyle(hue: self.hue))
                .frame(minWidth: 320, idealWidth: 380, maxWidth: 420, minHeight: 320, idealHeight: 380, maxHeight: 420)
            
            HStack {
                LSlider($hue, range: 0...0.999, angle: .zero)
                    .linearSliderStyle(HueSliderStyle(strokeWidth: sliderHeight))
                    .frame(height: sliderHeight)
                self.sliderInput
            }
            .padding(.horizontal, 25)
        }
    }
}

struct HSBColorPickerExample: View {
    @State var hue: Double = 0.5
    @State var saturation: Double = 0.5
    @State var brightness: Double = 0.5
    var overlay: some View {
        VStack {
            Text("h: \(String(format: "%.0f", hue*360))")
            Text("s: \(String(format: "%.0f", saturation*100))%")
            Text("b: \(String(format: "%.0f", brightness*100))%")
            Text(Color(hue: hue, saturation: saturation, brightness: brightness).description)
        }
    }
    var body: some View {
        ZStack {
            Color(white: 0.2)
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(hue: hue, saturation: saturation, brightness: brightness))
                    .overlay(overlay)
                HSBColorPicker(hue: $hue, saturation: $saturation, brightness: $brightness)
                .frame(height: 400)
            }
                
                .padding(50)
        }.navigationBarTitle("HSB Color Picker")
    }
}

struct TrackPadExample_Previews: PreviewProvider {
    static var previews: some View {
        HSBColorPickerExample()
    }
}
