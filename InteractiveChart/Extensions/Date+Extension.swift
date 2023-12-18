//
//  Date+Extension.swift
//  InteractiveChart
//
//  Created by Denys Nazymok on 16.12.2023.
//

import Foundation

extension Date {
    static func createDate(_ day: Int, _ month: Int, _ year: Int) -> Date {
        let components = DateComponents(
            year: year,
            month: month,
            day: day
        )
        let calendar = Calendar.current
        let date = calendar.date(from: components) ?? .init()
        return date
    }
}
