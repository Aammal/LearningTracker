import Foundation

enum GoalDuration {
    case week
    case month
    case year
}

struct LearningGoal {
    let topic: String
    let duration: GoalDuration
    let startDate: Date
}
