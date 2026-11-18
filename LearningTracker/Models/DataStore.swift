import Foundation

struct SavedData: Codable {
    var goal: LearningGoal?
    var dayStatuses: [Date: ActivityStatus] = [:]
    var outcome: GoalOutcome?
    var graceDay: Date?
}

enum DataStore {
    private static let key = "savedData"

    static func load() -> SavedData {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let saved = try? JSONDecoder().decode(SavedData.self, from: data)
        else {
            return SavedData()
        }
        return saved
    }

    static func save(_ saved: SavedData) {
        guard let data = try? JSONEncoder().encode(saved) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
