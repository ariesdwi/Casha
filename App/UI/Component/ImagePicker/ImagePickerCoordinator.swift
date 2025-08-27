//
//  Untitled.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 28/07/25.
//


import UIKit
import SwiftUI

final class ImagePickerCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let sourceType: UIImagePickerController.SourceType
    private let onPick: (UIImage?) -> Void

    init(sourceType: UIImagePickerController.SourceType, onPick: @escaping (UIImage?) -> Void) {
        self.sourceType = sourceType
        self.onPick = onPick
    }

    func present() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = scene.windows.first?.rootViewController else {
            onPick(nil)
            return
        }

        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self

        root.present(picker, animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        onPick(nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        let image = info[.originalImage] as? UIImage
        onPick(image)
    }
}
