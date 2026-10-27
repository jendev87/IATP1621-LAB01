//
//  DashboardView.swift
//  ComponentKitDemo
//
//  Created by thinkpalm on 23/10/26.
//

import SwiftUI

struct DashboardView: View {
    @Binding var isLoggedIn: Bool

    @State private var showSettingsSheet = false
    @State private var showCreateItemSheet = false
    @State private var newItemTitle = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Summary Section using Elevated Card
                    CustomCard(
                        title: "Overview",
                        subtitle: "Current System Status",
                        style: .elevated
                    ) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Active Modules")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("4 Components")
                                    .font(.title2)
                                    .bold()
                            }
                            Spacer()
                            CustomButton(title: "New Item", icon: "plus", variant: .primary) {
                                showCreateItemSheet = true
                            }
                        }
                    }

                    // Activity Section using Outlined Card
                    CustomCard(
                        title: "Recent Alerts",
                        subtitle: "Outlined style demonstration",
                        style: .outlined
                    ) {
                        Text("All services running smoothly. Sheets and Modals are ready to trigger.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // Quick Actions Section using Flat Card
                    CustomCard(
                        title: "Actions",
                        style: .flat
                    ) {
                        VStack(spacing: 12) {
                            CustomButton(
                                title: "Preferences Sheet",
                                icon: "gearshape",
                                variant: .secondary,
                                isFullWidth: true
                            ) {
                                showSettingsSheet = true
                            }

                            CustomButton(
                                title: "Log Out",
                                icon: "rectangle.portrait.and.arrow.right",
                                variant: .destructive,
                                isFullWidth: true
                            ) {
                                withAnimation(.easeInOut) {
                                    isLoggedIn = false
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            // Reusable Sheet 1: Preferences / Settings
            .sheet(isPresented: $showSettingsSheet) {
                CustomModalSheet(title: "Preferences", isPresented: $showSettingsSheet) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Configure your workspace settings here.")
                            .font(.body)
                            .foregroundColor(.secondary)

                        CustomButton(title: "Save & Close", variant: .primary, isFullWidth: true) {
                            showSettingsSheet = false
                        }
                    }
                }
                .presentationDetents([.medium])
            }
            // Reusable Sheet 2: Form Input inside Modal
            .sheet(isPresented: $showCreateItemSheet) {
                CustomModalSheet(title: "Create Item", isPresented: $showCreateItemSheet) {
                    VStack(spacing: 16) {
                        CustomInputField(
                            label: "Item Name",
                            placeholder: "e.g., Design System Token",
                            text: $newItemTitle
                        )

                        CustomButton(title: "Add Item", variant: .primary, isFullWidth: true) {
                            showCreateItemSheet = false
                            newItemTitle = ""
                        }
                    }
                }
                .presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview("Dashboard View - Interactive") {
    struct DashboardPreviewContainer: View {
        @State private var loggedIn = true

        var body: some View {
            if loggedIn {
                DashboardView(isLoggedIn: $loggedIn)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "door.left.hand.open")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("Logged Out")
                        .font(.headline)
                    Button("Log Back In") {
                        loggedIn = true
                    }
                    .padding(.top, 8)
                }
            }
        }
    }

    return DashboardPreviewContainer()
}
