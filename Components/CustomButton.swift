//
//  CustomButton.swift
//  ComponentKitDemo
//
//  Created by thinkpalm on 23/10/26.
//

import SwiftUI

public enum ButtonVariant {
    case primary, secondary, destructive
}

struct CustomButton: View {

    public let title: String
    public var icon: String? = nil
    public var variant: ButtonVariant = .primary
    public var isLoading: Bool = false
    public var isFullWidth: Bool = false
    public let action: () -> Void

    public init(
        title: String,
        icon: String? = nil,
        variant: ButtonVariant = .primary,
        isLoading: Bool = false,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.variant = variant
        self.isLoading = isLoading
        self.isFullWidth = isFullWidth
        self.action = action
    }

    public var body: some View {
            Button(action: action) {
                HStack(spacing: 8) {
                    if isLoading {
                        ProgressView()
                            .tint(foregroundColor)
                    } else {
                        if let icon {
                            Image(systemName: icon)
                        }
                        Text(title)
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: isFullWidth ? .infinity : nil)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor, lineWidth: variant == .secondary ? 1.5 : 0)
                )
                .cornerRadius(10)
            }
            .disabled(isLoading)
        }

        private var backgroundColor: Color {
            switch variant {
            case .primary: return .blue
            case .secondary: return .clear
            case .destructive: return .red
            }
        }

        private var foregroundColor: Color {
            switch variant {
            case .primary, .destructive: return .white
            case .secondary: return .blue
            }
        }

        private var borderColor: Color {
            variant == .secondary ? .blue : .clear
        }
    }


#Preview("Custom Button Variants") {
    VStack(spacing: 16) {
        CustomButton(title: "Primary Action", icon: "sparkles", variant: .primary) {
            print("Primary tapped")
        }

        CustomButton(title: "Secondary Action", variant: .secondary) {
            print("Secondary tapped")
        }

        CustomButton(title: "Destructive Action", icon: "trash", variant: .destructive) {
            print("Destructive tapped")
        }

        CustomButton(title: "Loading State", variant: .primary, isLoading: true) {
            // No action needed for loading preview
        }

        CustomButton(title: "Full Width Button", variant: .primary, isFullWidth: true) {
            print("Full width tapped")
        }
    }
    .padding()
}
