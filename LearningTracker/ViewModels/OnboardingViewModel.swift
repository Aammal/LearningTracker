import Foundation
import Combine

final class OnboardingViewModel: ObservableObject {
    @Published var topic = ""
    @Published var duration: GoalDuration = .week


    func createGoal() -> LearningGoal? {
        let cleanedTopic = topic.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanedTopic.isEmpty else { return nil }

        return LearningGoal(
            topic: cleanedTopic,
            duration: duration,
            startDate: Date()
        )
    }

   
}
