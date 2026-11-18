import SwiftUI

struct ContentView: View {
    @State private var learningGoal: LearningGoal? = DataStore.load().goal

    var body: some View {
        NavigationStack {
            if let goal = learningGoal {
                Activity(goal: goal)
            } else {
                Onboarding { goal in
                    var saved = DataStore.load()
                    saved.goal = goal
                    saved.outcome = nil
                    saved.graceDay = nil
                    DataStore.save(saved)
                    learningGoal = goal
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
