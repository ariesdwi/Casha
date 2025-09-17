//
//  SpendingPeriod.swift
//  Casha
//
//  Created by PT Siaga Abdi Utama on 17/09/25.
//
import Foundation

public enum SpendingPeriod : Equatable{
    case thisMonth
    case lastThreeMonths
    case thisYear
    case custom(DateInterval)
    case allTime
}
