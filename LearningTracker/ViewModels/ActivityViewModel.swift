import Foundation
import Combine

final class ActivityViewModel: ObservableObject {
    @Published private(set) var today = Date.now
    @Published private(set) var goal: LearningGoal
    @Published private(set) var dayStatuses: [Date: ActivityStatus]
    @Published private(set) var outcome: GoalOutcome?

    private var graceDay: Date?
    private let calendar = Calendar.current
    private let allowedHours = 32

    init(goal: LearningGoal) {
        let saved = DataStore.load()
        self.goal = goal
        self.dayStatuses = saved.dayStatuses
        self.outcome = saved.outcome
        self.graceDay = saved.graceDay
        evaluate()
    }

    // MARK: - Dates

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
        calendar.isDate(date, inSameDayAs: today)
    }

    private var todayStart: Date { calendar.startOfDay(for: today) }
    private var goalStartDay: Date { calendar.startOfDay(for: goal.startDate) }

    private var goalEndExclusive: Date {
        switch goal.duration {
        case .week:  calendar.date(byAdding: .day, value: 7, to: goalStartDay) ?? goalStartDay
        case .month: calendar.date(byAdding: .month, value: 1, to: goalStartDay) ?? goalStartDay
        case .year:  calendar.date(byAdding: .year, value: 1, to: goalStartDay) ?? goalStartDay
        }
    }

    private var goalLastDay: Date {
        calendar.date(byAdding: .day, value: -1, to: goalEndExclusive) ?? goalStartDay
    }

    // MARK: - Status and counters

    func status(for date: Date) -> ActivityStatus? {
        dayStatuses[calendar.startOfDay(for: date)]
    }

    var todayStatus: ActivityStatus? { dayStatuses[todayStart] }

    var learnedDays: Int { count(of: .learned) }
    var freezedDays: Int { count(of: .frozen) }

    private func count(of status: ActivityStatus) -> Int {
        dayStatuses.filter {
            $0.key >= goalStartDay && $0.key <= goalLastDay && $0.value == status
        }.count
    }

    var freezeLimit: Int {
        switch goal.duration {
        case .week: 2
        case .month: 8
        case .year: 96
        }
    }

    var canLogLearnedToday: Bool {
        outcome == nil && todayStatus != .learned
    }

    var canFreezeToday: Bool {
        outcome == nil && todayStatus != .frozen && freezedDays < freezeLimit
    }

    // MARK: - Actions

    func logLearnedToday() {
        refresh()
        guard canLogLearnedToday else { return }
        setTodayStatus(.learned)
    }

    func freezeToday() {
        refresh()
        guard canFreezeToday else { return }
        setTodayStatus(.frozen)
    }

    func updateGoal(_ updatedGoal: LearningGoal) {
        goal = updatedGoal
        outcome = nil
        graceDay = nil
        dayStatuses[todayStart] = nil
        save()
    }

    func refresh() {
        let now = Date()
        if !calendar.isDate(today, inSameDayAs: now) {
            today = now
        }
        evaluate(now: now)
    }

    // MARK: - Rules

    private func setTodayStatus(_ status: ActivityStatus) {
        guard outcome == nil else { return }

        if todayStatus == nil, let missing = missingDayBeforeToday() {
            guard canUseAllowance(for: missing) else {
                fail()
                return
            }
            graceDay = missing
        }

        dayStatuses[todayStart] = status

        if todayStart >= goalLastDay {
            outcome = .completed
        }
        save()
    }

    private func missingDayBeforeToday() -> Date? {
        guard
            let yesterday = calendar.date(byAdding: .day, value: -1, to: todayStart),
            yesterday >= goalStartDay,
            dayStatuses[yesterday] == nil,
            yesterday != graceDay
        else {
            return nil
        }
        return yesterday
    }

    private func canUseAllowance(for day: Date) -> Bool {
        guard graceDay == nil else { return false }
        guard let deadline = calendar.date(byAdding: .hour, value: allowedHours, to: day) else {
            return false
        }
        return Date() < deadline
    }

    private func evaluate(now: Date = Date()) {
        guard outcome == nil else { return }

        var day = goalStartDay
        while day < todayStart {
            if dayStatuses[day] == nil,
               day != graceDay,
               let deadline = calendar.date(byAdding: .hour, value: allowedHours, to: day),
               now >= deadline {
                fail()
                return
            }
            guard let next = calendar.date(byAdding: .day, value: 1, to: day) else { break }
            day = next
        }
    }

    private func fail() {
        outcome = .failed
        save()
    }

    private func save() {
        var saved = DataStore.load()
        saved.goal = goal
        saved.dayStatuses = dayStatuses
        saved.outcome = outcome
        saved.graceDay = graceDay
        DataStore.save(saved)
    }
}
