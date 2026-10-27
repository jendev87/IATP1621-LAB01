//
//  CustomInputField.swift
//  ComponentKitDemo
//
//  Created by thinkpalm on 23/10/26.
//

import SwiftUI

public struct CustomInputField: View {
    public let label: String
    public let placeholder: String
    @Binding public var text: String
    public var icon: String? = nil
    public var isSecure: Bool = false
    public var errorMessage: String? = nil

    @State private var isRevealed: Bool = false

    public init(
        label: String,
        placeholder: String,
        text: Binding<String>,
        icon: String? = nil,
        isSecure: Bool = false,
        errorMessage: String? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.icon = icon
        self.isSecure = isSecure
        self.errorMessage = errorMessage
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)

            HStack(spacing: 10) {
                if let icon {
                    Image(systemName: icon)
                        .foregroundColor(.secondary)
                }

                if isSecure && !isRevealed {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }

                if isSecure {
                    Button(action: { isRevealed.toggle() }) {
                        Image(systemName: isRevealed ? "eye.slash" : "eye")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(12)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(errorMessage != nil ? Color.red : Color(.separator), lineWidth: 1)
            )

            if let errorMessage {
                Text(errorMessage)
                    .font(.caption2)
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview("Input Field Variants") {
    // Wrapper struct allows live interactive typing in Canvas
    struct PreviewContainer: View {
        @State private var standardText = ""
        @State private var passwordText = "secret123"
        @State private var emailWithError = "invalid-email"

        var body: some View {
            VStack(spacing: 20) {
                // 1. Standard Input Field
                CustomInputField(
                    label: "Username",
                    placeholder: "e.g. johndoe",
                    text: $standardText,
                    icon: "person.fill"
                )

                // 2. Secure Input Field (Password)
                CustomInputField(
                    label: "Password",
                    placeholder: "Enter password",
                    text: $passwordText,
                    icon: "lock.fill",
                    isSecure: true
                )

                // 3. Input Field with Error State
                CustomInputField(
                    label: "Email Address",
                    placeholder: "name@domain.com",
                    text: $emailWithError,
                    icon: "envelope.fill",
                    errorMessage: "Please enter a valid email address."
                )
            }
            .padding()
        }
    }

    return PreviewContainer()
}
