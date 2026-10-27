//
//  LoginView.swift
//  ComponentKitDemo
//
//  Created by thinkpalm on 23/10/26.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    
    @State private var email = ""
    @State private var password = ""
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var isLoading = false


    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 8) {
                Image(systemName: "app.badge.checkmark.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)

                Text("Welcome Back")
                    .font(.largeTitle)
                    .bold()

                Text("Sign in to explore the component kit")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 16) {
                CustomInputField(
                    label: "Email",
                    placeholder: "developer@example.com",
                    text: $email,
                    icon: "envelope.fill",
                    errorMessage: emailError
                )

                CustomInputField(
                    label: "Password",
                    placeholder: "Enter your password",
                    text: $password,
                    icon: "lock.fill",
                    isSecure: true,
                    errorMessage: passwordError
                )
            }

            CustomButton(
                title: "Sign In",
                icon: "arrow.right",
                variant: .primary,
                isLoading: isLoading,
                isFullWidth: true
            ) {
                handleLogin()
            }

            Spacer()
        }
        .padding(24)
    }

    private func handleLogin() {
    // Reset previous errors
    emailError = nil
    passwordError = nil
    
    var isValid = true

    // Email validation
    let emailTrimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
    let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}$"#
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

    if emailTrimmed.isEmpty {
        emailError = "Email is required."
        isValid = false
    } else if !emailPredicate.evaluate(with: emailTrimmed) {
        emailError = "Please enter a valid email address."
        isValid = false
    }

    // Password validation
    if password.isEmpty {
        passwordError = "Password is required."
        isValid = false
    } else if password.count < 6 {
        passwordError = "Password must be at least 6 characters."
        isValid = false
    }

    guard isValid else { return }

    // Proceed with authentication
    isLoading = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
        isLoading = false
        withAnimation(.easeInOut) {
            isLoggedIn = true
        }
    }
}

}

#Preview("Login View - Interactive") {
    struct LoginPreviewContainer: View {
        @State private var loggedIn = false

        var body: some View {
            if loggedIn {
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.green)
                    Text("Successfully Logged In!")
                        .font(.headline)
                    Button("Reset Preview") {
                        loggedIn = false
                    }
                    .padding(.top, 8)
                }
            } else {
                LoginView(isLoggedIn: $loggedIn)
            }
        }
    }

    return LoginPreviewContainer()
}
