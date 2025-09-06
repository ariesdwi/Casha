//
//  SplashScreen.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/07/25.


import SwiftUI

struct SplashView: View {
    @EnvironmentObject var loginState: LoginState
    @State private var isActive = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity = 0.5

    var body: some View {
        if isActive {
            LoginView()
        } else {
            VStack {
                Image("app")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .scaleEffect(scale)
                    .opacity(opacity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.cashaBackground)
            .onAppear {
                withAnimation(.easeIn(duration: 1.0)) {
                    scale = 1.2
                    opacity = 1.0
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    loginState.checkStoredToken()
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

