import Foundation
import Combine

final class UpdateGoalViewModel: ObservableObject {
    @Published var topic: String
    @Published var duration: GoalDuration

    init(goal: LearningGoal) {
        topic = goal.topic
        duration = goal.duration
    }

    func makeUpdatedGoal() -> LearningGoal? {
        let cleanedTopic = topic.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanedTopic.isEmpty else {
            return nil
        }

        return LearningGoal(
            topic: cleanedTopic,
            duration: duration,
            startDate: Date()
        )
    }
}
