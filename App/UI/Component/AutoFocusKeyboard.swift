//
//  AutoFocusKeyboard.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 17/07/25.
//

import SwiftUI

struct AutoFocusTextEditor: UIViewRepresentable {
    @Binding var text: String
    var onBecomeFirstResponder: Bool

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text

        if onBecomeFirstResponder && !context.coordinator.didBecomeFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: AutoFocusTextEditor
        var didBecomeFirstResponder = false

        init(_ parent: AutoFocusTextEditor) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}
