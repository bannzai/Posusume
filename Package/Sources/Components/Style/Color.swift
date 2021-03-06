import SwiftUI

extension Color {
    // #F8F8F8
    public static let screenBackground: Color = Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255)
    // #EE6770
    public static let appPrimary: Color = Color(red: 239 / 255, green: 103 / 255, blue: 112 / 255)
    // #CBCBCB
    public static let placeholder: Color = Color(white: 203 / 255)
    
    public static let disabled: Color = Color(white: 192 / 255)
}

extension Color {
    // #FFAB8B
    public static let barnEnd: Color = Color(red: 255 / 255, green: 171 / 255, blue: 139 / 255)
    // #E95468
    public static let barnStart: Color = Color(red: 233 / 255, green: 84 / 255, blue: 104 / 255)
}

extension Color {
    public var gradient: LinearGradient {
        .init(
            gradient: Gradient(colors: [self]),
            startPoint: .bottom,
            endPoint: .top
        )
    }
}

public struct GradientColor {
    public static let upper = LinearGradient(
        gradient: Gradient(colors: [.barnEnd, Color.barnEnd.opacity(0.01)]),
        startPoint: .bottom,
        endPoint: .top
    )

    public static let lower = barn
    public static let barn = LinearGradient(
        gradient: Gradient(colors: [.barnStart, Color.barnEnd]),
        startPoint: .bottom,
        endPoint: .top
    )
}
