//
//  FormatConfig.swift
//  WhatsNext
//
//  Created by Bensu Özyurt on 20.10.2026.
//


import SwiftUI


enum FormatConfig {
    enum Colors {
        static var primary = Color.adaptive(
            lightHex: "#0F172A",
            darkHex: "#FFFFFF"
        )
        
        static let secondary = Color.adaptive(
            lightHex: "#475569",
            darkHex: "#94A3B8"
        )
        
        static let background = Color.adaptive(
            lightHex: "#F8FAFC",  
            darkHex: "080D19"
        )
        
        static let cardBackground = Color.adaptive(
            lightHex: "#FFFFFF",
            darkHex: "#131C2E"
        )
        
        static let error = Color.red
        static let surface = Color(hex: "111B30")
        static let electricBlue = Color(hex: "1877FF")
        static let iceBlue = Color(hex: "58C7FF")
        static let mutedText = Color(hex: "8996B0")
        
        // Custom branding colors
        static let accent = Color("AccentColor") // Asset catalog name
        
        enum LogInColors {
            static let background = Color(hex: "080D19")
            static let surface = Color(hex: "111B30")
            static let electricBlue = Color(hex: "1877FF")
            static let iceBlue = Color(hex: "58C7FF")
            static let mutedText = Color(hex: "8996B0")
        }
    }
    
        
    // MARK: - Fonts
    enum Fonts {
        static let titleFontName = "Anton-Regular"
        static let subtitleFontName = "Raleway-Regular"
        static let buttonFontName = "Raleway-ExtraLight"
        static let captionFontName = "Raleway-VariableFont_wght"
        static let boldTextName = "Raleway-Bold"
        
        static let title = Font.custom(titleFontName, size: 50)
        static let subtitle = Font.custom(subtitleFontName, size: 22)
        static let button = Font.custom(buttonFontName, size: 18)
        static let caption = Font.custom(captionFontName, size: 15)
        
        static let boldText = Font.custom(boldTextName, size: 18)
        
        static func createFont(fontName: String, size: CGFloat) -> Font {
            Font.custom(fontName, size: size)
        }
    }
        
    // MARK: - Layout Constants
    enum Layout {
        static let cornerRadius: CGFloat = 12
        static let buttonHeight: CGFloat = 50
        static let horizontalPadding: CGFloat = 24
        static let logoSize: CGFloat = 120
    }
}
