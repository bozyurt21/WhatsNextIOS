//
//  EnterFieldView.swift
//  WhatsNext
//
//  Created by Bensu Özyurt on 29.10.2026.
//

import SwiftUI

struct CustomInputField<FieldType: Hashable>: View {
    let placeholder: String
    @Binding var text: String
    let field: FieldType
    @FocusState.Binding var focusedField: FieldType?
    var isSecure: Bool = false

    private var isFocused: Bool {
        focusedField == field
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .textContentType(.password)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .foregroundStyle(Color.white)
                        .font(FormatConfig.Fonts.caption)
                        .autocorrectionDisabled()
                }
            }
            .focused($focusedField, equals: field)
            .padding()
            .background(FormatConfig.Colors.mutedText.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(FormatConfig.Colors.iceBlue, lineWidth: 1)
            )
            .shadow(
                color: isFocused
                    ? FormatConfig.Colors.iceBlue.opacity(0.45)
                    : .clear,
                radius: isFocused ? 20 : 0,
                y: -2
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}
