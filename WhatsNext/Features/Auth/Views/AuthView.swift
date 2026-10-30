
import SwiftUI
import FirebaseCore

struct AuthView: View {
    @Environment(AuthViewModel.self) private var authViewModel

    @State private var errorMessage: String?
    @State private var isSigningIn = false

    private var blueGradient: LinearGradient {
        LinearGradient(
            colors: [FormatConfig.Colors.LogInColors.electricBlue, Color(hex: "2851DA")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer(minLength: 60)

                        VStack(spacing: 28) {
                            Image("Icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 28)
                                )

                            VStack(spacing: 12) {
                                Text("Welcome To")
                                    .foregroundStyle(.white)
                                    .font(FormatConfig.Fonts.title)

                                Text("WhatsNext!")
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
                                    .font(FormatConfig.Fonts.title)
                            }
                            .tracking(-1.5)
                            .multilineTextAlignment(.center)

                            Text("Discover, share, and choose\nmovies with friends.")
                                .font(FormatConfig.Fonts.subtitle)
                                .foregroundStyle(FormatConfig.Colors.LogInColors.mutedText)
                                .multilineTextAlignment(.center)
                                .lineSpacing(5)
                        }

                        Spacer(minLength: 65)

                        // MARK: - Authentication
                        VStack(spacing: 14) {

                            NavigationLink {
                                EmailLoginView()
                            } label: {
                                HStack {
                                    Image(systemName: "envelope")
                                        .font(.system(size: 18))

                                    Spacer()

                                    Text("Log In")
                                        .fontWeight(.semibold)
                                        .font(FormatConfig.Fonts.button)

                                    Spacer()

                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 16))
                                }
                                .font(.system(size: 17))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 22)
                                .frame(height: 56)
                                .background(blueGradient)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                            }

                            NavigationLink {
                                EmailSignUpView()
                            } label: {
                                HStack {
                                    Image(systemName: "person.crop.circle")
                                        .font(.system(size: 19))

                                    Spacer()

                                    Text("Sign Up with Email")
                                        .fontWeight(.semibold)
                                        .font(FormatConfig.Fonts.button)

                                    Spacer()

                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 16))
                                }
                                .font(.system(size: 17))
                                .foregroundStyle(FormatConfig.Colors.LogInColors.iceBlue)
                                .padding(.horizontal, 22)
                                .frame(height: 56)
                                .background(FormatConfig.Colors.LogInColors.surface)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(
                                            FormatConfig.Colors.LogInColors.electricBlue.opacity(0.65),
                                            lineWidth: 1
                                        )
                                }
                            }
                        }

                        // MARK: - Divider
                        HStack(spacing: 16) {
                            Rectangle()
                                .fill(.white.opacity(0.13))
                                .frame(height: 1)

                            Text("or continue with")
                                .font(FormatConfig.Fonts.caption)
                                .foregroundStyle(FormatConfig.Colors.LogInColors.mutedText)
                                .fixedSize()

                            Rectangle()
                                .fill(.white.opacity(0.13))
                                .frame(height: 1)
                        }
                        .padding(.vertical, 27)

                        // MARK: - Google Sign In
                        Button(action: handleGoogleSignIn) {
                            HStack(spacing: 12) {
                                Image(systemName: "g.circle.fill")
                                    .font(.system(size: 24))

                                Text("Sign in with Google")
                                    .font(FormatConfig.Fonts.button)
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(FormatConfig.Colors.LogInColors.surface)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 16)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(
                                        .white.opacity(0.12),
                                        lineWidth: 1
                                    )
                            }
                        }
                        .disabled(isSigningIn)

                        if isSigningIn {
                            ProgressView()
                                .tint(FormatConfig.Colors.LogInColors.iceBlue)
                                .padding(.top, 12)
                        }

                        if let errorMessage {
                            Text(errorMessage)
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)
                                .padding(.top, 12)
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 28)
                    .frame(
                        maxWidth: 440,
                        minHeight: geometry.size.height
                    )
                    .frame(maxWidth: .infinity)
                }
                .scrollIndicators(.hidden)
                .background(FormatConfig.Colors.LogInColors.background)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .tint(FormatConfig.Colors.LogInColors.electricBlue)
    }

    private func handleGoogleSignIn() {
        guard !isSigningIn else { return }

        isSigningIn = true
        errorMessage = nil

        Task {
            defer { isSigningIn = false }

            do {
                try await authViewModel.signInWithGoogle()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    let _ = {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }()

    return AuthView()
        .environment(AuthViewModel())
}
