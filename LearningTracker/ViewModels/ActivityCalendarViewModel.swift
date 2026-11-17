import Foundation
import Combine

final class ActivityCalendarViewModel: ObservableObject {
    private let calendar = Calendar.current
    private let monthsBefore = 6
    private let monthsAfter = 6

    let weekdayHeaders = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]

    var currentMonth: Date {
        calendar.dateInterval(of: .month, for: Date())?.start ?? Date()
    }

    var months: [Date] {
        (-monthsBefore...monthsAfter).compactMap {
            calendar.date(byAdding: .month, value: $0, to: currentMonth)
        }
    }

    func title(for month: Date) -> String {
        month.formatted(
            .dateTime
                .month(.wide)
                .year()
                .locale(Locale(identifier: "en_GB"))
        )
    }

    func cells(for month: Date) -> [Date?] {
        let dayCount = calendar.range(of: .day, in: .month, for: month)?.count ?? 0
        let blankCount = calendar.component(.weekday, from: month) - 1

        let blanks: [Date?] = Array(repeating: nil, count: blankCount)
        let days: [Date?] = (0..<dayCount).map {
            calendar.date(byAdding: .day, value: $0, to: month)
        }
        return blanks + days
    }
}
