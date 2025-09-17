////
////  CutomTabBar.swift
////  Casha
////
////  Created by PT Siaga Abdi Utama on 15/09/25.
////
//
//
//import SwiftUI
//
//struct CustomTabBar: View {
//    @Binding var selectedTab: Int
//    let tabs: [TabItem]
//    
//    var body: some View {
//        HStack(spacing: 0) {
//            ForEach(tabs) { tab in
//                if tab.isCenterButton {
//                    // Center Add Button
//                    Button(action: {
//                        tab.action?()
//                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
//                    }) {
//                        Image(systemName: tab.icon)
//                            .font(.system(size: 22, weight: .bold))
//                            .foregroundColor(.white)
//                            .frame(width: 56, height: 56)
//                            .background(Color.cashaPrimary)
//                            .clipShape(Circle())
//                            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
//                            .accessibilityLabel(tab.title)
//                    }
//                    .offset(y: -10) // raised for prominence
//                } else {
//                    // Regular Tab Button
//                    Button(action: {
//                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//                            selectedTab = tab.tag
//                        }
//                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
//                    }) {
//                        VStack(spacing: 4) {
//                            Image(systemName: tab.icon)
//                                .font(.system(size: 22))
//                                .symbolVariant(selectedTab == tab.tag ? .fill : .none)
//                                .accessibilityHidden(true)
//                            
//                            Text(tab.title)
//                                .font(.caption2)
//                        }
//                        .foregroundColor(selectedTab == tab.tag ? .cashaPrimary : .gray)
//                        .frame(maxWidth: .infinity)
//                        .accessibilityLabel(tab.title)
//                        .accessibilityAddTraits(selectedTab == tab.tag ? .isSelected : [])
//                    }
//                }
//            }
//        }
//        .padding(.horizontal, 16)
//        .padding(.top, 8)
//        .frame(height: 60)
//        .background(Color.cashaBackground.ignoresSafeArea(edges: .bottom))
//        .overlay(Divider(), alignment: .top)
//    }
//}
//
//struct TabItem: Identifiable {
//    let id = UUID()
//    let title: String
//    let icon: String
//    let tag: Int
//    let isCenterButton: Bool
//    var action: (() -> Void)? = nil
//}
//
//// MARK: - View Modifier
//struct CustomTabBarViewModifier: ViewModifier {
//    @Binding var selectedTab: Int
//    let tabs: [TabItem]
//    
//    func body(content: Content) -> some View {
//        content
//            .safeAreaInset(edge: .bottom) {
//                CustomTabBar(selectedTab: $selectedTab, tabs: tabs)
//            }
//    }
//}
//
//extension View {
//    func customTabBar(selectedTab: Binding<Int>, tabs: [TabItem]) -> some View {
//        self.modifier(CustomTabBarViewModifier(selectedTab: selectedTab, tabs: tabs))
//    }
//}


import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let tabs: [TabItem]
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs) { tab in
                if tab.isCenterButton {
                    // Center Add Button with enhanced animation
                    Button(action: {
                        tab.action?()
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }) {
                        ZStack {
                            // Pulsating background effect
                            Circle()
                                .fill(Color.cashaPrimary)
                                .frame(width: 56, height: 56)
                                .shadow(color: Color.cashaPrimary.opacity(0.4), radius: 8, x: 0, y: 4)
                                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                            
                            // Plus icon with bounce animation
                            Image(systemName: tab.icon)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .scaleEffect(1.0)
                        }
                        .frame(width: 64, height: 64)
                    }
                    .offset(y: -20)
                    .buttonStyle(ScaleButtonStyle())
                    .accessibilityLabel(tab.title)
                    
                } else {
                    // Regular Tab Button with enhanced animations
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = tab.tag
                        }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }) {
                        VStack(spacing: 6) {
                            ZStack {
                                // Background highlight for selected tab
                                if selectedTab == tab.tag {
                                    Circle()
                                        .fill(Color.cashaPrimary.opacity(0.15))
                                        .frame(width: 40, height: 40)
                                        .matchedGeometryEffect(id: "tab_highlight", in: animation)
                                }
                                
                                // Icon with fill animation
                                Image(systemName: tab.icon)
                                    .font(.system(size: 22))
                                    .symbolVariant(selectedTab == tab.tag ? .fill : .none)
                                    .foregroundColor(selectedTab == tab.tag ? .cashaPrimary : .gray)
                                    .scaleEffect(selectedTab == tab.tag ? 1.1 : 1.0)
                            }
                            .frame(height: 40)
                            
                            // Text with smooth color transition
                            Text(tab.title)
                                .font(.system(size: 10, weight: selectedTab == tab.tag ? .semibold : .regular))
                                .foregroundColor(selectedTab == tab.tag ? .cashaPrimary : .gray)
                                .scaleEffect(selectedTab == tab.tag ? 1.05 : 1.0)
                        }
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(TabButtonStyle())
                    .accessibilityLabel(tab.title)
                    .accessibilityAddTraits(selectedTab == tab.tag ? .isSelected : [])
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .frame(height: 74)
        .background(
            // Frosted glass background effect
            ZStack {
                Color.cashaBackground
                    .opacity(0.95)
                
                VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
                    .ignoresSafeArea()
            }
        )
        .overlay(Divider().background(Color.gray.opacity(0.3)), alignment: .top)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -2)
    }
}

// MARK: - Custom Button Styles
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct TabButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

// MARK: - Visual Effect View for Blur Background
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: effect)
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}

// MARK: - Tab Item Model
struct TabItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let tag: Int
    let isCenterButton: Bool
    var action: (() -> Void)? = nil
}

// MARK: - View Modifier
struct CustomTabBarViewModifier: ViewModifier {
    @Binding var selectedTab: Int
    let tabs: [TabItem]
    
    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom) {
                CustomTabBar(selectedTab: $selectedTab, tabs: tabs)
            }
    }
}

extension View {
    func customTabBar(selectedTab: Binding<Int>, tabs: [TabItem]) -> some View {
        self.modifier(CustomTabBarViewModifier(selectedTab: selectedTab, tabs: tabs))
    }
}

// MARK: - Preview
//#Preview {
//    struct PreviewWrapper: View {
//        @State private var selectedTab = 0
//        
//        var tabs: [TabItem] = [
//            TabItem(title: "Home", icon: "house", tag: 0, isCenterButton: false),
//            TabItem(title: "Report", icon: "chart.bar", tag: 1, isCenterButton: false),
//            TabItem(title: "Add", icon: "plus", tag: 2, isCenterButton: true, action: {
//                print("Add button tapped")
//            }),
//            TabItem(title: "Budget", icon: "creditcard", tag: 3, isCenterButton: false),
//            TabItem(title: "Profile", icon: "person", tag: 4, isCenterButton: false)
//        ]
//        
//        var body: some View {
//            VStack {
//                Spacer()
//                Text("Selected Tab: \(selectedTab)")
//                    .font(.title)
//                Spacer()
//            }
//            .customTabBar(selectedTab: $selectedTab, tabs: tabs)
//        }
//    }
//    
//    return PreviewWrapper()
//}
