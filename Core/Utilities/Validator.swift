//
//  Validator.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 15/07/25.
//

import Foundation

public struct Validator {
    public static func isValidEmail(_ email: String) -> Bool {
        let regex = #"^\S+@\S+\.\S+$"#
        return email.range(of: regex, options: .regularExpression) != nil
    }

    public static func isValidAmount(_ value: Double) -> Bool {
        return value >= 0
    }
}
