//
//  KeyboardHelper.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 17/07/25.
//

import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    private var cancellable: AnyCancellable?

    init() {
        cancellable = Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
                .map { $0.height },

            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
        )
        .assign(to: \.currentHeight, on: self)
    }

    deinit {
        cancellable?.cancel()
    }
}
