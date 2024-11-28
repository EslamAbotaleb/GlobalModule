//
//  Date+Extensions.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 4/8/21.
//  Copyright © 2021 Youxel. All rights reserved.
//

import Foundation

let timeZone_UTC = TimeZone.current//TimeZone(abbreviation: "UTC")
let dateFormatterLocal_en_US = Locale(identifier: "en_US")
let dateFormatterLocal_ar_EG = Locale(identifier: "ar_DZ")

public extension Date{

    var toLocal: Date {
        let tz = NSTimeZone.local
        let sec = tz.secondsFromGMT(for: self)
        return Date(timeInterval: TimeInterval(sec), since: self)
    }

    func getDateFormatter(dateFormat: String) -> DateFormatter? {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = NSLocale(localeIdentifier: "EN") as Locale
        return dateFormatter
    }

    func getDateNextDay(spesficDate: Date) -> String? {
        var dayComponent    = DateComponents()
        dayComponent.day    = 1
        let theCalendar     = Calendar.current
        let nextDate        = theCalendar.date(byAdding: dayComponent, to: spesficDate)
        let formatter = DateFormatter()
        formatter.dateFormat =  "yyyy-MM-dd"

        let formatSpesficDate = formatter.date(from: formatter.string(from: nextDate!))
        return formatSpesficDate?.getDateWithDeviceLang(dateFormat: formatter.dateFormat)
    }

    func getDateWithDeviceLang(dateFormat: String) -> String? {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale

        formatter.dateFormat = dateFormat
        let outputDate = formatter.string(from: self)
        return outputDate
    }

    var startOfMonth: Date {

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }


    func setTime(hour: Int, min: Int, sec: Int, timeZoneAbbrev: String = "UTC") -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)

        components.timeZone = TimeZone(abbreviation: timeZoneAbbrev)
        components.hour = hour
        components.minute = min
        components.second = sec

        return cal.date(from: components)
    }

    func addingDays(days: Int)-> Date?{
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = days
        return Calendar.current.date(byAdding: dateComponent, to: currentDate)
    }

    func subtractDays(days: Int)-> Date?{
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = -days
        return Calendar.current.date(byAdding: dateComponent, to: currentDate)
    }

    func addDaysToSpecificDate(days: Int, date: Date) -> Date? {
        var dateComponent = DateComponents()
        dateComponent.day = days

        return Calendar.current.date(byAdding: dateComponent, to: date)
    }

    func addingMonths(months: Int)-> Date?{
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.month = months

        return Calendar.current.date(byAdding: dateComponent, to: currentDate)

    }

    func subtractMonths(months: Int)-> Date?{
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.month = -months

        return Calendar.current.date(byAdding: dateComponent, to: currentDate)
    }
    func getYear(min: Int) -> Date? {
        var components = Calendar.current.dateComponents([.year], from: Date())
        if let startDateOfYear = Calendar.current.date(from: components) {
            components.year = 0
            if let currentMonthNumber = Calendar.current.dateComponents([.month], from: Date()).month {
                components.month = currentMonthNumber - 1
            }
            components.day = -min
            let lastDateOfYear = Calendar.current.date(byAdding: components, to: startDateOfYear)
            return lastDateOfYear
        }
        return Date()
    }

    func addingMinutes(minutes: Int)-> Date?{
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.minute = minutes

        return Calendar.current.date(byAdding: dateComponent, to: currentDate)

    }

    func addMinTodate(minutes: Int) -> Date? {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)
    }

    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }

    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }

    func isSmallerThan(_ date: Date) -> Bool {
        return self < date
    }

    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let diff = Calendar.current.dateComponents([.day, .month, .hour, .minute, .second], from: previous, to: recent)
        return (month: diff.month, day: diff.day, hour: diff.hour, minute: diff.minute, second: diff.second)
    }


}

public extension Date {
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: self)
    }
    var fullMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
            dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
            dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: self)
    }
}

public extension Formatter {
    static let time: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter
    }()
}

public extension Formatter {
    func getNextDayFormatter() -> DateFormatter? {
        let date = Date()
        let dayDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
        let nextDayDateFormatter = dayDate?.getDateFormatter(dateFormat: "yyyy-MM-dd")
        return nextDayDateFormatter
    }
}
public extension Date {
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}


public extension Date {
    func daysBetween(date: Date) -> Double {
        return Date.daysBetween(start: self, end: date)
    }

    static func daysBetween(start: Date, end: Date) -> Double {
        let calendar = Calendar.current

        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)

        let a = calendar.dateComponents([.day], from: date1, to: date2)
        return Double(a.value(for: .day)!)
    }
}

public extension Date {
    static func dateFromCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.date(from: customString) ?? Date()
    }

    func reduceToMonthDayYear() -> Date {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let year = calendar.component(.year, from: self)
        let dateFormatter = DateFormatter()
        //MM/dd/yyyy
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.date(from: "\((year))/\(month)/\(day)") ?? Date()
    }




    static func TimeFromCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.date(from: customString) ?? Date()
    }
}

public extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return calendar.date(from: dateComponents) ?? nil
    }

    func firstMonthInYear(date: Date,minDuration: String = "0", maxDuration: String = "0", isFromDate: Bool? = false, fromDateSelect: Bool? = false,toDateSelect: Bool? = false) -> Date {
//        let getYear = Calendar.current.component(.year, from: date) + (Int(yearNumber ?? "0") ?? 0)
        let getYear =  Calendar.current.component(.year, from: date) + (Int(minDuration) ?? 0)

        var dateComponents = DateComponents()
        dateComponents.year = getYear
        dateComponents.month = 1
        if (isFromDate ?? false) {
            dateComponents.day = fromDateSelect ?? false ? Int(date.day) : 1
        } else if (isFromDate == false) {
            dateComponents.day = Int(date.day)

        }
        let calendar = Calendar.current
        let firstDayOfYear = calendar.date(from: dateComponents)!
        return firstDayOfYear
    }

    func getLastOfYear() -> Date? {
        let year = Calendar.current.component(.year, from: Date())
        let firstOfNextYear = Calendar.current.date(from: DateComponents(year: year + 1, month: 1, day: 1))
        let lastOfYear = Calendar.current.date(byAdding: .day, value: -1, to: firstOfNextYear!)
        return lastOfYear
    }

    func lastMonthInYear(yearNumber: String? = "0", isFromDate: Bool? = false) -> Date {
        var dateComponents = DateComponents()
        let getYear = Calendar.current.component(.year, from: Date()) + (Int(yearNumber ?? "0") ?? 0)
        dateComponents.year = getYear
        dateComponents.month = 12
        dateComponents.day = 31
        let calendar = Calendar.current
        let lastDayOfYear = calendar.date(from: dateComponents)!
        let lastMonth = calendar.date(byAdding: DateComponents(day: 0), to: lastDayOfYear)!
        return lastMonth
    }
}
