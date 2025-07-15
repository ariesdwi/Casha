//
//  Permission.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/07/25.
//

import AVFoundation

public struct PermissionAccess {
    public init() {}
    
    public func checkCameraAccess(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        default:
            completion(false)
        }
    }
}
