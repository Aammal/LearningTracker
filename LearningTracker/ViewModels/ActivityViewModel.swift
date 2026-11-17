import Foundation
import Combine

final class ActivityViewModel: ObservableObject {
    @Published private(set) var today = Date.now
    @Published private(set) var learnedDays = 0
    @Published private(set) var freezedDays = 0
    @Published private(set) var todayStatus: ActivityStatus? = nil
    @Published private(set) var goal: LearningGoal
    @Published private(set) var dayStatuses: [Date: ActivityStatus] = [:]

    var dateText: String {
        today.formatted(
            .dateTime
                .weekday(.wide)
                .day()
                .month(.wide)
                .locale(Locale(identifier: "en_GB"))
        )
    }
    let weekdayLetters = ["S", "M", "T", "W", "T", "F", "S"]

    var weekDates: [Date] {
        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: today)
        let weekdayNumber = calendar.component(.weekday, from: todayStart)
        let sunday = calendar.date(
            byAdding: .day,
            value: 1 - weekdayNumber,
            to: todayStart
        ) ?? todayStart

        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: sunday)
        }
    }

    func isToday(_ date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: today)
    }


    init(goal: LearningGoal) {
        self.goal = goal
    }

    var freezeLimit: Int {
        switch goal.duration {
        case .week: 2
        case .month: 8
        case .year: 96
        }
    }
    func status(for date: Date) -> ActivityStatus? {
        dayStatuses[Calendar.current.startOfDay(for: date)]
    }
    
    var canLogLearnedToday: Bool {
        todayStatus != .learned
    }

    var canFreezeToday: Bool {
        todayStatus != .frozen && freezedDays < freezeLimit
    }

    func logLearnedToday() {
        guard canLogLearnedToday else { return }

        if todayStatus == .frozen {
            freezedDays -= 1
        }
        todayStatus = .learned
        dayStatuses[Calendar.current.startOfDay(for: today)] = .learned
        learnedDays += 1
    }

    func freezeToday() {
        guard canFreezeToday else { return }

        if todayStatus == .learned {
            learnedDays -= 1
        }
        todayStatus = .frozen
        dayStatuses[Calendar.current.startOfDay(for: today)] = .frozen
        freezedDays += 1
    }

    func updateGoal(_ updatedGoal: LearningGoal) {
        goal = updatedGoal
        learnedDays = 0
        freezedDays = 0
        todayStatus = nil
        dayStatuses = [:]
    }
}
