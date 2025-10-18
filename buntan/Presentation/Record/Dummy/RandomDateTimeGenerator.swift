//
//  RandomDateTimeGenerator.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/18.
//

import Foundation

enum RandomDateTimeGenerator {
    
    enum TimeComponent {
        case hour
        case minute
        case second
        
        var upperLimit: Int {
            switch self {
            case .hour: return 23
            case .minute: return 59
            case .second: return 59
            }
        }
    }
    
    static func execute(
        daysBackLimit: Int = 30,
        calendar: Calendar = .current
    ) -> Date {
        let base = generateRandomPastDate(daysBackLimit: daysBackLimit, calendar: calendar)
        var comps = calendar.dateComponents([.year, .month, .day], from: base)
        comps.hour = generateRandomTimeComponent(for: .hour)
        comps.minute = generateRandomTimeComponent(for: .minute)
        comps.second = generateRandomTimeComponent(for: .second)
        return calendar.date(from: comps) ?? base
    }
    
    private static func generateRandomPastDate(
        daysBackLimit: Int,
        calendar: Calendar = Calendar.current
    ) -> Date {
        let daysBack = Int.random(in: 0...daysBackLimit)
        return calendar.date(byAdding: .day, value: -daysBack, to: Date()) ?? Date()
    }
    
    private static func generateRandomTimeComponent(for component: TimeComponent) -> Int {
        return Int.random(in: 0...component.upperLimit)
    }
}
