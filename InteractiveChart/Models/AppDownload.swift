//
//  AppDownload.swift
//  InteractiveChart
//
//  Created by Denys Nazymok on 16.12.2023.
//

import Foundation

struct AppDownload: Identifiable {
    let id: UUID = .init()
    let downloads: Double
    let date: Date
    
    var day: String {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        var stringWeekday: String {
            switch weekday {
            case 1:
                return "Mon"
            case 2:
                return "Tue"
            case 3:
                return "Wed"
            case 4:
                return "Thu"
            case 5:
                return "Fri"
            case 6:
                return "Sun"
            default:
                return "Sat"
            }
        }
        return stringWeekday
    }
    
    static let example: [AppDownload] = [
        .init(downloads: 300, date: .createDate(11, 12, 2023)),
        .init(downloads: 400, date: .createDate(12, 12, 2023)),
        .init(downloads: 250, date: .createDate(13, 12, 2023)),
        .init(downloads: 600, date: .createDate(14, 12, 2023)),
        .init(downloads: 500, date: .createDate(15, 12, 2023)),
        .init(downloads: 200, date: .createDate(16, 12, 2023)),
        .init(downloads: 140, date: .createDate(17, 12, 2023))
    ]
}

extension [AppDownload] {
    func findDownloads(_ on: String) -> Double? {
        if let download = self.first(where: {
            $0.day == on
        }) {
            return download.downloads
        }
        return nil
    }
    
    func findIndex(_ on: String) -> Int {
        if let index = self.firstIndex(where: {
            $0.day == on
        }) {
            return index
        }
        return 0
    }
}

