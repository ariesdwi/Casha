//
//  CutomTabBar.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/09/25.
//


import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let tabs: [TabItem]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs) { tab in
                if tab.isCenterButton {
                    // Center Add Button
                    Button(action: {
                        tab.action?()
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color.cashaPrimary)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                            .accessibilityLabel(tab.title)
                    }
                    .offset(y: -10) // raised for prominence
                } else {
                    // Regular Tab Button
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = tab.tag
                        }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 22))
                                .symbolVariant(selectedTab == tab.tag ? .fill : .none)
                                .accessibilityHidden(true)
                            
                            Text(tab.title)
                                .font(.caption2)
                        }
                        .foregroundColor(selectedTab == tab.tag ? .cashaPrimary : .gray)
                        .frame(maxWidth: .infinity)
                        .accessibilityLabel(tab.title)
                        .accessibilityAddTraits(selectedTab == tab.tag ? .isSelected : [])
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .frame(height: 60)
        .background(Color.cashaBackground.ignoresSafeArea(edges: .bottom))
        .overlay(Divider(), alignment: .top)
    }
}

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
