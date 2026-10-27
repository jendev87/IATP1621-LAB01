# ComponentKitDemo — Reusable SwiftUI Component Library

[![Swift](https://img.shields.io/badge/Swift-5.9+-F05138?style=flat-square&logo=swift&logoColor=white)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-17.0+-000000?style=flat-square&logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![Xcode](https://img.shields.io/badge/Xcode-15.0+-1575F9?style=flat-square&logo=xcode&logoColor=white)](https://developer.apple.com/xcode/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-Native-0071e3?style=flat-square&logo=swift&logoColor=white)](https://developer.apple.com/xcode/swiftui/)
[![Architecture](https://img.shields.io/badge/Architecture-State--Driven%20Coordinator-8A2BE2?style=flat-square)](#app-flow--demo-showcase)

A modular, production-ready design system and component library built natively with SwiftUI for iOS 17+. This project demonstrates clean UI encapsulation, type-safe prop-driven interfaces, responsive accessibility styling, and state-driven flow orchestration for modern iOS applications.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Key Architectural Highlights](#key-architectural-highlights)
- [Component API Reference](#component-api-reference)
  - [1. CustomButton](#1-custombutton)
  - [2. CustomCard](#2-customcard)
  - [3. CustomInputField](#3-custominputfield)
  - [4. CustomModalSheet](#4-custommodalsheet)
- [App Flow & Demo Showcase](#app-flow--demo-showcase)
- [Project Structure](#project-structure)
- [Setup & Running Instructions](#setup--running-instructions)
  - [Prerequisites](#prerequisites)
  - [Building & Running the App](#building--running-the-app)
  - [Interactive Previews in Xcode](#interactive-previews-in-xcode)
- [Design Decisions & Best Practices](#design-decisions--best-practices)

---

## Project Overview

`ComponentKitDemo` was engineered as a foundational UI kit to solve common design inconsistencies and reduce repetitive view boilerplate. Every component is designed following Apple's Human Interface Guidelines (HIG) and core SwiftUI idioms:

- **Prop-Driven Customization**: Components expose clear, idiomatic initializer parameters with sensible default values.
- **View Composition via `@ViewBuilder`**: Structural containers like cards and sheets leverage Swift closures to support arbitrary view hierarchies without tight coupling.
- **Zero Third-Party Dependencies**: Pure native SwiftUI code utilizing SF Symbols and native semantic system colors (`Color(.secondarySystemBackground)`, `Color(.separator)`) for automatic Light and Dark mode compliance.
- **State-Driven Routing**: Screen transitions are coordinated cleanly using pure state bindings rather than polluting the navigation stack.

---

## Key Architectural Highlights

```
┌─────────────────────────────────────────────────────────────┐
│                    RootCoordinatorView                      │
│                (Centralized Flow Management)                │
└──────────────────────────────┬──────────────────────────────┘
                               │
               ┌───────────────┴───────────────┐
      [isLoggedIn == false]            [isLoggedIn == true]
               │                               │
               ▼                               ▼
       ┌───────────────┐               ┌───────────────┐
       │   LoginView   │               │ DashboardView │
       └───────┬───────┘               └───────┬───────┘
               │                               │
               ├─ CustomInputField             ├─ CustomCard (All styles)
               ├─ CustomButton                 ├─ CustomButton (Variants)
               └─ Regex Form Validation        └─ CustomModalSheet (Detents)
```

1. **Atomic Component Separation**: Components in `Components/` are standalone, reusable building blocks with no dependencies on specific screens.
2. **Predictable State Flow**: Single source of truth managed via SwiftUI bindings (`@Binding`) and local state (`@State`).
3. **No Navigation Stack Pollution**: Authentication state switches top-level views via animated state-driven transitions rather than pushing/popping screens inside a monolithic `NavigationStack`.

---

## Component API Reference

### 1. CustomButton

A versatile, accessible button supporting multiple semantic variants, full-width stretching, SF Symbol icon placement, and built-in loading indicator feedback with tap interaction lock.

#### Parameters

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `title` | `String` | *Required* | Text displayed inside the button. |
| `icon` | `String?` | `nil` | Optional SF Symbol name rendered leading the title. |
| `variant` | `ButtonVariant` | `.primary` | Visual appearance (`.primary`, `.secondary`, `.destructive`). |
| `isLoading` | `Bool` | `false` | When `true`, displays a `ProgressView` and disables tap interactions. |
| `isFullWidth` | `Bool` | `false` | If `true`, expands button horizontally to fill available width (`.infinity`). |
| `action` | `@escaping () -> Void` | *Required* | Closure executed on user tap. |

#### Variant Specifications

- `.primary`: Solid accent fill (System Blue) with white text.
- `.secondary`: Transparent background with border stroke and accent text.
- `.destructive`: High-visibility danger fill (System Red) with white text.

#### Code Example

```swift
// Standard Primary Button with SF Symbol
CustomButton(title: "Save Changes", icon: "square.and.arrow.down", variant: .primary) {
    print("Saved")
}

// Full-width Loading Button (Interaction disabled automatically)
CustomButton(
    title: "Signing In...",
    variant: .primary,
    isLoading: isSubmitting,
    isFullWidth: true
) {
    authenticateUser()
}

// Destructive Action
CustomButton(title: "Delete Account", icon: "trash.fill", variant: .destructive) {
    confirmDeletion()
}
```

---

### 2. CustomCard

A generic container view utilizing `@ViewBuilder` to encapsulate consistent padding, background styling, corner radii, borders, and shadows across cards.

#### Parameters

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `title` | `String?` | `nil` | Optional card header title (rendered in `.headline`). |
| `subtitle` | `String?` | `nil` | Optional card subtitle (rendered in `.subheadline` secondary). |
| `style` | `CardStyle` | `.elevated` | Visual style (`.elevated`, `.outlined`, `.flat`). |
| `content` | `() -> Content` | *Required* | `@ViewBuilder` closure yielding the card's child views. |

#### Style Specifications

- `.elevated`: Subtle drop shadow with `.secondarySystemBackground` fill.
- `.outlined`: 1pt separator border overlay on `.systemBackground`.
- `.flat`: Clean borderless background using `.tertiarySystemBackground`.

#### Code Example

```swift
// Elevated metric card
CustomCard(title: "Active Modules", subtitle: "System Overview", style: .elevated) {
    HStack {
        Text("4 Components Loaded")
            .font(.title3)
            .bold()
        Spacer()
        Image(systemName: "checkmark.circle.fill")
            .foregroundColor(.green)
    }
}

// Outlined action card
CustomCard(title: "Quick Action", style: .outlined) {
    Text("Configure workspace preferences.")
        .foregroundColor(.secondary)
}
```

---

### 3. CustomInputField

An input field featuring an integrated title label, SF Symbol leading icon, inline password visibility toggle, and dynamic validation error styling.

#### Parameters

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `label` | `String` | *Required* | Label text displayed above the input field. |
| `placeholder` | `String` | *Required* | Placeholder/prompt text rendered inside the input field. |
| `text` | `Binding<String>` | *Required* | Two-way binding to the target string state. |
| `icon` | `String?` | `nil` | Optional SF Symbol icon placed inside the leading edge of the field. |
| `isSecure` | `Bool` | `false` | When `true`, wraps a `SecureField` with an eye-icon visibility toggle. |
| `errorMessage` | `String?` | `nil` | Validation error string. Triggers red border highlight and caption text. |

#### Validation Highlights

- Dynamic border highlighting: Outlines field with `Color.red` when `errorMessage != nil`.
- Error caption: Displays localized error copy beneath the field in `.caption2`.
- Password Reveal: Seamlessly toggles between `SecureField` and `TextField` using local state without losing focus.

#### Code Example

```swift
// Standard Text Input with Validation
CustomInputField(
    label: "Email Address",
    placeholder: "name@example.com",
    text: $email,
    icon: "envelope.fill",
    errorMessage: emailError
)

// Secure Password Input with Toggle
CustomInputField(
    label: "Password",
    placeholder: "Enter password",
    text: $password,
    icon: "lock.fill",
    isSecure: true,
    errorMessage: passwordError
)
```

---

### 4. CustomModalSheet

A modal presentation wrapper that embeds content inside a standard `NavigationStack` with an inline title and standard toolbar dismiss button.

#### Parameters

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `title` | `String` | *Required* | Title string displayed in the navigation bar. |
| `isPresented` | `Binding<Bool>` | *Required* | Binding controlling modal presentation and programmatic dismissal. |
| `content` | `() -> Content` | *Required* | `@ViewBuilder` closure defining the sheet content. |

#### Code Example

```swift
.sheet(isPresented: $showSheet) {
    CustomModalSheet(title: "Preferences", isPresented: $showSheet) {
        VStack(spacing: 16) {
            Text("Adjust application settings below.")
                .foregroundColor(.secondary)
            
            CustomButton(title: "Save & Close", variant: .primary, isFullWidth: true) {
                showSheet = false
            }
        }
    }
    .presentationDetents([.medium, .large])
}
```

---

## App Flow & Demo Showcase

The application ties these components together into a complete, interactive user flow:

```
[ Launch App ]
      │
      ▼
┌──────────────┐       Invalid Credentials
│  LoginView   │ ───────────────────────────────┐
└──────┬───────┘                                │
       │ Valid Input & Tap "Sign In"            ▼
       │ (Simulated 1.2s Network Request)  [ Display Field Errors ]
       ▼
┌──────────────┐
│DashboardView │ ◄── Demonstrates Cards & Custom Buttons
└──────┬───────┘
       │
       ├─► Tap "New Item" ───────► Opens CustomModalSheet (Detents: .medium, .large)
       ├─► Tap "Preferences" ───► Opens CustomModalSheet (Detents: .medium)
       │
       └─► Tap "Log Out" (Destructive)
             │
             ▼
       [ Reset Session & Transition to LoginView ]
```

1. **`LoginView`**:
   - Utilizes `CustomInputField` with independent state validation for Email (regex format verification) and Password (minimum 6-character length).
   - Demonstrates `CustomButton` in its `.primary` state, triggering `isLoading = true` to simulate an asynchronous authentication round-trip.
2. **`DashboardView`**:
   - Demonstrates all three `CustomCard` styles in a vertical scroll feed (`.elevated`, `.outlined`, and `.flat`).
   - Integrates `CustomModalSheet` presentations with sheet detent support (`.presentationDetents([.medium, .large])`).
   - Features a destructive `CustomButton` variant for the sign-out flow.
3. **`RootCoordinatorView`**:
   - Observes authentication state (`isLoggedIn`).
   - Switches the root view hierarchy with smooth opacity and scale transitions, preventing navigation stack buildup.

---

## Project Structure

```
ComponentKitDemo/
├── ComponentKitDemoApp.swift       # Main @main App lifecycle entry point
├── ContentView.swift               # Default starter template view
├── Assets.xcassets                 # Colors, app icons, and asset catalog
│
├── Components/                     # Reusable Design System Library
│   ├── CustomButton.swift          # Primary, secondary & destructive buttons + loading states
│   ├── CustomCard.swift            # Generic @ViewBuilder container with 3 visual styles
│   ├── CustomInputField.swift      # Form fields with validation, SF Symbols & secure toggles
│   └── CustomModalSheet.swift      # Standardized modal sheet wrapper with navigation toolbar
│
└── Screens/                        # Integrated Application Screens & Navigation
    ├── RootCoordinatorView.swift   # State-driven root flow coordinator (Auth routing)
    ├── LoginView.swift             # Interactive login form demonstrating input validation
    └── DashboardView.swift         # Comprehensive dashboard demonstrating all components
```

---

## Setup & Running Instructions

### Prerequisites

- **macOS**: Sonoma 14.0 or later (Sequoia 15.0+ recommended)
- **Xcode**: Version 15.0 or later
- **Swift**: Swift 5.9+
- **Simulator / Device**: iOS 17.0 or later

### Building & Running the App

1. **Clone the repository**:
   ```bash
   git clone https://github.com/<your-username>/ComponentKitDemo.git
   cd ComponentKitDemo
   ```

2. **Open in Xcode**:
   - Launch Xcode and select **Open existing project**, or run:
     ```bash
     open ComponentKitDemo.xcodeproj
     ```

3. **Select Scheme & Destination**:
   - In Xcode's top toolbar, ensure the active scheme is set to **`ComponentKitDemo`**.
   - Choose any iOS 17+ Simulator (e.g., **iPhone 15 Pro**).

4. **Build and Run**:
   - Press `Cmd + R` or click the **Run** (Play) button in the toolbar.

---

### Interactive Previews in Xcode

Every component and screen includes a dedicated, interactive `#Preview` macro container:

1. Open any component file (e.g., [`CustomInputField.swift`](file:///Users/thinkpalm/MyWorkspace/iOSProjects/ComponentKitDemo/ComponentKitDemo/Components/CustomInputField.swift) or [`DashboardView.swift`](file:///Users/thinkpalm/MyWorkspace/iOSProjects/ComponentKitDemo/ComponentKitDemo/Screens/DashboardView.swift)).
2. Press <kbd>Option</kbd> + <kbd>Cmd</kbd> + <kbd>Return</kbd> to open the Xcode Canvas.
3. Click the **Live Preview** button to interact with form toggles, buttons, and sheets directly in the canvas without launching the simulator.

---

## Design Decisions & Best Practices

- **Adaptive Accessibility**: Fonts utilize Dynamic Type scaling styles (`.headline`, `.subheadline`, `.caption`) to respect system text size adjustments.
- **Debounced Interactions**: `CustomButton` sets `.disabled(isLoading)` when an asynchronous action is active, preventing accidental duplicate form submissions.
- **Semantic Colors**: Built entirely with dynamic system colors to support Light Mode and Dark Mode out-of-the-box without asset duplication.
- **Separation of Concerns**: View layouts are decoupled from validation logic, enabling quick refactoring or conversion to an MVVM ViewModel architecture if required.
