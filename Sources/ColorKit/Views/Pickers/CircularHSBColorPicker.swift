//
//  CircularHSBColorPicker.swift
//  ColorPickerTest
//
//  Created by Ashley Chapman on 07/08/2020.
//

import SwiftUI
import Sliders
import Shapes

struct BrightnessSliderStyle: LSliderStyle {
    let hue: Double
    let saturation: Double
    let brightness: Double
    var color: Color { Color(hue: hue, saturation: saturation, brightness: brightness) }
    let strokeWidth: CGFloat
    var gradient: Gradient {
        Gradient(colors: [Color(hue: hue, saturation: saturation, brightness: 0),
                          Color(hue: hue, saturation: saturation, brightness: 1)])
    }
    
    func makeThumb(configuration: LSliderConfiguration) -> some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .shadow(radius: 2)
            Circle()
                .fill(color)
                .scaleEffect(0.8)
        }.frame(width: strokeWidth, height: strokeWidth)
    }
    
    func makeTrack(configuration: LSliderConfiguration) -> some View {
        let style: StrokeStyle = .init(lineWidth: strokeWidth, lineCap: .round)
        let gradient = LinearGradient(gradient: self.gradient, startPoint: .leading, endPoint: .trailing)
        return AdaptiveLine(angle: configuration.angle)
            .stroke(gradient, style: style)
            .overlay(GeometryReader { proxy in
                Capsule()
                    .stroke(Color.secondary)
                    .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
                    .frame(width: proxy.size.width + self.strokeWidth)
                    .rotationEffect(configuration.angle)
            })
    }
}

struct SaturationHueRadialPad: RadialPadStyle {
    let brightness: Double
    var hueColors: [Color] {
        stride(from: 0, to: 1, by: 0.01).map {
            Color(hue: $0, saturation: 1, brightness: brightness)
        }
    }
    
    func makeThumb(configuration: RadialPadConfiguration) -> some View {
        let color = Color(hue: (configuration.angle.degrees/360), saturation: configuration.radialOffset, brightness: self.brightness)
        return ZStack {
            Circle()
                .fill(Color.white)
            Circle()
                .inset(by: 6)
                .fill(color)
        }.frame(width: 45, height: 45)
    }
    
    func makeTrack(configuration: RadialPadConfiguration) -> some View {
        ZStack {
            Circle()
                .fill(Color(hue: 0, saturation: 0, brightness: self.brightness))
            HueCircleView()
                .blendMode(.plusDarker)
            Circle()
                .stroke(Color.white, lineWidth: 2)
        }
    }
}

struct CircularHSBColorPicker: View {
    @Binding var hue: Double
    @Binding var saturation: Double
    @Binding var brightness: Double
    var sliderHeight: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 20) {
            RadialPad(offset: $saturation,
                      angle: Binding(get: { Angle(degrees: self.hue*360) },
                                     set: { self.hue = $0.degrees/360 }))
                .radialPadStyle(SaturationHueRadialPad(brightness: brightness))
                .scaledToFit()
            LSlider($brightness, range: 0...1, angle: .zero)
                .linearSliderStyle(BrightnessSliderStyle(hue: hue, saturation: saturation, brightness: brightness, strokeWidth: sliderHeight))
                .frame(height: sliderHeight)
                .padding(.horizontal, 25)
        }
    }
}

struct CircularHSBColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        CircularHSBColorPicker(hue: .constant(0.4), saturation: .constant(0.5), brightness: .constant(0.8))
    }
}
