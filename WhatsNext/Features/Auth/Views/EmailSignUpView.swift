//
//  EmailSignUpView.swift
//  WhatsNext
//
//  Created by Bensu Özyurt on 18.10.2026.
//

import SwiftUI

struct EmailSignUpView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    @State private var isLoading = false
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case email, password, username, confirmPassword
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

                    Text("Welcome to What's Next")
                        .font(FormatConfig.Fonts.createFont(
                            fontName: FormatConfig.Fonts.titleFontName,
                            size: 30))
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
                            placeholder: "Enter your username",
                            text: $username,
                            field: .username,
                            focusedField: $focusedField
                    )
                    
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
                    
                    CustomInputField(
                            placeholder: "Confirm your password",
                            text: $confirmPassword,
                            field: .confirmPassword,
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
                Button(action: signUp) {
                    Group {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Sign Up")
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
                    Text("Do you have an account?")
                        .foregroundStyle(FormatConfig.Colors.LogInColors.mutedText)
                        .font(FormatConfig.Fonts.caption)
                    
                    NavigationLink {
                        EmailLoginView()
                    } label: {
                        Text("Log In")
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
        .navigationSubtitle("Sign Up")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(FormatConfig.Colors.LogInColors.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .background(FormatConfig.Colors.LogInColors.background.ignoresSafeArea())
        .tint(FormatConfig.Colors.LogInColors.electricBlue)
    }
    
    private var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !username.trimmingCharacters(in: .whitespaces).isEmpty &&
        password.count >= 6 &&
        password == confirmPassword
    }

    private func signUp() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        isLoading = true
        errorMessage = nil
        Task {
            do {
                // Call create account method in AuthViewModel
                try await authViewModel.signUpWithEmail(email: email, password: password, username: username)
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

#Preview {
    NavigationStack {
        EmailSignUpView()
            .environment(AuthViewModel())
    }
}
