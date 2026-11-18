// LearningGoal.swift
import Foundation

enum GoalDuration: Codable {
    case week
    case month
    case year
}

struct LearningGoal: Codable {
    let topic: String
    let duration: GoalDuration
    let startDate: Date
}
