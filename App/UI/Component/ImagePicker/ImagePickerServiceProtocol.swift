//
//  ImagePickerServiceProtocol.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 28/07/25.
//

import UIKit
import SwiftUI

public protocol ImagePickerServiceProtocol {
    func pickImage(sourceType: UIImagePickerController.SourceType) async -> UIImage?
}
