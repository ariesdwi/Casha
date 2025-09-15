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
    var placeholder: String = ""
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator
        
        // Set up placeholder
        textView.text = placeholder
        textView.textColor = .placeholderText
        
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        // Only update text if it's not empty (to preserve placeholder)
        if !text.isEmpty {
            uiView.text = text
            uiView.textColor = .label
        }
        
        // Handle placeholder visibility
        if text.isEmpty && !uiView.isFirstResponder {
            uiView.text = placeholder
            uiView.textColor = .placeholderText
        }

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
            // Only update binding if text isn't placeholder
            if textView.text != parent.placeholder {
                parent.text = textView.text
                textView.textColor = .label
            }
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            // Clear placeholder when editing begins
            if textView.text == parent.placeholder {
                textView.text = ""
                textView.textColor = .label
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            // Show placeholder if text is empty
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = .placeholderText
            }
        }
    }
}
