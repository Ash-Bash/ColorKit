//
//  ColorPickerView.swift
//  ColorPickerTest
//
//  Created by Ashley Chapman on 09/08/2020.
//

import SwiftUI
import Sliders

struct ColorPickerView: View {
    
    // Variables
    @Binding var color: Color
    @Binding var component: ColorComponent
    
    init(color: Binding<Color>, component: Binding<ColorComponent>) {
        self._color = color
        self._component = component
    }
    
    var body: some View {
        TabView {
            CircularHSBColorPickerView(hue: self.$component.hue, saturation: self.$component.saturation, brightness: self.$component.brightness)
            .tabItem {
                Label("Radial", systemImage: "timelapse")
            }
            .tag(0)
            HSBColorPickerView(hue: self.$component.hue, saturation: self.$component.saturation, brightness: self.$component.brightness)
            .tabItem {
                Label("Graph", systemImage: "rectangle.connected.to.line.below")
            }
            .tag(1)
            RGBColorPickerView(red: self.$component.red, green: self.$component.green, blue: self.$component.blue)
            .tabItem {
                Label("RGB", systemImage: "slider.horizontal.3")
            }
            .tag(1)
        }
        .navigationTitle("Color Picker")
    }
}

public struct ColorPickerListItemView: View {
    
    // Variables
    @Binding var color: Color
    @Binding var component: ColorComponent
    
    public var body: some View {
        NavigationLink(destination: ViewDestination { ColorPickerView(color: self.$color, component: self.$component) }) {
            HStack {
                Image(systemName: "eyedropper")
                Text("Color")
                Spacer()
                RoundedRectangle(cornerRadius: 5)
                    .fill(self.color)
                    .frame(width: 72)
            }
        }
    }
}

struct CircularHSBColorPickerView: View {
    
    @Binding var hue: Double
    @Binding var saturation: Double
    @Binding var brightness: Double
    
    var body: some View {
        VStack {
            ColorPreviewer(color: Color(hue: self.hue, saturation: self.saturation, brightness: self.brightness))
            CircularHSBColorPicker(hue: self.$hue, saturation: self.$saturation, brightness: self.$brightness)
                .padding(.horizontal)
            
            ColorViewer(color: Color(hue: self.hue, saturation: self.saturation, brightness: self.brightness))
            
            Spacer()
        }
    }
}

struct HSBColorPickerView: View {
    
    @Binding var hue: Double
    @Binding var saturation: Double
    @Binding var brightness: Double
    
    var body: some View {
        VStack {
            ColorPreviewer(color: Color(hue: self.hue, saturation: self.saturation, brightness: self.brightness))
            HSBColorPicker(hue: self.$hue, saturation: self.$saturation, brightness: self.$brightness)
                .padding(.horizontal)
            
            ColorViewer(color: Color(hue: self.hue, saturation: self.saturation, brightness: self.brightness))
            
            Spacer()
        }
    }
}

struct RGBColorPickerView: View {
    
    @Binding var red: Double
    @Binding var green: Double
    @Binding var blue: Double
    
    var body: some View {
        VStack {
            ColorPreviewer(color: Color(red: self.red, green: self.green, blue: self.blue, opacity: 1.0))
            
            RGBColorPicker(red: self.$red, green: self.$green, blue: self.$blue)
                .padding(.horizontal, 35)
            
            ColorViewer(color: Color(.sRGB, red: self.red, green: self.green, blue: self.blue, opacity: 1))
            
            Spacer()
        }
    }
}

struct ColorViewer: View {
    
    // Variables
    var color: Color = Color.random()
    
    var body: some View {
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(self.color)
                    .frame(width: 48, height: 48)
                Text(self.color.toHex())
                Spacer()
            }
            .padding()
        }
        .border(Color.secondary.opacity(0.3), width: 1)
        .background(Color.secondary.opacity(0.1))
        .padding(.horizontal, -1)
        .padding([.top, .bottom], 10)
    }
    
}

struct ColorPreviewer: View {
    
    // Variables
    var color: Color = Color.random()
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(self.color)
            .overlay(GeometryReader { geo in
                VStack {
                    Spacer()
                    Text(self.color.toHex())
                        .foregroundColor(self.color.textColor(correctness: 0.1))
                    Text("RGB(\(Int(self.color.components().r * 255)), \(Int(self.color.components().g * 255)), \(Int(self.color.components().b * 255)))")
                        .foregroundColor(self.color.textColor(correctness: 0.1))
                    Text("HSB(\(Int(self.color.components().hue * 255)), \(Int(self.color.components().saturation * 255)), \(Int(self.color.components().brightness * 255)))")
                        .foregroundColor(self.color.textColor(correctness: 0.1))
                    Spacer()
                }
                .frame(width: geo.size.width, height: geo.size.height)
            })
            .padding()
            .frame(height: 180)
    }
    
}

// This view lets us avoid instantiating our Destination before it has been pushed.
struct ViewDestination<Destination: View>: View {
    var destination: () -> Destination
    var body: some View {
        self.destination()
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(color: .constant(Color.blue), component: .constant(ColorComponent()))
    }
}
