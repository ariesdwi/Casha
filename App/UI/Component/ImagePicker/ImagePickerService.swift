//
//  ImagePickerService.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 28/07/25.
//

import Foundation
import UIKit
import SwiftUI

public final class ImagePickerService: ImagePickerServiceProtocol {
    public init() {}

    public func pickImage(sourceType: UIImagePickerController.SourceType) async -> UIImage? {
        await withCheckedContinuation { continuation in
            let picker = ImagePickerCoordinator(sourceType: sourceType) { image in
                continuation.resume(returning: image)
            }

            picker.present()
        }
    }
}
