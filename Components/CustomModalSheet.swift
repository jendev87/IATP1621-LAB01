//
//  CustomModalSheet.swift
//  ComponentKitDemo
//
//  Created by thinkpalm on 23/10/26.
//

import SwiftUI

public struct CustomModalSheet<Content: View>: View {
    public let title: String
    @Binding public var isPresented: Bool
    public let content: Content

    public init(
        title: String,
        isPresented: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self._isPresented = isPresented
        self.content = content()
    }

    public var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                content
                Spacer()
            }
            .padding()
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview("Modal Sheet Preview") {
    struct SheetPreviewContainer: View {
        @State private var isSheetOpen = true

        var body: some View {
            VStack {
                Button("Present Modal") {
                    isSheetOpen = true
                }
            }
            .sheet(isPresented: $isSheetOpen) {
                CustomModalSheet(title: "Account Settings", isPresented: $isSheetOpen) {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Manage your preferences and profile details here.")
                            .font(.body)
                            .foregroundColor(.secondary)

                        Divider()

                        HStack {
                            Text("Notifications")
                            Spacer()
                            Toggle("", isOn: .constant(true))
                                .labelsHidden()
                        }

                        Spacer()
                    }
                }
                .presentationDetents([.medium, .large])
            }
        }
    }

    return SheetPreviewContainer()
}
