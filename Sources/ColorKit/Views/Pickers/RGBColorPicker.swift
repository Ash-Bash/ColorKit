//
//  RGBColorPicker.swift
//  ColorPickerTest
//
//  Created by Ashley Chapman on 08/08/2020.
//

import SwiftUI
import Sliders
import Shapes
import Combine


struct RGBSliderStyle: LSliderStyle {
    enum ColorType: String, CaseIterable {
        case red
        case green
        case blue
    }
    var strokeWidth: CGFloat
    var type: ColorType
    var color: (red: Double, green: Double, blue: Double)
    var colors: [Color] {
        switch type {
        case .red:
            return [Color(red: 0, green: color.green, blue: color.blue),
                    Color(red: 1, green: color.green, blue: color.blue)]
        case .green:
            return [Color(red: color.red, green: 0, blue: color.blue),
                    Color(red: color.red, green: 1, blue: color.blue)]
        case .blue:
            return [Color(red: color.red, green: color.green, blue: 0),
                    Color(red: color.red, green: color.green, blue: 1)]
        }
    }
    
    var trackPadding: CGFloat = 12
    
    func makeThumb(configuration: LSliderConfiguration) -> some View {
        let currentColor: Color =  {
            switch type {
            case .red:
                return Color(red: Double(configuration.pctFill), green: 0, blue: 0)
            case .green:
                return Color(red: 0, green: Double(configuration.pctFill), blue: 0)
            case .blue:
                return Color(red: 0, green: 0, blue: Double(configuration.pctFill))
            }
        }()
        
        
        return ZStack {
            Circle()
                .fill(Color.white)
                .shadow(radius: 2)
            Circle()
                .fill(currentColor)
                .scaleEffect(0.8)
        }.frame(width: strokeWidth, height: strokeWidth)
    }

    func makeTrack(configuration: LSliderConfiguration) -> some View {
        let style: StrokeStyle = .init(lineWidth: strokeWidth - self.trackPadding, lineCap: .round)
        let gradient = LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing)
        return AdaptiveLine(angle: configuration.angle)
            .stroke(gradient, style: style)
            .overlay(GeometryReader { proxy in
                Capsule()
                    .stroke(Color.secondary)
                    .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
                    .frame(width: proxy.size.width + (self.strokeWidth - self.trackPadding))
                    .rotationEffect(configuration.angle)
            })
            .frame(height: strokeWidth - self.trackPadding)
    }
}

struct RGBColorPicker: View {
    
    // Variables
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    var type: RGBSliderStyle.ColorType = .red
    @Binding var value: Double
    @Binding var red: Double
    @Binding var green: Double
    @Binding var blue: Double
    var title: String = ""
    
    @State private var isEditingHexcode: Bool = false
    @State private var hexcode: String = "" {
        willSet {
            self.hexValue.wrappedValue = newValue
        }
    }
    var hexValue: Binding<String> {
        Binding<String>(get: {
            self.hexcode
            }, set: {
                if $0.count > 5 {
                    let col : Color = Color.setHexString(hex: $0)
                    self.hexcode = $0
                    self.red = Double(col.components().r)
                    self.green = Double(col.components().g)
                    self.blue = Double(col.components().b)
                }
            })
    }
  
    var sliderHeights: CGFloat = 40
    
    init(_ type: RGBSliderStyle.ColorType, value: Binding<Double>, red: Binding<Double>, green: Binding<Double>, blue: Binding<Double>, title: String) {
        self.type = type
        self._value = value
        self._red = red
        self._green = green
        self._blue = blue
        self.title = title
        
        self._hexcode = State(initialValue: Color(red: self.red, green: self.green, blue: self.blue).toHex())
    }
    
    func makeSlider( _ color: RGBSliderStyle.ColorType) -> some View {
        let value: Binding<Double> =  {
            switch color {
            case .red:      return $red
            case .blue:     return $blue
            case .green:    return $green
            }
        }()
        
        return LSlider(value, range: 0...1, angle: .zero)
            .linearSliderStyle(RGBSliderStyle(strokeWidth: sliderHeights, type: color, color: (red, green, blue)))
            .frame(height: sliderHeights)
    }
    
    @ViewBuilder var sliderInput: some View {
        let val: Binding<String> = Binding<String>(get: {
            String(Int(self.value * 255))
        }, set: {
            if let value = NumberFormatter().number(from: $0) {
                self.value = value.doubleValue / 255
            }
        })
        
        Spacer()
        TextField(self.title, text: val)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: 92, height: 48)
            .padding(.leading, 20)
            .padding(.trailing, -15)
    }
    
    var body: some View {
        HStack {
            self.makeSlider(self.type)
            #if os(iOS)
            if horizontalSizeClass != .compact {
                self.sliderInput
            }
            #elseif os(macOS)
            self.sliderInput
            #endif
        }
    }
}

struct RGBColorPickerSliders: View {
    
    // Variables
    @Binding var red: Double
    @Binding var green: Double
    @Binding var blue: Double
    
    @State private var hex: String = ""
    @State private var isEditingHexcode: Bool = false
    
    init(red: Binding<Double>, green: Binding<Double>, blue: Binding<Double>) {
        self._red = red
        self._green = green
        self._blue = blue
        self._hex = State(initialValue: Color(red: self.red, green: self.green, blue: self.blue).toHex())
    }
    
    var body: some View {
        let hexVal: Binding<String> = Binding<String>(get: {
            if !isEditingHexcode {
                return Color(red: self.red, green: self.green, blue: self.blue).toHex()
            } else {
                return self.hex
            }
        }, set: {
            if $0.count > 5 {
                let col : Color = Color.setHexString(hex: $0)
                self.red = Double(col.components().r)
                self.green = Double(col.components().g)
                self.blue = Double(col.components().b)
                self.hex = Color(red: self.red, green: self.green, blue: self.blue).toHex()
            }
        })
        
        VStack(spacing: 20) {
            RGBColorPicker(.red, value: self.$red, red: self.$red, green: self.$green, blue: self.$blue, title: "Red")
            RGBColorPicker(.green, value: self.$green, red: self.$red, green: self.$green, blue: self.$blue, title: "Red")
            RGBColorPicker(.blue, value: self.$blue, red: self.$red, green: self.$green, blue: self.$blue, title: "Red")
            HStack {
                Spacer()
                Text("Hexcode:")
                    .font(.headline)
                TextField("Hexcode", text: isEditingHexcode ? self.$hex : hexVal, onEditingChanged: { v in
                    self.isEditingHexcode = v
                    }, onCommit: {
                        var col = Color.setHexString(hex: self.hex)
                        self.red = Double(col.components().r)
                        self.green = Double(col.components().g)
                        self.blue = Double(col.components().b)
                        self.hex = Color(red: self.red, green: self.green, blue: self.blue).toHex()
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 128, height: 48)
                    .padding(.leading, 10)
                    .padding(.trailing, -15)
            }
        }
    }
}

struct RGBColorPickerExample: View {
    @State var red: Double = 0.2
    @State var green: Double = 0.5
    @State var blue: Double = 0.8
    var overlay: some View {
        VStack {
            Text("r: \(String(format: "%.0f", red*255))")
            Text("g: \(String(format: "%.0f", green*255))")
            Text("b: \(String(format: "%.0f", blue*255))")
            Text(Color(red: red, green: green, blue: blue).description)
        }
    }
    var body: some View {
        ZStack {
            Color(white: 0.2)
            
            VStack(spacing: 50) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(red: red, green: green, blue: blue))
                    .frame(height: 300)
                    .shadow(radius: 3)
                    .overlay(self.overlay)
                
                RGBColorPickerSliders(red: $red, green: $green, blue: $blue)
                
                
            }.padding(.horizontal, 40)
        }.navigationBarTitle("RGB Color Picker")
    }
}

struct RGBColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        RGBColorPickerExample()
    }
}
