//
//  RootCoordinatorView.swift
//  ComponentKitDemo
//
//  Created by thinkpalm on 23/10/26.
//

import SwiftUI

struct RootCoordinatorView: View {
    @State private var isLoggedIn = false

    var body: some View {
        Group {
            if isLoggedIn {
                DashboardView(isLoggedIn: $isLoggedIn)
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
                    .transition(.opacity)
            }
        }
    }
}

#Preview {
    RootCoordinatorView()
}
