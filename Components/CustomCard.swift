//
//  CustomCard.swift
//  ComponentKitDemo
//
//  Created by thinkpalm on 23/10/26.
//

import SwiftUI

public enum CardStyle {
    case elevated, outlined, flat
}

public struct CustomCard<Content: View>: View {
    public var title: String?
    public var subtitle: String?
    public var style: CardStyle
    public let content: Content

    public init(
        title: String? = nil,
        subtitle: String? = nil,
        style: CardStyle = .elevated,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if title != nil || subtitle != nil {
                VStack(alignment: .leading, spacing: 4) {
                    if let title {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    if let subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator), lineWidth: style == .outlined ? 1 : 0)
        )
        .shadow(color: style == .elevated ? Color.black.opacity(0.08) : .clear, radius: 8, x: 0, y: 4)
    }

    private var backgroundColor: Color {
        switch style {
        case .elevated: return Color(.secondarySystemBackground)
        case .outlined: return Color(.systemBackground)
        case .flat: return Color(.tertiarySystemBackground)
        }
    }
}

#Preview("Card Variants") {
    ScrollView {
        VStack(spacing: 20) {
            // Elevated Style
            CustomCard(
                title: "Elevated Card",
                subtitle: "Default shadow appearance",
                style: .elevated
            ) {
                Text("This card uses a subtle drop shadow to lift content above the canvas.")
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            // Outlined Style
            CustomCard(
                title: "Outlined Card",
                subtitle: "Crisp border appearance",
                style: .outlined
            ) {
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                    Text("Verified account details")
                        .font(.subheadline)
                }
            }

            // Flat Style
            CustomCard(
                title: "Flat Card",
                subtitle: "Tertiary background fill",
                style: .flat
            ) {
                Text("Good for callouts or secondary embedded sections.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}
