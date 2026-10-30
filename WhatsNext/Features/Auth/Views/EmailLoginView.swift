//
//  EmailLoginView.swift
//  WhatsNext
//
//  Created by Bensu Özyurt on 18.10.2026.
//

import SwiftUI

struct EmailLoginView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoading = false
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case email, password
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header / Branding
                VStack(spacing: 10) {
                    Image("Icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(.bottom, 4)
                    
                    Spacer()

                    Text("Welcome Back to What's Next")
                        .font(FormatConfig.Fonts.createFont(fontName: FormatConfig.Fonts.titleFontName, size: 30))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    FormatConfig.Colors.LogInColors.iceBlue,
                                    FormatConfig.Colors.LogInColors.electricBlue
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text("Sign in to your account to continue")
                        .font(FormatConfig.Fonts.createFont(
                            fontName: FormatConfig.Fonts.subtitleFontName,
                            size: 20)
                        )
                        .foregroundStyle(FormatConfig.Colors.LogInColors.mutedText)
                }
                .padding(.top, 24)

                // Input Fields
                VStack(spacing: 16) {
                    CustomInputField(
                            placeholder: "Enter your email",
                            text: $email,
                            field: .email,
                            focusedField: $focusedField
                    )
                    
                    CustomInputField(
                            placeholder: "Enter your password",
                            text: $password,
                            field: .password,
                            focusedField: $focusedField
                    )
                }

                // Error Message
                if let errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text(errorMessage)
                    }
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)
                }

                // Log In Button
                Button(action: login) {
                    Group {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Log In")
                                .font(FormatConfig.Fonts.button)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(isFormValid ? FormatConfig.Colors.LogInColors.electricBlue : FormatConfig.Colors.LogInColors.mutedText.opacity(0.3))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(!isFormValid || isLoading)
                .padding(.top, 8)

                // Sign Up Route
                HStack(spacing: 4) {
                    Text("Don't have an account?")
                        .foregroundStyle(FormatConfig.Colors.LogInColors.mutedText)
                        .font(FormatConfig.Fonts.caption)
                    
                    NavigationLink {
                        EmailSignUpView()
                    } label: {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .foregroundStyle(FormatConfig.Colors.LogInColors.electricBlue)
                            .font(FormatConfig.Fonts.caption)
                    }
                }
                .font(.subheadline)
                .padding(.top, 4)
            }
            .padding(.horizontal, 24)
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("🍿What's Next")
        .navigationSubtitle("Log In")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(FormatConfig.Colors.LogInColors.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .background(FormatConfig.Colors.LogInColors.background.ignoresSafeArea())
        .tint(FormatConfig.Colors.LogInColors.electricBlue)
    }
    
    private var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty && !password.isEmpty
    }

    private func login() {
        focusedField = nil
        isLoading = true
        errorMessage = nil
        Task {
            do {
                try await authViewModel.signInWithEmail(email: email, password: password)
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

#Preview {
    NavigationStack {
        EmailLoginView()
            .environment(AuthViewModel())
    }
}
